import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ─── In-memory cache ──────────────────────────────────────────────────────────

class _CacheEntry {
  final dynamic data;
  final DateTime expiresAt;

  _CacheEntry(this.data, Duration ttl)
      : expiresAt = DateTime.now().add(ttl);

  bool get isValid => DateTime.now().isBefore(expiresAt);
}

class ApiService {
  static const String _baseUrl = 'https://backend.qiphlow.com';

  // Shared preferences keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserKey = 'user_key';

  // ─── Cache store ────────────────────────────────────────────────────────────

  static final Map<String, _CacheEntry> _cache = {};

  /// Synchronous check — use in initState to decide whether to show skeleton.
  static bool isCacheValid(String key) {
    final entry = _cache[key];
    return entry != null && entry.isValid;
  }

  static T? _fromCache<T>(String key) {
    final entry = _cache[key];
    if (entry != null && entry.isValid) return entry.data as T?;
    return null;
  }

  static void _toCache(String key, dynamic data, Duration ttl) {
    _cache[key] = _CacheEntry(data, ttl);
    _persistCacheEntry(key, data, ttl); // fire-and-forget — UI never waits on this
  }

  static void invalidate(String key) {
    _cache.remove(key);
    SharedPreferences.getInstance().then((p) => p.remove('$_diskCachePrefix$key'));
  }

  static void clearCache() {
    _cache.clear();
    SharedPreferences.getInstance().then((prefs) async {
      for (final k in prefs.getKeys()) {
        if (k.startsWith(_diskCachePrefix)) await prefs.remove(k);
      }
    });
  }

  // ─── Persistent cache (disk) ────────────────────────────────────────────────
  // The in-memory cache above is lost on every cold start, which means the
  // app always shows empty skeletons until the network responds — even when
  // we already fetched this exact data 30 seconds ago. Mirroring entries to
  // SharedPreferences (already a dependency) and hydrating them back into
  // memory at launch fixes that without changing any existing call site:
  // isCacheValid()/_fromCache() stay synchronous and keep working as-is,
  // they just now have real data in them sooner.

  static const String _diskCachePrefix = 'qf_cache_';

  static void _persistCacheEntry(String key, dynamic data, Duration ttl) {
    SharedPreferences.getInstance().then((prefs) {
      try {
        final payload = jsonEncode({
          'data': data,
          'expiresAt': DateTime.now().add(ttl).toIso8601String(),
        });
        prefs.setString('$_diskCachePrefix$key', payload);
      } catch (_) {
        // Non-JSON-serializable payload — just skip persistence for this entry.
      }
    });
  }

  /// Call once at app startup (before runApp) to repopulate the in-memory
  /// cache from disk, so the very first frame of every screen can already
  /// have last-known-good data instead of an empty skeleton.
  static Future<void> hydrateCache() async {
    final prefs = await SharedPreferences.getInstance();
    for (final prefKey in prefs.getKeys()) {
      if (!prefKey.startsWith(_diskCachePrefix)) continue;
      try {
        final raw = prefs.getString(prefKey);
        if (raw == null) continue;
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        final expiresAt = DateTime.parse(decoded['expiresAt'] as String);
        if (DateTime.now().isAfter(expiresAt)) {
          await prefs.remove(prefKey);
          continue;
        }
        final key = prefKey.substring(_diskCachePrefix.length);
        _cache[key] = _CacheEntry(
          decoded['data'],
          expiresAt.difference(DateTime.now()),
        );
      } catch (_) {
        await prefs.remove(prefKey); // corrupt/old-format entry — drop it
      }
    }
  }

  // ─── Token helpers ────────────────────────────────────────────────────────

  static Future<void> _saveSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, data['accessToken'] ?? '');
    await prefs.setString(_keyRefreshToken, data['refreshToken'] ?? '');
    final user = data['user'] as Map<String, dynamic>? ?? {};
    await prefs.setString(_keyUserId, user['id']?.toString() ?? '');
    await prefs.setString(_keyUserName, user['name'] ?? '');
    await prefs.setString(_keyUserEmail, user['email'] ?? '');
    await prefs.setString(_keyUserKey, user['user_key'] ?? '');
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserKey);
    clearCache();
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<Map<String, String>> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString(_keyUserId) ?? '',
      'name': prefs.getString(_keyUserName) ?? '',
      'email': prefs.getString(_keyUserEmail) ?? '',
      'user_key': prefs.getString(_keyUserKey) ?? '',
    };
  }

  // ─── HTTP helpers ─────────────────────────────────────────────────────────

  static Future<Map<String, String>> _authHeaders() async {
    final token = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Map<String, dynamic> _parse(http.Response response) {
    late Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      // Server returned HTML (gateway error, maintenance page, redirect, etc.)
      throw 'Server error (HTTP ${response.statusCode}). Please try again later.';
    }
    if (response.statusCode == 401) {
      throw 'Session expired. Please sign in again.';
    }
    if (!(body['success'] as bool? ?? false)) {
      throw body['message'] ?? 'An error occurred';
    }
    return body['data'] as Map<String, dynamic>? ?? body;
  }

  static Future<http.Response> _post(String path, Map<String, dynamic> body,
      {bool auth = true}) async {
    final headers =
        auth ? await _authHeaders() : {'Content-Type': 'application/json'};
    return http.post(
      Uri.parse('$_baseUrl$path'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> _get(String path) async {
    final headers = await _authHeaders();
    return http.get(Uri.parse('$_baseUrl$path'), headers: headers);
  }

  static Future<http.Response> _put(String path, Map<String, dynamic> body) async {
    final headers = await _authHeaders();
    return http.put(
      Uri.parse('$_baseUrl$path'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // ─── Auth ─────────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _post(
      '/api/auth/login',
      {'email': email, 'password': password},
      auth: false,
    );
    final data = _parse(response);
    await _saveSession(data);
    return data;
  }

  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _post(
      '/api/users',
      {'name': name, 'email': email, 'password': password},
      auth: false,
    );
    return _parse(response);
  }

  static Future<bool> signOut() async {
    try {
      await _post('/api/auth/logout', {});
    } catch (_) {}
    await clearSession();
    return true;
  }

  static Future<bool> sendPasswordResetEmail(String email) async {
    final response = await _post(
      '/api/auth/password/reset-request',
      {'email': email},
      auth: false,
    );
    _parse(response);
    return true;
  }

  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = await getCurrentUser();
    final response = await _post('/api/auth/password/change', {
      'userId': user['id'],
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
    _parse(response);
    return true;
  }

  // ─── Devices ──────────────────────────────────────────────────────────────

  static const _ttlDevices = Duration(minutes: 3);

  static Future<List<Map<String, dynamic>>> getDevices() async {
    const key = 'devices';
    final cached = _fromCache<List>(key);
    if (cached != null) return cached.cast<Map<String, dynamic>>();

    // Without this filter the backend returns every device in the system,
    // not just the signed-in user's.
    final user = await getCurrentUser();
    final userId = user['id'] ?? '';
    final path =
        userId.isNotEmpty ? '/api/devices?user_id=$userId' : '/api/devices';

    final response = await _get(path);
    final data = _parse(response);
    final list = (data['devices'] as List? ?? []).cast<Map<String, dynamic>>();
    _toCache(key, list, _ttlDevices);
    return list;
  }

  static Future<Map<String, dynamic>> getDevice(int id) async {
    final key = 'device_$id';
    final cached = _fromCache<Map<String, dynamic>>(key);
    if (cached != null) return cached;

    final response = await _get('/api/devices/$id');
    final data = _parse(response);
    _toCache(key, data, _ttlDevices);
    return data;
  }

  static Future<Map<String, dynamic>> createDevice({
    required String name,
    required String deviceKey,
    required String deviceSecret,
    String location = '',
    String? userId,
  }) async {
    invalidate('devices');
    final response = await _post('/api/devices', {
      'name': name,
      'device_key': deviceKey,
      'device_secret': deviceSecret,
      'location': location,
      if (userId != null && userId.isNotEmpty) 'user_id': userId,
    });
    return _parse(response);
  }

  static Future<Map<String, dynamic>> updateDevice(
    int id, {
    String? name,
    String? location,
  }) async {
    invalidate('devices');
    invalidate('device_$id');
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (location != null) body['location'] = location;
    final response = await _put('/api/devices/$id', body);
    return _parse(response);
  }

  // ─── IoT ──────────────────────────────────────────────────────────────────

  static const _ttlIotStatus = Duration(minutes: 1);

  static Future<Map<String, dynamic>> getDeviceStatus(String deviceKey) async {
    final key = 'iot_status_$deviceKey';
    final cached = _fromCache<Map<String, dynamic>>(key);
    if (cached != null) return cached;

    final response = await _get('/api/iot/status/$deviceKey');
    final data = _parse(response);
    _toCache(key, data, _ttlIotStatus);
    return data;
  }

  static Future<List<Map<String, dynamic>>> getCommandHistory(
      int deviceId) async {
    final key = 'commands_$deviceId';
    final cached = _fromCache<List>(key);
    if (cached != null) return cached.cast<Map<String, dynamic>>();

    final response = await _get('/api/iot/commands/$deviceId');
    final data = _parse(response);
    final list =
        (data['commands'] as List? ?? []).cast<Map<String, dynamic>>();
    _toCache(key, list, _ttlIotStatus);
    return list;
  }

  /// commandType: measure_now | start_pump | stop_pump | calibrate | restart | update_firmware | set_interval
  /// Only measure_now has a firmware-side handler today (see Firmware.md);
  /// the rest are accepted by the backend but the device ignores them.
  static Future<Map<String, dynamic>> sendCommand({
    required int deviceId,
    required String commandType,
    Map<String, dynamic> parameters = const {},
  }) async {
    // Commands are never cached — always hit the API
    final response = await _post('/api/iot/commands', {
      'device_id': deviceId,
      'command_type': commandType,
      'parameters': parameters,
    });
    return _parse(response);
  }

  // ─── Water / Sensors ──────────────────────────────────────────────────────

  static const _ttlSensor = Duration(minutes: 2);

  static Future<List<Map<String, dynamic>>> getTanks() async {
    const key = 'tanks';
    final cached = _fromCache<List>(key);
    if (cached != null) return cached.cast<Map<String, dynamic>>();

    final response = await _get('/api/water/tanks');
    final data = _parse(response);
    final list = (data['tanks'] as List? ?? []).cast<Map<String, dynamic>>();
    _toCache(key, list, const Duration(minutes: 5));
    return list;
  }

  static Future<Map<String, dynamic>?> getLatestSensorData(int tankId) async {
    final key = 'sensor_$tankId';
    final cached = _fromCache<Map<String, dynamic>>(key);
    if (cached != null) return cached;

    try {
      final response =
          await _get('/api/water/sensor-data/tank/$tankId/latest');
      final data = _parse(response);
      _toCache(key, data, _ttlSensor);
      return data;
    } catch (_) {
      return null;
    }
  }

  /// Returns sensor_data + contaminants (chlorine/nitrate/calcium/potassium/sodium/ammonium/magnesium) for a device.
  static Future<Map<String, dynamic>?> getLatestSensorDataByDevice(
      int deviceId) async {
    final key = 'sensor_device_$deviceId';
    final cached = _fromCache<Map<String, dynamic>>(key);
    if (cached != null) return cached;

    try {
      final response =
          await _get('/api/water/sensor-data/device/$deviceId/latest');
      final data = _parse(response);
      _toCache(key, data, _ttlSensor);
      return data;
    } catch (_) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> getSensorStatistics() async {
    const key = 'sensor_stats';
    final cached = _fromCache<Map<String, dynamic>>(key);
    if (cached != null) return cached;

    final response = await _get('/api/water/sensor-data/statistics');
    final data = _parse(response);
    _toCache(key, data, _ttlSensor);
    return data;
  }

  // ─── Analytics ────────────────────────────────────────────────────────────

  static const _ttlAnalytics = Duration(minutes: 5);

  static Future<Map<String, dynamic>> getDashboard() async {
    const key = 'dashboard';
    final cached = _fromCache<Map<String, dynamic>>(key);
    if (cached != null) return cached;

    final response = await _get('/api/analytics/dashboard');
    final data = _parse(response);
    _toCache(key, data, _ttlAnalytics);
    return data;
  }

  static Future<Map<String, dynamic>> getWaterConsumption({
    String? startDate,
    String? endDate,
  }) async {
    final key = 'water_consumption_${startDate ?? ''}_${endDate ?? ''}';
    final cached = _fromCache<Map<String, dynamic>>(key);
    if (cached != null) return cached;

    String path = '/api/analytics/water-consumption';
    final params = <String>[];
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');
    if (params.isNotEmpty) path += '?${params.join('&')}';

    final response = await _get(path);
    final data = _parse(response);
    _toCache(key, data, _ttlAnalytics);
    return data;
  }

  static Future<Map<String, dynamic>> getContaminantTrends() async {
    const key = 'contaminant_trends';
    final cached = _fromCache<Map<String, dynamic>>(key);
    if (cached != null) return cached;

    final response = await _get('/api/analytics/contaminants/trends');
    final data = _parse(response);
    _toCache(key, data, _ttlAnalytics);
    return data;
  }

  static Future<Map<String, dynamic>> getContaminantAlerts() async {
    const key = 'contaminant_alerts';
    final cached = _fromCache<Map<String, dynamic>>(key);
    if (cached != null) return cached;

    final response = await _get('/api/analytics/contaminants/alerts');
    final data = _parse(response);
    _toCache(key, data, _ttlAnalytics);
    return data;
  }

  // ─── Notifications ────────────────────────────────────────────────────────

  static const _ttlNotifications = Duration(minutes: 2);

  static Future<List<Map<String, dynamic>>> getNotifications() async {
    const key = 'notifications';
    final cached = _fromCache<List>(key);
    if (cached != null) return cached.cast<Map<String, dynamic>>();

    final user = await getCurrentUser();
    final userId = user['id'];
    if (userId == null || userId.isEmpty) return [];

    final response = await _get('/api/notifications/user/$userId');
    final data = _parse(response);
    final list =
        (data['notifications'] as List? ?? []).cast<Map<String, dynamic>>();
    _toCache(key, list, _ttlNotifications);
    return list;
  }

  static Future<int> getUnreadCount() async {
    const key = 'unread_count';
    final cached = _fromCache<int>(key);
    if (cached != null) return cached;

    final user = await getCurrentUser();
    final userId = user['id'];
    if (userId == null || userId.isEmpty) return 0;

    final response =
        await _get('/api/notifications/user/$userId/unread-count');
    final data = _parse(response);
    final count = (data['unread_count'] as num?)?.toInt() ?? 0;
    _toCache(key, count, _ttlNotifications);
    return count;
  }

  static Future<bool> markAllNotificationsRead() async {
    invalidate('notifications');
    invalidate('unread_count');
    final user = await getCurrentUser();
    final userId = user['id'];
    if (userId == null || userId.isEmpty) return false;
    final response = await _post(
      '/api/notifications/user/$userId/mark-all-read',
      {},
    );
    _parse(response);
    return true;
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key? key}) : super(key: key);

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deviceKeyController = TextEditingController();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _deviceKeyController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Only matters for direct-HTTP device auth, which this firmware never
  // uses (it authenticates via the trusted AWS IoT Rule instead) — the
  // backend still requires a secret to be provisioned, so we generate one.
  String _generateDeviceSecret() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    final secret = _generateDeviceSecret();
    try {
      final user = await ApiService.getCurrentUser();
      await ApiService.createDevice(
        name: _nameController.text.trim(),
        deviceKey: _deviceKeyController.text.trim(),
        deviceSecret: secret,
        location: _locationController.text.trim(),
        userId: user['id'],
      );
      if (!mounted) return;
      await _showSecretDialog(secret);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add device: $e'),
            backgroundColor: const Color(0xFFFF6B6B),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _showSecretDialog(String secret) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Device added',
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                color: Color(0xFF14103B))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Save this device secret somewhere safe — it won\'t be shown again. It\'s only needed if direct device authentication is set up later.',
              style: TextStyle(
                  fontFamily: 'Inter', fontSize: 13, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: SelectableText(
                secret,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done',
                style: TextStyle(fontFamily: 'Inter', color: Color(0xFF0052cc))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0052cc), size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add device',
          style: TextStyle(
              color: Color(0xFF14103B),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Register a device to your account using the device key printed on the unit.',
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    fontFamily: 'Inter',
                    height: 1.5),
              ),
              const SizedBox(height: 24),
              _buildLabel('Device Key'),
              const SizedBox(height: 8),
              _buildField(
                controller: _deviceKeyController,
                hint: 'qiphlow-testpcb-001',
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.length < 4) {
                    return 'Enter the device key printed on the unit (min 4 characters)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildLabel('Device Name'),
              const SizedBox(height: 8),
              _buildField(
                controller: _nameController,
                hint: 'Kitchen filter',
                validator: (v) => (v?.trim().length ?? 0) < 2
                    ? 'Enter a name (min 2 characters)'
                    : null,
              ),
              const SizedBox(height: 20),
              _buildLabel('Location (optional)'),
              const SizedBox(height: 8),
              _buildField(
                controller: _locationController,
                hint: 'Kitchen, 2nd floor',
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001a4d),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          'Add device',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: 'Inter'),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFAAAAAA),
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500),
      );

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            color: Color(0xFFAAAAAA), fontSize: 14, fontFamily: 'Inter'),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      style: const TextStyle(
          color: Color(0xFF14103B), fontSize: 14, fontFamily: 'Inter'),
    );
  }
}

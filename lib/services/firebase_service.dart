import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user data to Firestore (call this after successful auth)
  static Future<void> saveUserData({
    required String fullName,
    required String username,
    required String phone,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'fullName': fullName,
          'username': username,
          'phone': phone,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Sign Up with email and password
  static Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    required String username,
    required String phone,
  }) async {
    try {
      String? uid;

      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        uid = userCredential.user?.uid;
      } catch (e) {
        // Pigeon cast errors look like type cast errors, not FirebaseAuthExceptions.
        // The user was created — recover by checking currentUser.
        if (e.toString().contains('PigeonUserDetails') ||
            e.toString().contains('List<Object?>') ||
            e is TypeError) {
          print('Pigeon serialization error detected, recovering...');
          
          // Wait briefly for auth state to propagate
          await Future.delayed(const Duration(milliseconds: 800));
          uid = _auth.currentUser?.uid;

          if (uid == null) {
            // Auth state hasn't propagated yet — wait for it
            uid = await _auth
                .authStateChanges()
                .where((user) => user != null)
                .first
                .then((user) => user?.uid)
                .timeout(const Duration(seconds: 5), onTimeout: () => null);
          }

          if (uid == null) {
            throw 'Account may have been created. Please try signing in.';
          }
        } else {
          rethrow; // Real auth error
        }
      }

      if (uid == null) throw 'Failed to retrieve user ID after account creation.';

      // Store user data in Firestore
      try {
        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'email': email,
          'fullName': fullName,
          'username': username,
          'phone': phone,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } catch (firestoreError) {
        print('Firestore error (non-critical): $firestoreError');
      }

      return true;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      if (e is String) rethrow;
      print('Sign up error: $e');
      throw 'An error occurred during sign up. Please try again.';
    }
  }

  // Sign In with email and password
  static Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      try {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        // Pigeon cast errors look like type cast errors, not FirebaseAuthExceptions.
        // The user was signed in — recover by checking currentUser.
        if (e.toString().contains('PigeonUserDetails') ||
            e.toString().contains('List<Object?>') ||
            e is TypeError) {
          print('Pigeon serialization error detected during sign in, recovering...');
          
          // Wait briefly for auth state to propagate
          await Future.delayed(const Duration(milliseconds: 800));
          
          if (_auth.currentUser == null) {
            // Auth state hasn't propagated yet — wait for it
            await _auth
                .authStateChanges()
                .where((user) => user != null)
                .first
                .timeout(const Duration(seconds: 5), onTimeout: () => null);
          }

          if (_auth.currentUser == null) {
            throw 'Sign in failed. Please try again.';
          }
        } else {
          rethrow; // Real auth error
        }
      }

      return true;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      if (e is String) rethrow;
      print('Sign in error: $e');
      throw 'An error occurred during sign in. Please try again.';
    }
  }

  // Send password reset email
  static Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign Out
  static Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      throw 'Failed to sign out';
    }
  }

  // Get user data from Firestore
  static Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw 'Failed to fetch user data';
    }
  }

  // Update user data
  static Future<bool> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(uid).update(data);
      return true;
    } catch (e) {
      throw 'Failed to update user data';
    }
  }

  // Handle Firebase Auth exceptions
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}

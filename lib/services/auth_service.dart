import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../core/constants/app_constants.dart';
import '../models/student.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  String _normalize(String email) => email.trim().toLowerCase();

  void _checkDomain(String email) {
    if (!email.endsWith(AuthConstants.allowedEmailDomain)) {
      throw FirebaseAuthException(
        code: 'invalid-domain',
        message: 'Please use your ${AuthConstants.allowedEmailDomain} email.',
      );
    }
  }

  /// Account তৈরি করে, profile Firestore-এ রাখে, verification email পাঠায়।
  Future<void> register({
    required String name,
    required String studentId,
    required String email,
    required String password,
    required String department,
    String? batch,
  }) async {
    final mail = _normalize(email);
    _checkDomain(mail);

    final cred = await _auth.createUserWithEmailAndPassword(
      email: mail,
      password: password,
    );
    final user = cred.user!;

    final student = Student(
      id: user.uid,
      name: name.trim(),
      studentId: studentId.trim(),
      email: mail,
      department: department,
      batch: (batch == null || batch.trim().isEmpty) ? null : batch.trim(),
    );

    try {
      await _db.collection('students').doc(user.uid).set(student.toMap());
    } catch (_) {
      // Profile save না হলে account মুছে দিই, যাতে একই email আবার ব্যবহার করা যায়
      await user.delete();
      rethrow;
    }

    try {
      await user.sendEmailVerification();
    } catch (_) {
      // Verification screen-এ Resend button আছে
    }
  }

  /// Login করে। Email verified হলে true, না হলে false।
  Future<bool> signIn(String email, String password) async {
    final mail = _normalize(email);
    _checkDomain(mail);

    final cred = await _auth.signInWithEmailAndPassword(
      email: mail,
      password: password,
    );
    if (cred.user == null) return false;

    await cred.user!.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  /// Server থেকে সর্বশেষ অবস্থা এনে দেখে email verified কি না।
  Future<bool> refreshVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    await user.reload();
    final fresh = _auth.currentUser;
    if (fresh != null && fresh.emailVerified) {
      // Token refresh, যাতে Firestore rules email_verified = true দেখে
      await fresh.getIdToken(true);
      return true;
    }
    return false;
  }

  /// Splash screen ব্যবহার করবে: session আছে এবং email verified?
  Future<bool> hasVerifiedSession() async {
    final user = await _auth.authStateChanges().first;
    if (user == null) return false;

    try {
      await user.reload();
    } on FirebaseAuthException catch (e) {
      const dead = {'user-not-found', 'user-disabled', 'user-token-expired'};
      if (dead.contains(e.code)) {
        await _auth.signOut();
        return false;
      }
      // অন্য error (যেমন internet নেই): আগের saved অবস্থাই ধরে নিই
    }
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> resendVerificationEmail() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  Future<void> signOut() => _auth.signOut();

  Future<Student?> getCurrentStudent() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _db.collection('students').doc(user.uid).get();
    final data = doc.data();
    return data == null
        ? null
        : Student.fromMap(user.uid, data, isVerified: user.emailVerified);
  }

  /// যেকোনো error থেকে user-friendly message
  static String messageFor(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-domain':
          return error.message ?? 'Use your university email.';
        case 'email-already-in-use':
          return 'This email is already registered. Please log in.';
        case 'weak-password':
          return 'Password is too weak. Use at least '
              '${AuthConstants.minPasswordLength} characters.';
        case 'invalid-email':
          return 'Enter a valid email address.';
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          return 'Incorrect email or password.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a little and try again.';
        case 'network-request-failed':
          return 'No internet connection.';
        default:
          return error.message ?? 'Something went wrong. Please try again.';
      }
    }
    if (error is FirebaseException && error.code == 'permission-denied') {
      return 'Permission denied. Check your Firestore rules.';
    }
    return 'Something went wrong. Please try again.';
  }
}
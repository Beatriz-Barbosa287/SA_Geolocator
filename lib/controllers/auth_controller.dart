import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';

class AuthController {
  AuthController._private();
  static final AuthController instance = AuthController._private();

  final _auth = firebase_auth.FirebaseAuth.instance;

  // Valida se o e‑mail termina com @cargo.connect.com
  bool _isAllowedDomain(String email) {
    final e = email.trim().toLowerCase();
    final allowed = RegExp(r'^[^@]+@cargo\.connect\.com$');
    return allowed.hasMatch(e);
  }

  // Retorna o usuário atual do Firebase Auth
  firebase_auth.User? currentUser() {
    return _auth.currentUser;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Registro usando apenas Firebase Auth
  Future<firebase_auth.User> register({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!_isAllowedDomain(normalizedEmail)) {
      throw Exception('E-mail deve terminar com @cargo.connect.com');
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      return credential.user!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint(
        'FirebaseAuthException in register: code=${e.code}, message=${e.message}',
      );
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('E-mail já cadastrado');
        case 'weak-password':
          throw Exception('Senha fraca');
        default:
          throw Exception('Erro no registro: ${e.message}');
      }
    }
  }

  // Login usando Firebase Auth
  Future<firebase_auth.User> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!_isAllowedDomain(normalizedEmail)) {
      throw Exception('E-mail deve terminar com @cargo.connect.com');
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      return credential.user!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint(
        'FirebaseAuthException in login: code=${e.code}, message=${e.message}',
      );
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          throw Exception('Credenciais inválidas');
        default:
          throw Exception('Erro no login: ${e.message}');
      }
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:navi/services/servicio_api.dart';

/// Perfil de NAVI (Firestore) devuelto por el backend tras login/registro.
class PerfilNavi {
  final String name;
  final String email;
  final String phone;
  final String role;

  PerfilNavi({required this.name, required this.email, required this.phone, required this.role});

  factory PerfilNavi.fromJson(Map<String, dynamic> json) => PerfilNavi(
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        role: json['role'] ?? '',
      );
}

class ServicioAutenticacion {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ServicioApi _api = ServicioApi();

  User? get usuarioActual => _auth.currentUser;

  Stream<User?> get cambiosDeSesion => _auth.authStateChanges();

  /// Crea la cuenta en Firebase Auth y su perfil (rol "cliente") en el backend.
  Future<PerfilNavi> registrar({
    required String nombre,
    required String email,
    required String password,
    String? telefono,
  }) async {
    try {
      final credencial = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await credencial.user?.updateDisplayName(nombre);

      final respuesta = await _api.post('/api/auth/register', {
        'name': nombre,
        if (telefono != null && telefono.isNotEmpty) 'phone': telefono,
      });

      return PerfilNavi.fromJson(respuesta['perfil']);
    } on FirebaseAuthException catch (error) {
      throw Exception(_mensajeDeError(error.code));
    }
  }

  /// Inicia sesión con Firebase Auth y obtiene el perfil desde el backend.
  ///
  /// Si la cuenta de Firebase Auth existe pero no tiene perfil en Firestore
  /// (por ejemplo, porque el registro se interrumpió a medias la primera
  /// vez), se crea el perfil automáticamente en vez de dejar la cuenta
  /// atorada en ese estado.
  Future<PerfilNavi> iniciarSesion({required String email, required String password}) async {
    try {
      final credencial = await _auth.signInWithEmailAndPassword(email: email, password: password);

      try {
        final respuesta = await _api.get('/api/auth/me');
        return PerfilNavi.fromJson(respuesta['perfil']);
      } on ExcepcionApi catch (error) {
        if (error.statusCode != 404) rethrow;

        final nombre = credencial.user?.displayName ?? email.split('@').first;
        final respuesta = await _api.post('/api/auth/register', {'name': nombre});
        return PerfilNavi.fromJson(respuesta['perfil']);
      }
    } on FirebaseAuthException catch (error) {
      throw Exception(_mensajeDeError(error.code));
    }
  }

  bool _googleInicializado = false;

  /// Inicia sesión con Google: en Web abre el popup oficial de Google
  /// (nuestro propio botón morado solo lo dispara); en Android/iOS usa el
  /// SDK nativo de Google Sign-In. En ambos casos, igual que con correo y
  /// contraseña, si la cuenta no tiene perfil en Firestore se crea aquí.
  Future<PerfilNavi> iniciarSesionConGoogle() async {
    try {
      final UserCredential credencial;

      if (kIsWeb) {
        credencial = await _auth.signInWithPopup(GoogleAuthProvider());
      } else {
        if (!_googleInicializado) {
          await GoogleSignIn.instance.initialize();
          _googleInicializado = true;
        }

        final cuenta = await GoogleSignIn.instance.authenticate();
        final idToken = cuenta.authentication.idToken;
        credencial = await _auth.signInWithCredential(GoogleAuthProvider.credential(idToken: idToken));
      }

      try {
        final respuesta = await _api.get('/api/auth/me');
        return PerfilNavi.fromJson(respuesta['perfil']);
      } on ExcepcionApi catch (error) {
        if (error.statusCode != 404) rethrow;

        final nombre = credencial.user?.displayName ?? credencial.user?.email?.split('@').first ?? 'Cliente';
        final respuesta = await _api.post('/api/auth/register', {'name': nombre});
        return PerfilNavi.fromJson(respuesta['perfil']);
      }
    } on FirebaseAuthException catch (error) {
      throw Exception(_mensajeDeError(error.code));
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw Exception('Inicio de sesión cancelado');
      }
      throw Exception('No se pudo iniciar sesión con Google');
    }
  }

  Future<void> cerrarSesion() => _auth.signOut();

  Future<PerfilNavi> obtenerPerfil() async {
    final respuesta = await _api.get('/api/auth/me');
    return PerfilNavi.fromJson(respuesta['perfil']);
  }

  /// Edita nombre/teléfono en Firestore (PUT /api/auth/me); solo sobre la
  /// propia cuenta, nunca sobre otro uid.
  Future<PerfilNavi> actualizarPerfil({String? nombre, String? telefono}) async {
    final cuerpo = <String, dynamic>{
      if (nombre != null && nombre.isNotEmpty) 'name': nombre,
      if (telefono != null && telefono.isNotEmpty) 'phone': telefono,
    };

    final respuesta = await _api.put('/api/auth/me', cuerpo);
    final perfil = PerfilNavi.fromJson(respuesta['perfil']);

    if (nombre != null && nombre.isNotEmpty) {
      await _auth.currentUser?.updateDisplayName(nombre);
    }

    return perfil;
  }

  /// Manda el correo de restablecimiento de contraseña de Firebase; nunca
  /// manejamos la contraseña actual/nueva nosotros mismos.
  Future<void> enviarCorreoDeRecuperacion(String email) => _auth.sendPasswordResetEmail(email: email);

  String _mensajeDeError(String codigo) {
    switch (codigo) {
      case 'email-already-in-use':
        return 'Ese correo ya tiene una cuenta';
      case 'invalid-email':
        return 'Correo inválido';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos';
      case 'too-many-requests':
        return 'Demasiados intentos, intenta más tarde';
      default:
        return 'No se pudo completar la operación';
    }
  }
}

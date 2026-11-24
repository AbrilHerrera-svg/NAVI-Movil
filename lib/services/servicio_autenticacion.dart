import 'package:firebase_auth/firebase_auth.dart';
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
  Future<PerfilNavi> iniciarSesion({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final respuesta = await _api.get('/api/auth/me');
      return PerfilNavi.fromJson(respuesta['perfil']);
    } on FirebaseAuthException catch (error) {
      throw Exception(_mensajeDeError(error.code));
    }
  }

  Future<void> cerrarSesion() => _auth.signOut();

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

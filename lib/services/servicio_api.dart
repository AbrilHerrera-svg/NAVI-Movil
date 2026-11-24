import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:navi/services/configuracion_api.dart';

/// Llama al backend de NAVI-web adjuntando el idToken de Firebase Auth del
/// usuario que inició sesión en la app.
class ServicioApi {
  Future<Map<String, String>> _encabezados() async {
    final usuario = FirebaseAuth.instance.currentUser;
    final token = await usuario?.getIdToken();

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String ruta) async {
    final respuesta = await http.get(
      Uri.parse('${ConfiguracionApi.urlBase}$ruta'),
      headers: await _encabezados(),
    );
    return _procesar(respuesta);
  }

  Future<dynamic> post(String ruta, Map<String, dynamic> cuerpo) async {
    final respuesta = await http.post(
      Uri.parse('${ConfiguracionApi.urlBase}$ruta'),
      headers: await _encabezados(),
      body: jsonEncode(cuerpo),
    );
    return _procesar(respuesta);
  }

  dynamic _procesar(http.Response respuesta) {
    final datos = respuesta.body.isEmpty ? {} : jsonDecode(respuesta.body);

    if (respuesta.statusCode >= 400) {
      throw Exception(datos['mensaje'] ?? 'Error del servidor');
    }

    return datos;
  }
}

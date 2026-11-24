import 'package:navi/models/negocio.dart';
import 'package:navi/services/servicio_api.dart';

/// Datos del negocio (nombre/dirección de la única sucursal) desde
/// GET /api/settings/business. Se cachean en memoria porque no cambian
/// durante la sesión.
class ServicioNegocio {
  static Negocio? _cache;

  final ServicioApi _api = ServicioApi();

  Future<Negocio> obtenerNegocio() async {
    final cache = _cache;
    if (cache != null) return cache;

    final respuesta = await _api.get('/api/settings/business');
    final negocio = respuesta is Map<String, dynamic>
        ? Negocio.fromJson(respuesta)
        : const Negocio(nombre: '', direccion: '');

    _cache = negocio;
    return negocio;
  }
}

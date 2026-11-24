import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:navi/services/servicio_api.dart';

/// Permiso + token de notificaciones push (Firebase Cloud Messaging). El
/// token se manda al backend (PUT /api/auth/fcm-token) para que NAVI-web
/// pueda avisarle al cliente cuando cambia el estado de su pedido, o mandar
/// un anuncio manual.
class ServicioNotificaciones {
  final FirebaseMessaging _mensajeria = FirebaseMessaging.instance;
  final ServicioApi _api = ServicioApi();

  /// Pide permiso, registra el token actual y se queda escuchando cuando
  /// Firebase lo renueve. Si el usuario no da permiso, simplemente no hay
  /// notificaciones (no se trata como error).
  ///
  /// En Web no hace nada todavía: FCM en Web necesita una llave VAPID y un
  /// service worker que no están configurados (solo se pidió para
  /// Android/iOS por ahora).
  Future<void> iniciar() async {
    if (kIsWeb) return;

    final permiso = await _mensajeria.requestPermission();
    if (permiso.authorizationStatus == AuthorizationStatus.denied) return;

    // Nota: getToken()/onTokenRefresh están marcados deprecated en favor de
    // register()/onRegistered, pero ese reemplazo entrega un Installation ID
    // (FID) pensado para "direct send", no el token clásico de FCM que
    // espera getMessaging().send({token: ...}) del Admin SDK del backend.
    // Mientras el backend siga usando ese token clásico, este es el camino
    // correcto aunque el analyzer lo marque.
    // ignore: deprecated_member_use
    final token = await _mensajeria.getToken();
    if (token != null) await _registrarToken(token);

    // ignore: deprecated_member_use
    _mensajeria.onTokenRefresh.listen(_registrarToken);
  }

  Future<void> _registrarToken(String token) async {
    try {
      await _api.put('/api/auth/fcm-token', {'token': token});
    } catch (_) {
      // Si falla (ej. sin sesión todavía), no es crítico: se reintenta en
      // el próximo onTokenRefresh o la próxima vez que se llame iniciar().
    }
  }

  /// Mensajes que llegan con la app abierta (en primer plano); en segundo
  /// plano o cerrada, el sistema operativo ya muestra la notificación solo.
  void alRecibirEnPrimerPlano(void Function(RemoteMessage mensaje) manejador) {
    FirebaseMessaging.onMessage.listen(manejador);
  }
}

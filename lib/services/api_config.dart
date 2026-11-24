import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// URL base del backend de NAVI-web (Express). El emulador de Android no
/// puede usar "localhost" para llegar a la máquina host: usa el alias
/// 10.0.2.2. En un dispositivo físico, cambia esto por la IP de tu
/// computadora en la red local (ej. "http://192.168.1.50:3000").
class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000';
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }
}

import 'dart:io';

import 'package:meupet_server/meupet_server.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

/// Sobe a API mock do MeuPet+.
///
/// ```bash
/// cd server
/// dart pub get
/// dart run bin/server.dart
/// ```
///
/// Fica em http://localhost:8080 — o app aponta para lá por padrão
/// (emulador Android usa http://10.0.2.2:8080).
Future<void> main() async {
  final server = await shelf_io.serve(
    buildApp(),
    InternetAddress.loopbackIPv4,
    8080,
  );
  stdout.writeln('MeuPet+ API mock rodando em http://${server.address.host}:${server.port}');
  stdout.writeln('Login de teste: ana@exemplo.com / 123456');
}

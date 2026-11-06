import 'dart:convert';
import 'dart:io';

import 'package:meupet_core/meupet_core.dart';

/// [SessionStorage] do app: guarda a sessão como JSON num arquivo na pasta
/// temporária do sistema.
///
/// Dart puro (dart:io), sem plugin — mesmo motivo da referência: funciona
/// mesmo em PCs onde o Windows não deixa ativar o Modo de Desenvolvedor.
/// Na web usamos [InMemorySessionStorage] (não há dart:io).
class FileSessionStorage implements SessionStorage {
  FileSessionStorage({Directory? directory})
    : _file = File(
        '${(directory ?? Directory.systemTemp).path}'
        '${Platform.pathSeparator}meu_pet_session.json',
      );

  final File _file;

  @override
  Future<Session?> read() async {
    try {
      if (!await _file.exists()) return null;
      final raw = await _file.readAsString();
      return Session.fromJson(asJson(jsonDecode(raw)));
    } catch (_) {
      // Arquivo corrompido ou de outra versão: trata como "sem sessão".
      await clear();
      return null;
    }
  }

  @override
  Future<void> write(Session session) async {
    await _file.writeAsString(jsonEncode(session.toJson()), flush: true);
  }

  @override
  Future<void> clear() async {
    try {
      if (await _file.exists()) await _file.delete();
    } catch (_) {
      // Nada a fazer: sem arquivo, sem sessão.
    }
  }
}

import '../../app/app_navigator.dart';

/// Navigation out of the record form scene.
abstract interface class RecordFormCoordinator {
  /// Volta para o detalhe do pet. [created] diz se um registro foi salvo
  /// (o detalhe recarrega a aba correspondente nesse caso).
  void goBack({required bool created});
}

class DefaultRecordFormCoordinator implements RecordFormCoordinator {
  @override
  void goBack({required bool created}) {
    appNavigatorKey.currentState?.pop(created);
  }
}

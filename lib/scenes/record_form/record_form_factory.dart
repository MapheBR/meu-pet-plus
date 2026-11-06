import 'package:flutter/widgets.dart';

import 'record_form_coordinator.dart';
import 'record_form_view.dart';
import 'record_form_view_model.dart';
import 'record_kind.dart';
import 'server_record_form.dart';

/// Assembles the record form scene for [kind] and [petId], injecting
/// dependencies into the ViewModel.
abstract final class RecordFormFactory {
  static Widget make(RecordKind kind, String petId) {
    final viewModel = RecordFormViewModel(
      kind: kind,
      petId: petId,
      server: RecordFormServer(),
      coordinator: DefaultRecordFormCoordinator(),
    );
    return RecordFormView(viewModel: viewModel);
  }
}

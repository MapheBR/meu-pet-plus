import 'package:flutter/material.dart';

/// Kind of record created by the "+" button of the pet detail tabs.
/// Uma cena de formulário atende os três tipos (mesmo padrão visual).
enum RecordKind {
  vaccine('Nova vacina', 'Salvar vacina', Icons.vaccines),
  consultation('Nova consulta', 'Salvar consulta', Icons.medical_services),
  weight('Novo peso', 'Salvar peso', Icons.monitor_weight);

  const RecordKind(this.title, this.saveLabel, this.icon);

  /// Title of the form and of the app bar.
  final String title;

  /// Label of the footer button ("Salvar vacina", "Salvar pet"...).
  final String saveLabel;

  /// Icon shown on the form's submit context.
  final IconData icon;
}

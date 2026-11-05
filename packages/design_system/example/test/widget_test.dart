import 'package:flutter_test/flutter_test.dart';
import 'package:meupet_gallery/main.dart';

void main() {
  testWidgets('Galeria abre e mostra o menu de componentes', (tester) async {
    await tester.pumpWidget(const GalleryApp());
    await tester.pumpAndSettle();

    expect(find.text('MeuPet+'), findsOneWidget);
    expect(find.text('Tokens'), findsOneWidget);
    expect(find.text('Botões'), findsOneWidget);
    expect(find.text('Cards e chips'), findsOneWidget);
    expect(find.text('Estados'), findsOneWidget);
  });
}

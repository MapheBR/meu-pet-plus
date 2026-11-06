import 'package:flutter_test/flutter_test.dart';
import 'package:meu_pet_plus/main.dart';

void main() {
  testWidgets('App abre na Splash com a marca MeuPet+', (tester) async {
    await tester.pumpWidget(const MeuPetApp());
    await tester.pump();
    // Splash do protótipo: logo + slogan, sem barra de app.
    expect(
      find.text('Amor, cuidado e carinho em cada patinha.'),
      findsOneWidget,
    );
  });
}

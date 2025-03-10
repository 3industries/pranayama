import 'package:flutter_test/flutter_test.dart';
// Aggiorna l'import per puntare al file main.dart corretto
import 'package:pranayama_app/main.dart';

void main() {
  testWidgets('Smoke test for PranayamaApp', (WidgetTester tester) async {
    // Costruisci l'app e triggera un frame.
    await tester.pumpWidget(PranayamaApp());

    // Verifica che l'app contenga il titolo (modifica il testo se necessario)
    expect(find.text('Pranayama App'), findsOneWidget);
  });
}

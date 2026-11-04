import 'package:flutter_test/flutter_test.dart';

import 'package:navi/main.dart';

void main() {
  testWidgets('La app arranca y muestra el splash', (WidgetTester tester) async {
    await tester.pumpWidget(const NaviApp());

    expect(find.text('Navi'), findsOneWidget);
  });
}

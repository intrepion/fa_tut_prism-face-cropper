import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:prism_face_cropper/adapter/prism_face_cropper_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders the cropper page title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PrismFaceCropperPage()));
    await tester.pumpAndSettle();

    expect(find.text('Prism Face Cropper'), findsOneWidget);
  });
}

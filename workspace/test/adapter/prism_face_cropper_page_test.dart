import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_face_cropper/adapter/prism_face_cropper_page.dart';

void main() {
  testWidgets('renders six face preview slots from the crop plan', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PrismFaceCropperPage()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('preview-front')), findsOneWidget);
    expect(find.byKey(const Key('preview-back')), findsOneWidget);
    expect(find.byKey(const Key('preview-left')), findsOneWidget);
    expect(find.byKey(const Key('preview-right')), findsOneWidget);
    expect(find.text('front | 30, 21, 90, 84'), findsOneWidget);

    await tester.scrollUntilVisible(find.byKey(const Key('preview-top')), 300);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('preview-top')), findsOneWidget);
    expect(find.byKey(const Key('preview-bottom')), findsOneWidget);
    expect(find.text('bottom | missing'), findsOneWidget);
  });
}

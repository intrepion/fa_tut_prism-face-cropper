# Adapter

### 1. Red: Add The Prism Face Cropper Page Widget Test

Create the widget test file:

```bash
mkdir -p workspace/test/adapter
touch workspace/test/adapter/prism_face_cropper_page_test.dart
just format
git add --all
git commit --message 'touch workspace/test/adapter/prism_face_cropper_page_test.dart'
```

Put this exact content in `workspace/test/adapter/prism_face_cropper_page_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_face_cropper/adapter/prism_face_cropper_page.dart';

void main() {
  testWidgets('renders six face preview slots from the crop plan', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: PrismFaceCropperPage()),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('preview-front')), findsOneWidget);
    expect(find.byKey(const Key('preview-back')), findsOneWidget);
    expect(find.byKey(const Key('preview-left')), findsOneWidget);
    expect(find.byKey(const Key('preview-right')), findsOneWidget);
    expect(find.byKey(const Key('preview-top')), findsOneWidget);
    expect(find.byKey(const Key('preview-bottom')), findsOneWidget);

    expect(find.text('front | 30, 21, 90, 84'), findsOneWidget);
    expect(find.text('bottom | missing'), findsOneWidget);
  });
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "1. Red: Add The Prism Face Cropper Page Widget Test"
```

### 2. Green: Build The Prism Face Cropper Page

Create the page production file:

```bash
mkdir -p workspace/lib/adapter
touch workspace/lib/adapter/prism_face_cropper_page.dart
just format
git add --all
git commit --message 'touch workspace/lib/adapter/prism_face_cropper_page.dart'
```

Put this exact content in `workspace/lib/adapter/prism_face_cropper_page.dart`:

```dart
import 'package:flutter/material.dart';

import '../code/prism_face_cropper_service.dart';
import '../contracts/face_crop_plan.dart';
import '../contracts/face_selection_validation.dart';
import '../contracts/normalized_rect.dart';

class PrismFaceCropperPage extends StatelessWidget {
  const PrismFaceCropperPage({super.key});

  static const _imageWidth = 300;
  static const _imageHeight = 210;

  Map<String, NormalizedRect?> _demoSelectionMap() {
    return {
      'front': const NormalizedRect(
        left: 0.10,
        top: 0.10,
        width: 0.30,
        height: 0.40,
      ),
      'right': const NormalizedRect(
        left: 0.45,
        top: 0.10,
        width: 0.20,
        height: 0.40,
      ),
      'top': const NormalizedRect(
        left: 0.10,
        top: 0.00,
        width: 0.30,
        height: 0.10,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final selectionMap = _demoSelectionMap();
    final validation = validateFaceSelectionMap(selectionMap);
    final cropPlan = buildFaceCropPlan(
      imageWidth: _imageWidth,
      imageHeight: _imageHeight,
      faceSelectionMap: selectionMap,
    );
    final summaries = formatFaceCropSummary(cropPlan);

    return Scaffold(
      appBar: AppBar(title: const Text('Prism Face Cropper')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Present: ${validation.presentFaces.join(", ")}'),
            Text('Missing: ${validation.missingFaces.join(", ")}'),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.25,
                children: [
                  for (var index = 0; index < cropPlan.length; index++)
                    _FacePreviewCard(
                      key: Key('preview-${cropPlan[index].faceName}'),
                      plan: cropPlan[index],
                      summary: summaries[index],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FacePreviewCard extends StatelessWidget {
  final FaceCropPlan plan;
  final String summary;

  const _FacePreviewCard({
    super.key,
    required this.plan,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plan.faceName, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.brown),
                  color: const Color(0xFFF8F0D8),
                ),
                child: Center(
                  child: plan.isMissing
                      ? const Text('missing')
                      : ClipRect(
                          child: FittedBox(
                            alignment: Alignment.topLeft,
                            fit: BoxFit.contain,
                            child: SizedBox(
                              width: plan.pixelWidth.toDouble(),
                              height: plan.pixelHeight.toDouble(),
                              child: Transform.translate(
                                offset: Offset(
                                  -plan.pixelLeft.toDouble(),
                                  -plan.pixelTop.toDouble(),
                                ),
                                child: const SizedBox(
                                  width: 300,
                                  height: 210,
                                  child: _CerealBoxSheetArtwork(),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(summary),
          ],
        ),
      ),
    );
  }
}

class _CerealBoxSheetArtwork extends StatelessWidget {
  const _CerealBoxSheetArtwork();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Positioned.fill(
          child: ColoredBox(color: Color(0xFFF9E4B7)),
        ),
        Positioned(
          left: 30,
          top: 0,
          width: 90,
          height: 21,
          child: _FacePanel(label: 'top', color: Color(0xFFF7C873)),
        ),
        Positioned(
          left: 30,
          top: 21,
          width: 90,
          height: 84,
          child: _FacePanel(label: 'front', color: Color(0xFFE9875A)),
        ),
        Positioned(
          left: 135,
          top: 21,
          width: 60,
          height: 84,
          child: _FacePanel(label: 'right', color: Color(0xFF7DB4D8)),
        ),
      ],
    );
  }
}

class _FacePanel extends StatelessWidget {
  final String label;
  final Color color;

  const _FacePanel({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black54),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "2. Green: Build The Prism Face Cropper Page"
```

### 3. Red: Add The Integration Test

Create the integration test file:

```bash
mkdir -p workspace/integration_test
touch workspace/integration_test/app_test.dart
just format
git add --all
git commit --message 'touch workspace/integration_test/app_test.dart'
```

Put this exact content in `workspace/integration_test/app_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:prism_face_cropper/adapter/prism_face_cropper_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders the cropper page title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: PrismFaceCropperPage()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Prism Face Cropper'), findsOneWidget);
  });
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "3. Red: Add The Integration Test"
```

### 4. Green: Wire The Real Application

Replace `workspace/lib/main.dart` with:

```dart
import 'package:flutter/material.dart';

import 'adapter/prism_face_cropper_page.dart';

void main() {
  runApp(const PrismFaceCropperApp());
}

class PrismFaceCropperApp extends StatelessWidget {
  const PrismFaceCropperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Prism Face Cropper',
      home: PrismFaceCropperPage(),
    );
  }
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "4. Green: Wire The Real Application"
```

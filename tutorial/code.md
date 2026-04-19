# Code

### 1. Red: Validate The Face Map

Create the first code test file:

```bash
mkdir -p workspace/test/code
touch workspace/test/code/prism_face_cropper_service_test.dart
just format
git add --all
git commit --message 'touch workspace/test/code/prism_face_cropper_service_test.dart'
```

Put this exact content in `workspace/test/code/prism_face_cropper_service_test.dart`:

```dart
import 'package:prism_face_cropper/code/prism_face_cropper_service.dart';
import 'package:prism_face_cropper/contracts/normalized_rect.dart';
import 'package:test/test.dart';

void main() {
  test('validateFaceSelectionMap reports present and missing canonical faces', () {
    final validation = validateFaceSelectionMap({
      'front': const NormalizedRect(
        left: 0.30,
        top: 0.20,
        width: 0.20,
        height: 0.45,
      ),
      'top': const NormalizedRect(
        left: 0.30,
        top: 0.05,
        width: 0.20,
        height: 0.10,
      ),
    });

    expect(validation.presentFaces, ['front', 'top']);
    expect(validation.missingFaces, ['back', 'left', 'right', 'bottom']);
  });
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "1. Red: Validate The Face Map"
```

### 2. Green: Validate The Face Map

Create the first production file:

```bash
mkdir -p workspace/lib/code
touch workspace/lib/code/prism_face_cropper_service.dart
just format
git add --all
git commit --message 'touch workspace/lib/code/prism_face_cropper_service.dart'
```

Put this exact content in `workspace/lib/code/prism_face_cropper_service.dart`:

```dart
import '../contracts/face_crop_plan.dart';
import '../contracts/face_selection_validation.dart';
import '../contracts/normalized_rect.dart';

const canonicalPrismFaces = [
  'front',
  'back',
  'left',
  'right',
  'top',
  'bottom',
];

FaceSelectionValidation validateFaceSelectionMap(
  Map<String, NormalizedRect?> faceSelectionMap,
) {
  final presentFaces = <String>[];
  final missingFaces = <String>[];

  for (final face in canonicalPrismFaces) {
    if (faceSelectionMap[face] != null) {
      presentFaces.add(face);
    } else {
      missingFaces.add(face);
    }
  }

  return FaceSelectionValidation(
    presentFaces: presentFaces,
    missingFaces: missingFaces,
  );
}

List<FaceCropPlan> buildFaceCropPlan({
  required int imageWidth,
  required int imageHeight,
  required Map<String, NormalizedRect?> faceSelectionMap,
}) {
  throw UnimplementedError();
}

List<String> formatFaceCropSummary(List<FaceCropPlan> cropPlan) {
  throw UnimplementedError();
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "2. Green: Validate The Face Map"
```

### 3. Red: Add Crop Plan Generation

Replace `workspace/test/code/prism_face_cropper_service_test.dart` with:

```dart
import 'package:prism_face_cropper/code/prism_face_cropper_service.dart';
import 'package:prism_face_cropper/contracts/normalized_rect.dart';
import 'package:test/test.dart';

void main() {
  test('validateFaceSelectionMap reports present and missing canonical faces', () {
    final validation = validateFaceSelectionMap({
      'front': const NormalizedRect(
        left: 0.30,
        top: 0.20,
        width: 0.20,
        height: 0.45,
      ),
      'top': const NormalizedRect(
        left: 0.30,
        top: 0.05,
        width: 0.20,
        height: 0.10,
      ),
    });

    expect(validation.presentFaces, ['front', 'top']);
    expect(validation.missingFaces, ['back', 'left', 'right', 'bottom']);
  });

  test('buildFaceCropPlan converts normalized rectangles into integer pixel crops', () {
    final cropPlan = buildFaceCropPlan(
      imageWidth: 1000,
      imageHeight: 700,
      faceSelectionMap: {
        'front': const NormalizedRect(
          left: 0.30,
          top: 0.20,
          width: 0.20,
          height: 0.45,
        ),
      },
    );

    final frontPlan = cropPlan.firstWhere((plan) => plan.faceName == 'front');
    final bottomPlan = cropPlan.firstWhere((plan) => plan.faceName == 'bottom');

    expect(frontPlan.pixelLeft, 300);
    expect(frontPlan.pixelTop, 140);
    expect(frontPlan.pixelWidth, 200);
    expect(frontPlan.pixelHeight, 315);
    expect(frontPlan.isMissing, isFalse);

    expect(bottomPlan.isMissing, isTrue);
  });
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "3. Red: Add Crop Plan Generation"
```

### 4. Green: Add Crop Plan Generation

Replace `workspace/lib/code/prism_face_cropper_service.dart` with:

```dart
import '../contracts/face_crop_plan.dart';
import '../contracts/face_selection_validation.dart';
import '../contracts/normalized_rect.dart';

const canonicalPrismFaces = [
  'front',
  'back',
  'left',
  'right',
  'top',
  'bottom',
];

FaceSelectionValidation validateFaceSelectionMap(
  Map<String, NormalizedRect?> faceSelectionMap,
) {
  final presentFaces = <String>[];
  final missingFaces = <String>[];

  for (final face in canonicalPrismFaces) {
    if (faceSelectionMap[face] != null) {
      presentFaces.add(face);
    } else {
      missingFaces.add(face);
    }
  }

  return FaceSelectionValidation(
    presentFaces: presentFaces,
    missingFaces: missingFaces,
  );
}

List<FaceCropPlan> buildFaceCropPlan({
  required int imageWidth,
  required int imageHeight,
  required Map<String, NormalizedRect?> faceSelectionMap,
}) {
  return canonicalPrismFaces.map((face) {
    final rect = faceSelectionMap[face];
    if (rect == null) {
      return FaceCropPlan(
        faceName: face,
        pixelLeft: 0,
        pixelTop: 0,
        pixelWidth: 0,
        pixelHeight: 0,
        isMissing: true,
      );
    }

    return FaceCropPlan(
      faceName: face,
      pixelLeft: (rect.left * imageWidth).round(),
      pixelTop: (rect.top * imageHeight).round(),
      pixelWidth: (rect.width * imageWidth).round(),
      pixelHeight: (rect.height * imageHeight).round(),
      isMissing: false,
    );
  }).toList();
}

List<String> formatFaceCropSummary(List<FaceCropPlan> cropPlan) {
  throw UnimplementedError();
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "4. Green: Add Crop Plan Generation"
```

### 5. Red: Add Summary Formatting

Replace `workspace/test/code/prism_face_cropper_service_test.dart` with:

```dart
import 'package:prism_face_cropper/code/prism_face_cropper_service.dart';
import 'package:prism_face_cropper/contracts/normalized_rect.dart';
import 'package:test/test.dart';

void main() {
  test('validateFaceSelectionMap reports present and missing canonical faces', () {
    final validation = validateFaceSelectionMap({
      'front': const NormalizedRect(
        left: 0.30,
        top: 0.20,
        width: 0.20,
        height: 0.45,
      ),
      'top': const NormalizedRect(
        left: 0.30,
        top: 0.05,
        width: 0.20,
        height: 0.10,
      ),
    });

    expect(validation.presentFaces, ['front', 'top']);
    expect(validation.missingFaces, ['back', 'left', 'right', 'bottom']);
  });

  test('buildFaceCropPlan converts normalized rectangles into integer pixel crops', () {
    final cropPlan = buildFaceCropPlan(
      imageWidth: 1000,
      imageHeight: 700,
      faceSelectionMap: {
        'front': const NormalizedRect(
          left: 0.30,
          top: 0.20,
          width: 0.20,
          height: 0.45,
        ),
      },
    );

    final frontPlan = cropPlan.firstWhere((plan) => plan.faceName == 'front');
    final bottomPlan = cropPlan.firstWhere((plan) => plan.faceName == 'bottom');

    expect(frontPlan.pixelLeft, 300);
    expect(frontPlan.pixelTop, 140);
    expect(frontPlan.pixelWidth, 200);
    expect(frontPlan.pixelHeight, 315);
    expect(frontPlan.isMissing, isFalse);

    expect(bottomPlan.isMissing, isTrue);
  });

  test('formatFaceCropSummary preserves canonical order and missing markers', () {
    final cropPlan = buildFaceCropPlan(
      imageWidth: 1000,
      imageHeight: 700,
      faceSelectionMap: {
        'front': const NormalizedRect(
          left: 0.30,
          top: 0.20,
          width: 0.20,
          height: 0.45,
        ),
      },
    );

    expect(
      formatFaceCropSummary(cropPlan),
      [
        'front | 300, 140, 200, 315',
        'back | missing',
        'left | missing',
        'right | missing',
        'top | missing',
        'bottom | missing',
      ],
    );
  });
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "5. Red: Add Summary Formatting"
```

### 6. Green: Add Summary Formatting

Replace `workspace/lib/code/prism_face_cropper_service.dart` with:

```dart
import '../contracts/face_crop_plan.dart';
import '../contracts/face_selection_validation.dart';
import '../contracts/normalized_rect.dart';

const canonicalPrismFaces = [
  'front',
  'back',
  'left',
  'right',
  'top',
  'bottom',
];

FaceSelectionValidation validateFaceSelectionMap(
  Map<String, NormalizedRect?> faceSelectionMap,
) {
  final presentFaces = <String>[];
  final missingFaces = <String>[];

  for (final face in canonicalPrismFaces) {
    if (faceSelectionMap[face] != null) {
      presentFaces.add(face);
    } else {
      missingFaces.add(face);
    }
  }

  return FaceSelectionValidation(
    presentFaces: presentFaces,
    missingFaces: missingFaces,
  );
}

List<FaceCropPlan> buildFaceCropPlan({
  required int imageWidth,
  required int imageHeight,
  required Map<String, NormalizedRect?> faceSelectionMap,
}) {
  return canonicalPrismFaces.map((face) {
    final rect = faceSelectionMap[face];
    if (rect == null) {
      return FaceCropPlan(
        faceName: face,
        pixelLeft: 0,
        pixelTop: 0,
        pixelWidth: 0,
        pixelHeight: 0,
        isMissing: true,
      );
    }

    return FaceCropPlan(
      faceName: face,
      pixelLeft: (rect.left * imageWidth).round(),
      pixelTop: (rect.top * imageHeight).round(),
      pixelWidth: (rect.width * imageWidth).round(),
      pixelHeight: (rect.height * imageHeight).round(),
      isMissing: false,
    );
  }).toList();
}

List<String> formatFaceCropSummary(List<FaceCropPlan> cropPlan) {
  return cropPlan.map((plan) {
    if (plan.isMissing) {
      return '${plan.faceName} | missing';
    }

    return '${plan.faceName} | '
        '${plan.pixelLeft}, '
        '${plan.pixelTop}, '
        '${plan.pixelWidth}, '
        '${plan.pixelHeight}';
  }).toList();
}
```

Run:

```bash
just format
just check-all
git add --all
git commit --message "6. Green: Add Summary Formatting"
```

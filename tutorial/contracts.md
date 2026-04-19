# Contracts

Create the shared contract files:

```bash
mkdir -p workspace/lib/contracts
touch workspace/lib/contracts/normalized_rect.dart
just format
git add --all
git commit --message 'touch workspace/lib/contracts/normalized_rect.dart'
touch workspace/lib/contracts/face_crop_plan.dart
just format
git add --all
git commit --message 'touch workspace/lib/contracts/face_crop_plan.dart'
touch workspace/lib/contracts/face_selection_validation.dart
just format
git add --all
git commit --message 'touch workspace/lib/contracts/face_selection_validation.dart'
```

Put this exact content in `workspace/lib/contracts/normalized_rect.dart`:

```dart
class NormalizedRect {
  final double left;
  final double top;
  final double width;
  final double height;

  const NormalizedRect({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}
```

Put this exact content in `workspace/lib/contracts/face_crop_plan.dart`:

```dart
class FaceCropPlan {
  final String faceName;
  final int pixelLeft;
  final int pixelTop;
  final int pixelWidth;
  final int pixelHeight;
  final bool isMissing;

  const FaceCropPlan({
    required this.faceName,
    required this.pixelLeft,
    required this.pixelTop,
    required this.pixelWidth,
    required this.pixelHeight,
    required this.isMissing,
  });
}
```

Put this exact content in `workspace/lib/contracts/face_selection_validation.dart`:

```dart
class FaceSelectionValidation {
  final List<String> presentFaces;
  final List<String> missingFaces;

  const FaceSelectionValidation({
    required this.presentFaces,
    required this.missingFaces,
  });
}
```

Do not add tests here. Keep this layer limited to interfaces and small shared types.

Then run:

```bash
just format
just check-all
git add --all
git commit --message "Define prism-face-cropper Flutter contracts"
```

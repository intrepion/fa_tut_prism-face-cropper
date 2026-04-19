import 'package:prism_face_cropper/code/prism_face_cropper_service.dart';
import 'package:prism_face_cropper/contracts/normalized_rect.dart';
import 'package:test/test.dart';

void main() {
  test(
    'validateFaceSelectionMap reports present and missing canonical faces',
    () {
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
    },
  );
}

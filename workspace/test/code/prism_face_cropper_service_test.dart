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

  test(
    'buildFaceCropPlan converts normalized rectangles into integer pixel crops',
    () {
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
      final bottomPlan = cropPlan.firstWhere(
        (plan) => plan.faceName == 'bottom',
      );

      expect(frontPlan.pixelLeft, 300);
      expect(frontPlan.pixelTop, 140);
      expect(frontPlan.pixelWidth, 200);
      expect(frontPlan.pixelHeight, 315);
      expect(frontPlan.isMissing, isFalse);

      expect(bottomPlan.isMissing, isTrue);
    },
  );
}

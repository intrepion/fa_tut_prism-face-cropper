import '../contracts/face_crop_plan.dart';
import '../contracts/face_selection_validation.dart';
import '../contracts/normalized_rect.dart';

const canonicalPrismFaces = ['front', 'back', 'left', 'right', 'top', 'bottom'];

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

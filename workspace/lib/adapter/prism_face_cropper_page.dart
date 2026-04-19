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
        Positioned.fill(child: ColoredBox(color: Color(0xFFF9E4B7))),
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

  const _FacePanel({required this.label, required this.color});

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

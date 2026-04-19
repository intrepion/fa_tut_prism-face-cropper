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

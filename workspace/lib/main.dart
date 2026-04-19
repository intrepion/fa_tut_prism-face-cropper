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

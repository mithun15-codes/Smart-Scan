import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/scan_upload_card.dart';

class XrayScreen extends StatelessWidget {
  const XrayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScanUploadCard(
      scanType: AppConstants.scanXray,
      title: 'X-Ray Scan Analysis',
      uploadPrompt: 'Upload X-Ray Image',
      analyzeButtonText: 'Analyze X-Ray Scan',
    );
  }
}


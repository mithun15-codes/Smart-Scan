import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/scan_upload_card.dart';

class CtScreen extends StatelessWidget {
  const CtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScanUploadCard(
      scanType: AppConstants.scanCt,
      title: 'CT Scan Analysis',
      uploadPrompt: 'Upload CT Image',
      analyzeButtonText: 'Analyze CT Scan',
    );
  }
}


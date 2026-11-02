import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/scan_upload_card.dart';

class MriScreen extends StatelessWidget {
  const MriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScanUploadCard(
      scanType: AppConstants.scanMri,
      title: 'MRI Scan Analysis',
      uploadPrompt: 'Upload MRI Image',
      analyzeButtonText: 'Analyze MRI Scan',
    );
  }
}


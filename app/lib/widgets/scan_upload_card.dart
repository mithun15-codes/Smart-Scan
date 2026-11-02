import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/scan_result.dart';
import '../services/prediction_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/constants.dart';

class ScanUploadCard extends StatefulWidget {
  final String scanType; // 'mri', 'ct', 'xray'
  final String title;
  final String uploadPrompt;
  final String analyzeButtonText;

  const ScanUploadCard({
    super.key,
    required this.scanType,
    required this.title,
    required this.uploadPrompt,
    required this.analyzeButtonText,
  });

  @override
  State<ScanUploadCard> createState() => _ScanUploadCardState();
}

class _ScanUploadCardState extends State<ScanUploadCard> {
  final ImagePicker _picker = ImagePicker();

  File? _singleImage;
  List<File> _gridImages = [];
  bool _isGridView = false;

  bool _isAnalyzing = false;
  String? _errorMessage;
  ScanResult? _predictionResult;

  Future<void> _pickSingleImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
      );
      if (picked != null) {
        setState(() {
          _singleImage = File(picked.path);
          _isGridView = false;
          _errorMessage = null;
          _predictionResult = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to select image: ${e.toString()}';
      });
    }
  }

  Future<void> _pickMultipleImages() async {
    try {
      final pickedList = await _picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
      );
      if (pickedList.isNotEmpty) {
        setState(() {
          _gridImages = pickedList.map((x) => File(x.path)).toList();
          _singleImage = _gridImages.first;
          _isGridView = true;
          _errorMessage = null;
          _predictionResult = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to select images: ${e.toString()}';
      });
    }
  }

  Future<void> _analyze() async {
    final targetFile = _singleImage ?? (_gridImages.isNotEmpty ? _gridImages.first : null);
    if (targetFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload an image first!'),
          backgroundColor: AppColors.errorText,
        ),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
      _predictionResult = null;
    });

    try {
      final result = await PredictionService.analyzeImage(
        imageFile: targetFile,
        scanType: widget.scanType,
      );

      setState(() {
        _predictionResult = result;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  void _clearImage() {
    setState(() {
      _singleImage = null;
      _gridImages.clear();
      _predictionResult = null;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: 18),

        // Upload container heading
        Text(
          widget.uploadPrompt,
          textAlign: TextAlign.center,
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: 16),

        // Upload Single Image Button (Dashed border)
        _buildUploadButton(
          title: 'Upload Single Image',
          icon: Icons.cloud_upload_outlined,
          onTap: _pickSingleImage,
        ),
        const SizedBox(height: 12),

        // Upload Multiple Images (Grid View) Button
        _buildUploadButton(
          title: 'Upload Multiple Images (Grid View)',
          icon: Icons.grid_view_rounded,
          onTap: _pickMultipleImages,
        ),
        const SizedBox(height: 20),

        // Preview Section
        if (!_isGridView && _singleImage != null) _buildSinglePreview(),
        if (_isGridView && _gridImages.isNotEmpty) _buildGridPreview(),

        // Error message if any
        if (_errorMessage != null)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.errorBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.errorText.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: AppColors.errorText, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      fontFamily: 'Segoe UI',
                      color: AppColors.errorText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Action Button: Analyze
        ElevatedButton(
          onPressed: _isAnalyzing ? null : _analyze,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlueAlt,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
          ),
          child: _isAnalyzing
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Analyzing Scan with CNN...',
                      style: AppTextStyles.button,
                    ),
                  ],
                )
              : Text(
                  widget.analyzeButtonText,
                  style: AppTextStyles.button,
                ),
        ),
        const SizedBox(height: 20),

        // Prediction Box
        if (_predictionResult != null) _buildResultSection(_predictionResult!),
      ],
    );
  }

  Widget _buildUploadButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.uploadBtnBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.dashedBorder,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.dashedBorder),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Segoe UI',
                color: AppColors.dashedBorder,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSinglePreview() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              constraints: const BoxConstraints(maxHeight: 280),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _singleImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            IconButton(
              icon: const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, color: Colors.white, size: 16),
              ),
              onPressed: _clearImage,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGridPreview() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _gridImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final isSelected = _singleImage?.path == _gridImages[index].path;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _singleImage = _gridImages[index];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.file(
                      _gridImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Showing ${_gridImages.length} scans. Tap any image to set as active for CNN analysis.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildResultSection(ScanResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Prediction Highlight Box
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.predictionBox,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0xFF81D4FA)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: Color(0xFF0288D1), size: 24),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Prediction: ${result.prediction}',
                      style: AppTextStyles.prediction,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              if (result.confidence != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Model Confidence: ${(result.confidence! * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.headingDark,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Description Box
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.descriptionBox,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analysis Details',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 10),
              Text(
                result.description,
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Medical Disclaimer
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9C4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFFF176)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFF57F17), size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppConstants.medicalDisclaimer,
                  style: const TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 12,
                    color: Color(0xFF4E342E),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


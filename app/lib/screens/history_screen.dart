import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/scan_result.dart';
import '../services/history_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ScanResult> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final list = await HistoryService.getHistory();
    if (mounted) {
      setState(() {
        _history = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteItem(String id) async {
    await HistoryService.deleteRecord(id);
    _loadHistory();
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Scan History?'),
        content: const Text('This will remove all saved scans from this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorText),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await HistoryService.clearHistory();
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Scan Analysis History',
          textAlign: TextAlign.center,
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: 12),

        // Backend Status Banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFA5D6A7)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.info_outline, color: Color(0xFF2E7D32), size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Backend Status: Cloud database endpoints (/history) are currently not implemented in the FastAPI backend repository. Scans are saved securely to local device storage.',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 12,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (_history.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.delete_sweep_rounded, color: AppColors.errorText, size: 18),
              label: const Text(
                'Clear History',
                style: TextStyle(color: AppColors.errorText, fontWeight: FontWeight.bold),
              ),
              onPressed: _clearAll,
            ),
          ),

        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_history.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: const [
                Icon(Icons.history_toggle_off_rounded,
                    size: 50, color: AppColors.textGrey),
                SizedBox(height: 12),
                Text(
                  'No Scans Yet',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.headingDark,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Upload and analyze an MRI, CT, or X-Ray scan to see results saved here.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMuted,
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _history.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _history[index];
              return _buildHistoryCard(item);
            },
          ),
      ],
    );
  }

  Widget _buildHistoryCard(ScanResult item) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    final formattedDate = dateFormat.format(item.timestamp);

    Color tagColor;
    String tagLabel;
    if (item.scanType == 'mri') {
      tagColor = const Color(0xFF673AB7);
      tagLabel = 'MRI SCAN';
    } else if (item.scanType == 'ct') {
      tagColor = const Color(0xFF009688);
      tagLabel = 'CT SCAN';
    } else {
      tagColor = const Color(0xFF1E88E5);
      tagLabel = 'X-RAY SCAN';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Modality Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tagColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: tagColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  tagLabel,
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: tagColor,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.textGrey),
                onPressed: () => _deleteItem(item.id),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image thumbnail if available
              if (item.imagePath != null && File(item.imagePath!).existsSync())
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(item.imagePath!),
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECEFF1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image_not_supported_outlined,
                      color: AppColors.textGrey),
                ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prediction: ${item.prediction}',
                      style: const TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.headingDark,
                      ),
                    ),
                    if (item.confidence != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Confidence: ${(item.confidence! * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Text(
            item.description,
            style: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

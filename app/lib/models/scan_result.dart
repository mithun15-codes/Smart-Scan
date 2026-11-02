class ScanResult {
  final String id;
  final String scanType; // 'mri', 'ct', 'xray'
  final String? imagePath;
  final String prediction;
  final double? confidence;
  final String description;
  final DateTime timestamp;
  final int? rawClassIndex;

  ScanResult({
    required this.id,
    required this.scanType,
    this.imagePath,
    required this.prediction,
    this.confidence,
    required this.description,
    required this.timestamp,
    this.rawClassIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scanType': scanType,
      'imagePath': imagePath,
      'prediction': prediction,
      'confidence': confidence,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'rawClassIndex': rawClassIndex,
    };
  }

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      scanType: json['scanType'] ?? 'mri',
      imagePath: json['imagePath'],
      prediction: json['prediction'] ?? 'Unknown',
      confidence: (json['confidence'] as num?)?.toDouble(),
      description: json['description'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      rawClassIndex: json['rawClassIndex'] as int?,
    );
  }
}


import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config/api_config.dart';
import '../models/scan_result.dart';
import '../utils/constants.dart';
import 'history_service.dart';

class PredictionService {
  /// Upload image file and get CNN prediction from FastAPI backend
  static Future<ScanResult> analyzeImage({
    required File imageFile,
    required String scanType, // 'mri', 'ct', 'xray'
  }) async {
    final baseUrl = await ApiConfig.getBaseUrl();

    // Determine target endpoints
    String specificEndpoint;
    if (scanType == AppConstants.scanMri) {
      specificEndpoint = ApiConfig.predictMri;
    } else if (scanType == AppConstants.scanCt) {
      specificEndpoint = ApiConfig.predictCt;
    } else {
      specificEndpoint = ApiConfig.predictXray;
    }

    // Try modality-specific endpoint first, then generic /predict/
    ScanResult? result;
    try {
      result = await _sendPredictionRequest(
        baseUrl: baseUrl,
        endpoint: specificEndpoint,
        imageFile: imageFile,
        scanType: scanType,
      );
    } catch (e) {
      // If endpoint returned 404 (e.g. backend only has /predict/ route), fallback
      if (e.toString().contains('404') || e.toString().contains('Not Found')) {
        result = await _sendPredictionRequest(
          baseUrl: baseUrl,
          endpoint: ApiConfig.genericPredict,
          imageFile: imageFile,
          scanType: scanType,
        );
      } else {
        rethrow;
      }
    }

    // Persist to history
    await HistoryService.addRecord(result);

    return result;
  }

  static Future<ScanResult> _sendPredictionRequest({
    required String baseUrl,
    required String endpoint,
    required File imageFile,
    required String scanType,
  }) async {
    final fullUri = Uri.parse('$baseUrl$endpoint');

    if (!await imageFile.exists()) {
      throw const FileSystemException('Selected image file does not exist.');
    }

    // Determine mime subtype
    final extension = imageFile.path.split('.').last.toLowerCase();
    String mimeSubtype = 'jpeg';
    if (extension == 'png') {
      mimeSubtype = 'png';
    } else if (extension == 'bmp') {
      mimeSubtype = 'bmp';
    }

    final request = http.MultipartRequest('POST', fullUri);

    final multipartFile = await http.MultipartFile.fromPath(
      'file', // Field name expected by FastAPI: file: UploadFile = File(...)
      imageFile.path,
      contentType: MediaType('image', mimeSubtype),
    );
    request.files.add(multipartFile);

    http.StreamedResponse streamedResponse;
    try {
      streamedResponse = await request.send().timeout(const Duration(seconds: 45));
    } on SocketException catch (_) {
      throw SocketException(
          'Could not reach server at $baseUrl. Ensure FastAPI is running.');
    }

    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode == 404) {
      throw HttpException('Endpoint $endpoint Not Found (404)');
    }

    if (streamedResponse.statusCode != 200) {
      String errMsg = 'Server error (${streamedResponse.statusCode})';
      try {
        final errJson = jsonDecode(responseBody);
        if (errJson['error'] != null) {
          errMsg = errJson['error'].toString();
        } else if (errJson['detail'] != null) {
          errMsg = errJson['detail'].toString();
        }
      } catch (_) {}
      throw HttpException(errMsg);
    }

    // Parse JSON
    Map<String, dynamic> data;
    try {
      data = jsonDecode(responseBody);
    } catch (_) {
      throw const FormatException('Invalid response format received from server.');
    }

    if (data.containsKey('error') && data['error'] != null) {
      throw Exception(data['error'].toString());
    }

    String predictionText = 'Unknown';
    double? confidence;
    String descriptionText = '';
    int? rawClassIndex;

    // Format 1: app.py returns {"predicted_class": int}
    if (data.containsKey('predicted_class')) {
      rawClassIndex = (data['predicted_class'] as num).toInt();
      predictionText = _mapClassIndexToName(scanType, rawClassIndex);
      descriptionText =
          AppConstants.getClassDescription(scanType, rawClassIndex);
    }
    // Format 2: index.html expects {"prediction": "...", "description": "..."}
    else if (data.containsKey('prediction')) {
      predictionText = data['prediction'].toString();
      if (data.containsKey('description')) {
        descriptionText = data['description'].toString();
      }
    }

    // Optional confidence score if provided by backend
    if (data.containsKey('confidence')) {
      confidence = (data['confidence'] as num?)?.toDouble();
    } else if (data.containsKey('score')) {
      confidence = (data['score'] as num?)?.toDouble();
    }

    if (descriptionText.isEmpty) {
      descriptionText = rawClassIndex != null
          ? AppConstants.getClassDescription(scanType, rawClassIndex)
          : 'CNN model inference successfully processed this medical scan.';
    }

    return ScanResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scanType: scanType,
      imagePath: imageFile.path,
      prediction: predictionText,
      confidence: confidence,
      description: descriptionText,
      timestamp: DateTime.now(),
      rawClassIndex: rawClassIndex,
    );
  }

  static String _mapClassIndexToName(String scanType, int index) {
    if (scanType == AppConstants.scanMri) {
      if (index >= 0 && index < AppConstants.mriClasses.length) {
        return AppConstants.mriClasses[index];
      }
      return 'Class #$index';
    } else if (scanType == AppConstants.scanCt) {
      if (index >= 0 && index < AppConstants.ctClasses.length) {
        return AppConstants.ctClasses[index];
      }
      return 'Class #$index';
    } else if (scanType == AppConstants.scanXray) {
      if (index >= 0 && index < AppConstants.xrayClasses.length) {
        return AppConstants.xrayClasses[index];
      }
      return 'Class #$index';
    }
    return 'Class #$index';
  }
}


import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/emotion_result.dart';

class ApiService {
  static Future<EmotionResult> predictEmotion(String audioFilePath) async {
    try {
      final file = File(audioFilePath);
      if (!await file.exists()) {
        throw Exception('Recording file not found');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.predictEndpoint),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          audioFilePath,
          filename: 'recording.wav',
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return EmotionResult.fromJson(jsonResponse);
      } else {
        throw Exception('API returned status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to analyze emotion: $e');
    }
  }
}

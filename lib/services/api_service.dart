// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class ApiService {
  final String apiUrl = "https://jsonblob.com/api/jsonBlob/1346011103062319104";

  Future<List<Question>> fetchQuestions() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true) {
        return (data['questions'] as List)
            .map((json) => Question.fromJson(json))
            .toList();
      }
      throw Exception('API returned unsuccessful response');
    }
    throw Exception('Failed to load questions');
  }
}

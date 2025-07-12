// Submit a new question
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> postQuestion({
  required String title,
  required String description,
  required List<String> tags,
  String userName = 'User Name', // Default/fallback
}) async {
  const String baseUrl =
      'https://your-api-base-url.com'; // TODO: Replace with your actual base URL
  final response = await http.post(
    Uri.parse('$baseUrl/submit-question'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'title': title,
      'description': description,
      'tags': tags,
      'answers': [], // Optional for now
      'userName': userName, // Optional for now
    }),
  );

  if (response.statusCode != 201 && response.statusCode != 200) {
    throw Exception('Failed to submit question: ${response.body}');
  }
}

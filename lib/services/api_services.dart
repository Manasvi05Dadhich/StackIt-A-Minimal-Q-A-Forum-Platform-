import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stackit/components/question.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000'; // or your deployed URL

  static Future<List<Question>> fetchQuestions() async {
    final response = await http.get(Uri.parse('$baseUrl/questions'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data
          .map<Question>(
            (item) => Question(
              id: item['id'],
              title: item['title'],
              description: item['description'] ?? '',
              tags: item['tags'] != null ? List<String>.from(item['tags']) : [],
              answers: item['answers'] != null
                  ? List<String>.from(item['answers'])
                  : [],
              userName: item['userName'] ?? '',
              // Add other fields as necessary
            ),
          )
          .toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  static Future<void> postQuestion(Question question) async {
    final response = await http.post(
      Uri.parse('$baseUrl/questions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': question.id,
        'title': question.title,
        'description': question.description,
        'tags': question.tags,
        'answers': question.answers,
        'userName': question.userName,
        // Add other fields as necessary
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to submit question');
    }
  }
}

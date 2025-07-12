// models/question.dart
class Question {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final List<String> answers;
  final String userName;

  Question({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.answers,
    required this.userName,
  });
}

import 'package:flutter/material.dart';
import 'package:stackit/components/question.dart';

class QuestionDetailScreen extends StatelessWidget {
  final Question question;
  const QuestionDetailScreen({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final Color background = const Color(0xFFF8F9FB);
    final Color cardColor = Colors.white;
    final Color accent = const Color(0xFFFFC107);
    final Color textColor = const Color(0xFF1C1C1E);
    final Color mutedText = Colors.grey.shade600;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.layers, color: Colors.black),
            const SizedBox(width: 8),
            const Text(
              'StackIt',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Home', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.notifications_none, color: Colors.black),
            const SizedBox(width: 16),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.png'),
              radius: 16,
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question > ${question.title.substring(0, 20)}...',
                  style: TextStyle(color: accent, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Text(
                  question.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: question.tags
                      .map(
                        (tag) => Chip(
                          label: Text(
                            tag,
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: accent.withOpacity(0.2),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                Text(question.description, style: TextStyle(color: mutedText)),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),
                const Text(
                  'Answers',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ...question.answers.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AnswerCard(
                      index: entry.key + 1,
                      text: entry.value,
                      accent: accent,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Submit Your Answer',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: TextField(
                      maxLines: null,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Write your answer...',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  final int index;
  final String text;
  final Color accent;

  const _AnswerCard({
    required this.index,
    required this.text,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const Icon(
                Icons.keyboard_arrow_up,
                size: 18,
                color: Colors.black,
              ),
              Text(
                index.toString(),
                style: const TextStyle(color: Colors.black),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Colors.black,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Answer $index',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(text, style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

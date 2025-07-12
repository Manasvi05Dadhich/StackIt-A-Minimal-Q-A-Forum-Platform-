// lib/web/home_screen.dart
import 'package:flutter/material.dart';
import 'package:stackit/components/custom_main.dart';
import 'package:stackit/components/question.dart';
import 'package:stackit/web/ask_question_screen.dart';
import 'package:stackit/web/question_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Question> questions = List.generate(
      2,
      (index) => Question(
        id: '$index',
        title:
            'How to join 2 columns in a data set to make a separate column in SQL',
        description:
            'I do not know the code for it as I am a beginner. As an example, column 1 contains first name and column 2 contains last name. I want to combine them.',
        tags: ['SQL', 'DataFrame'],
        answers: [
          'Use the || operator',
          'Use the + operator',
          'Use the CONCAT function',
        ],
        userName: 'User Name',
      ),
    );

    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F9),
      appBar: _CustomAppBar(isMobile: isMobile),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 80,
          vertical: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AskQuestionScreen(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Ask New Question',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              QuestionDetailScreen(question: question),
                        ),
                      );
                    },
                    child: _QuestionCard(
                      title: question.title,
                      description: question.description,
                      tags: question.tags,
                      username: question.userName,
                      answerCount: question.answers.length,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(7, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: index == 0 ? Colors.orange : Colors.grey,
                    ),
                    child: Text('${index + 1}'),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isMobile;
  const _CustomAppBar({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        children: [
          const Icon(Icons.layers, color: Colors.black),
          const SizedBox(width: 8),
          const Text(
            'StackIt',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (!isMobile) ...[
            _FilterButton(text: 'Newest'),
            _FilterButton(text: 'Unanswered'),
            _FilterButton(text: 'More ▼'),
            const SizedBox(width: 16),
            SizedBox(
              width: 200,
              height: 36,
              child: TextField(
                decoration: InputDecoration(hintText: 'Search...'),
              ),
            ),
            const SizedBox(width: 16),
            TextButton(onPressed: () {}, child: const Text('Login')),
          ] else ...[
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.black),
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'filters', child: Text('Filters')),
                PopupMenuItem(value: 'newest', child: Text('Newest')),
                PopupMenuItem(value: 'unanswered', child: Text('Unanswered')),
                PopupMenuItem(value: 'more', child: Text('More')),
                PopupMenuItem(value: 'login', child: Text('Login')),
              ],
              onSelected: (value) {},
            ),
          ],
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _FilterButton extends StatelessWidget {
  final String text;
  const _FilterButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> tags;
  final String username;
  final int answerCount;

  const _QuestionCard({
    required this.title,
    required this.description,
    required this.tags,
    required this.username,
    required this.answerCount,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$answerCount ans',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orangeAccent),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  username,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:stackit/components/custom_main.dart';

import 'package:stackit/services/api_services.dart';

class AskQuestionScreen extends StatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  State<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends State<AskQuestionScreen> {
  final HtmlEditorController controller = HtmlEditorController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  final List<String> tags = [];

  void addTag(String value) {
    final tag = value.trim();
    if (tag.isEmpty || tags.contains(tag)) return;
    setState(() {
      tags.add(tag);
      tagController.clear();
    });
  }

  Future<void> _submitQuestion() async {
    final title = titleController.text.trim();
    final description = await controller.getText();

    if (title.isEmpty || description.isEmpty || tags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and add tags')),
      );
      return;
    }

    try {
      await ApiService.postQuestion(
        title: title,
        description: description,
        tags: tags,
      );

      if (mounted) {
        Navigator.pop(context); // Close the dialog/screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question submitted successfully!')),
        );
      }
    } catch (e) {
      debugPrint('Submit error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit question')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.layers, color: Colors.black),
            const SizedBox(width: 8),
            Text('StackIt', style: TextStyle(color: primaryText)),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Home', style: TextStyle(color: primaryDark)),
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
            constraints: const BoxConstraints(maxWidth: 700),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: shadow,
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter your question title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: border),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),

                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: HtmlEditor(
                      controller: controller,
                      htmlEditorOptions: HtmlEditorOptions(
                        hint: 'Describe your question...',
                      ),
                      htmlToolbarOptions: HtmlToolbarOptions(
                        toolbarPosition: ToolbarPosition.aboveEditor,
                        toolbarType: ToolbarType.nativeScrollable,
                        defaultToolbarButtons: [
                          FontSettingButtons(),
                          FontButtons(clearAll: false),
                          ColorButtons(),
                          ListButtons(),
                          ParagraphButtons(),
                          InsertButtons(),
                          OtherButtons(),
                        ],
                      ),
                      otherOptions: OtherOptions(height: 300),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  'Tags',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...tags.map(
                      (tag) => Chip(
                        label: Text(tag),
                        backgroundColor: softHighlight,
                        labelStyle: TextStyle(color: primaryDark),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => setState(() => tags.remove(tag)),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: tagController,
                        onSubmitted: addTag,
                        decoration: InputDecoration(
                          hintText: 'Add tag',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: border),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submitQuestion,
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
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

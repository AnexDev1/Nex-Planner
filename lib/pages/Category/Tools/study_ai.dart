import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../services/study_ai_logic.dart';

class StudyAI extends StatefulWidget {
  const StudyAI({super.key});

  @override
  _StudyAIState createState() => _StudyAIState();
}

class _StudyAIState extends State<StudyAI> {
  final StudyAILogic _logic = StudyAILogic();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _submitInput() async {
    String inputText = _inputController.text;
    if (inputText.isNotEmpty) {
      setState(() {
        _logic.isLoading = true;
        _logic.clearResponses();
      });
      await _logic.chatWithAI(inputText);
      setState(() {
        _inputController.clear();
        _logic.isLoading = false;
      });
      _scrollToEnd();
    }
  }

  void _pickImage(String action) async {
    await _logic.pickImage();
    if (action == 'Create Questions') {
      await _logic.createQuestionsFromText('generate exam like question from this text, could include choice, short answer or even blank space questions: ${_logic.extractedText}');
    } else if (action == 'Answer Questions') {
      await _logic.chatWithAI('Give the correct answer for this questions, write question followed by answer, style the codes with markdown: ${_logic.extractedText}');
    }
    setState(() {
      // Update the UI after picking the image and performing OCR
    });
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study AI'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'Clear') {
                setState(() {
                  _logic.clearQuestions();
                  _logic.clearResponses();
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Clear',
                  child: ListTile(
                    leading: Icon(Icons.clear),
                    title: Text('Clear'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Save',
                  child: ListTile(
                    leading: Icon(Icons.save),
                    title: Text('Save'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Share',
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Share'),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: _logic.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<String>(
                stream: _logic.responseStream,
                builder: (context, snapshot) {
                  if (_logic.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text(''));
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error occurred'));
                  } else if (!snapshot.hasData || _logic.responses.isEmpty) {
                    return const Center(child: Text('No responses yet'));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _logic.responses.map((response) {
                            return MarkdownBody(
                              data: response,
                              styleSheet: MarkdownStyleSheet(
                                p: const TextStyle(fontSize: 16.0),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }
                },
              )
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _submitInput,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.image),
                    onSelected: (String value) {
                      _pickImage(value);
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'Create Questions',
                          child: Text('Create Questions'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Answer Questions',
                          child: Text('Answer Questions'),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
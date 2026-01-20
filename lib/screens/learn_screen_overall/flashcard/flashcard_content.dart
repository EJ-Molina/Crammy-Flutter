
import 'package:crammy_app/models/file_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../models/flashcard_item.dart';

class FlashcardContent extends StatefulWidget {
  const FlashcardContent({required this.file, required this.index, super.key});
  final FileInfo file;
  final int index;

  @override
  State<FlashcardContent> createState() => _FlashcardContentState();
}

class _FlashcardContentState extends State<FlashcardContent> {
  int cardIndex = 0;
  bool isQuestion = true;
  @override
  Widget build(BuildContext context) {
    final List<FlashcardItem> flashcards = widget.file.flashcardsFromContent ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Flashcard ${widget.index + 1}"),
        backgroundColor: Color(0xFFA1C4FD),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFA1C4FD), Color(0xFFC2E9FB)],
          ),
        ),
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            Center(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (cardIndex > 0) {
                        setState(() => cardIndex--);
                      }
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          // horizontal: 50,
                          vertical: 130,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              textAlign: TextAlign.center,
                              isQuestion
                                  ? flashcards[cardIndex].question
                                  : flashcards[cardIndex].answer,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: isQuestion ? 14 : 16,
                                fontWeight: isQuestion ? .bold : .normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (cardIndex < flashcards.length - 1) {
                        isQuestion = true;
                        setState(() => cardIndex++);
                      }
                    },
                    icon: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
            Gap(10),
            Text("${cardIndex+1}/5", style: TextStyle(fontWeight: .bold, fontSize: 16)),
            Gap(10),
            FilledButton(
              onPressed: () {
                isQuestion = !isQuestion;
                setState(() {});
              },
              style: FilledButton.styleFrom(backgroundColor: Color(0xFF1EAE98)),
              child: Text("Flip"),
            ),
          ],
        ),
      ),
    );
  }
}

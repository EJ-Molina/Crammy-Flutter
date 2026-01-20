import 'package:crammy_app/models/file_data.dart';
import 'package:crammy_app/screens/learn_screen_overall/quiz/quiz_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final List<FileInfo>? quizData;
  final Function onDelete;
  const QuizPage({Key? key, required this.quizData, required this.onDelete}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    // Debug: print hashCodes of all FileInfo objects in quizData
    if (widget.quizData != null) {
      for (int i = 0; i < widget.quizData!.length; i++) {
        print('quizData[$i] hashCode: \\${widget.quizData![i].hashCode}');
      }
    }
    return SizedBox.expand(
      child: widget.quizData == null || widget.quizData!.isEmpty
          ? Center(child: Text("No Quiz Created"))
          : ListView.builder(
              itemBuilder: (_, index) {
                var quiz = widget.quizData![index].quizzesFromContent!;
                // Also print hashCode for this item
                print('Building quiz card for index $index, hashCode: \\${widget.quizData![index].hashCode}');
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) =>
                            QuizContent(quizzes: quiz, index: index),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.file_copy_rounded,
                              color: Color(0xFF2D3E50),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Quiz ${index + 1} - ${quiz.isNotEmpty == true ? quiz.first.type : 'No Type'}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Created from \"${widget.quizData![index].origName}\"",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    widget.onDelete(quiz, widget.quizData);
                                  },
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    color: Color(0xFF2D3E50),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.import_contacts_rounded,
                                  color: Color(0xFF2D3E50),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: widget.quizData!.length,
            ),
    );
  }
}

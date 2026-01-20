import 'package:crammy_app/models/file_data.dart';
import 'package:crammy_app/screens/learn_screen_overall/flashcard/flashcard_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FlashcardPage extends StatefulWidget {
  final List<FileInfo>? flashcardData;
  final Function onDelete;
  const FlashcardPage({Key? key, required this.flashcardData, required this.onDelete}) : super(key: key);

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  // var flashCardData = [];
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: widget.flashcardData == null || widget.flashcardData!.isEmpty
          ? Center(child: Text("No Flashcard Created"))
          : ListView.builder(
              itemBuilder: (_, index) {
                var flashcard = widget.flashcardData![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => FlashcardContent(file: flashcard, index: index),
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
                                  "Flashcard ${index + 1}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Created from \"${flashcard.origName}\"",
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
                                    widget.onDelete(
                                      flashcard,
                                      widget.flashcardData,
                                    );
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
              itemCount: widget.flashcardData!.length,
            ),
    );
  }
}

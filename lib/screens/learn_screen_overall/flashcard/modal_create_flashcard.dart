import 'dart:convert';

import 'package:crammy_app/models/file_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../models/flashcard_item.dart';

class ShowModalCreateFlashCard extends StatefulWidget {
  const ShowModalCreateFlashCard({
    super.key,
    required this.files,
    required this.onCreate,
  });

  final List<FileInfo> files;
  final Function onCreate;

  @override
  State<ShowModalCreateFlashCard> createState() =>
      _ShowModalCreateFlashCardState();
}

class _ShowModalCreateFlashCardState extends State<ShowModalCreateFlashCard> {
  // final
  @override
  Widget build(BuildContext context) {
    // final flashCardData = [];

    return Column(
      mainAxisSize: .min,
      children: [
        SizedBox(height: 15),
        SvgPicture.asset(
          'assets/svg/line_choose_file.svg',
          height: 7,
          width: 14,
        ),
        SizedBox(height: 15),
        Text(
          "Choose a file to create flashcards",
          style: TextStyle(
            color: Color(0xFF2D3E50),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (_, index) {
            var file = widget.files[index];
            return GestureDetector(
              onTap: () async {
                final generatedFC = await onCreateFlashCard(file);
                final FileInfo newFcFile = FileInfo(
                  origName: file.origName,
                  filepath: file.filepath,
                  fileExtension: file.fileExtension,
                  fileSize: file.fileSize,
                  contentGenerated: file.contentGenerated,
                  flashcardsFromContent: generatedFC
                );
                //trigger the callback from main_container and add file in flashCard data
                widget.onCreate(newFcFile);
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(Icons.file_copy),
                    title: Text(file.origName),
                  ),
                ),
              ),
            );
          },
          itemCount: widget.files.length,
        ),
      ],
    );
  }

  Future<List<FlashcardItem>> onCreateFlashCard(FileInfo file) async {
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      systemInstruction: Content.system(
        '''You are a professional flashcard generator. Given the following lesson content, extract the most important facts and concepts, and generate a list of flashcards in JSON format. Each flashcard should have a "question" and an "answer" field. Output only a JSON array, no extra text.

      Example output:
      [
        {"question": "What is photosynthesis?", "answer": "Photosynthesis is the process by which green plants convert sunlight into energy."},
        {"question": "What is the main pigment in plants?", "answer": "Chlorophyll."}
      ]

      give me atleast 5
      Lesson content:
      {content}
      ''',
      ),
    );
    showLoadingDialog(context);
    final response = await model.generateContent([
      Content.text(file.contentGenerated),
    ]);

    Navigator.of(context, rootNavigator: true).pop(); // to close the dialog

    var jsonString = response.text!.trim();
    if (jsonString.startsWith('```')) {
      jsonString = jsonString.replaceAll(RegExp(r'```[a-zA-Z]*'), '').trim();
    }
    final List<dynamic> jsonList = json.decode(jsonString);
    final flashcards = jsonList
        .map((json) => FlashcardItem.fromJson(json))
        .toList();

    // print(jsonString);
    // print('Start: ${jsonString.substring(0, 100)}');
    // print('End: ${jsonString.substring(jsonString.length - 100)}');
    // file.flashcardsFromContent = flashcards;
    return flashcards;
  }

  //PROGRESS INDICATOR
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Analyzing...'),
          ],
        ),
      ),
    );
  }
}

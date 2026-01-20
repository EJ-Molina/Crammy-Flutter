
import 'package:crammy_app/models/file_data.dart';
import 'package:crammy_app/models/quiz_item.dart';
import 'package:crammy_app/screens/learn_screen_overall/quiz/generateMethods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';

class ShowModalCreateQuiz extends StatefulWidget {
  const ShowModalCreateQuiz({
    super.key,
    required this.files,
    required this.onCreate,
  });

  final Function onCreate;
  final List<FileInfo> files;

  @override
  State<ShowModalCreateQuiz> createState() => _ShowModalCreateQuizState();
}

class _ShowModalCreateQuizState extends State<ShowModalCreateQuiz> {
  @override
  Widget build(BuildContext context) {
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
          "Choose a file to create quiz",
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
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return chooseQuizType(file);
                  },
                );
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

  Column chooseQuizType(FileInfo file) {
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
          "Choose the quiz type",
          style: TextStyle(
            color: Color(0xFF2D3E50),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListView(
          shrinkWrap: true,
          children: [
            //MC BUTTON
            GestureDetector(
              onTap: () async {
                await Generate.onCreateMCQuiz(file, context);
                // Create a new FileInfo for this quiz type
                final newQuizFile = FileInfo(
                  origName: file.origName,
                  filepath: file.filepath,
                  fileExtension: file.fileExtension,
                  fileSize: file.fileSize,
                  contentGenerated: file.contentGenerated,
                  quizzesFromContent: file.quizzesFromContent == null
                      ? null
                      : List<QuizItem>.from(file.quizzesFromContent!),
                );
                widget.onCreate(newQuizFile);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(Icons.file_copy),
                    title: Text(
                      "Multiple Choice",
                      style: TextStyle(fontWeight: .bold),
                    ),
                  ),
                ),
              ),
            ),
            // T OR F BTN
            GestureDetector(
              onTap: () async {
                await Generate.onCreateTFQuiz(file, context);
                final newQuizFile = FileInfo(
                  origName: file.origName,
                  filepath: file.filepath,
                  fileExtension: file.fileExtension,
                  fileSize: file.fileSize,
                  contentGenerated: file.contentGenerated,
                  quizzesFromContent: file.quizzesFromContent == null
                      ? null
                      : List<QuizItem>.from(file.quizzesFromContent!),
                );
                widget.onCreate(newQuizFile);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(Icons.file_copy),
                    title: Text(
                      "True or False",
                      style: TextStyle(fontWeight: .bold),
                    ),
                  ),
                ),
              ),
            ),
            // IDENTI BTN
            GestureDetector(
              onTap: () async {
                await Generate.onCreateIdentificationQuiz(file, context);
                final newQuizFile = FileInfo(
                  origName: file.origName,
                  filepath: file.filepath,
                  fileExtension: file.fileExtension,
                  fileSize: file.fileSize,
                  contentGenerated: file.contentGenerated,
                  quizzesFromContent: file.quizzesFromContent == null
                      ? null
                      : List<QuizItem>.from(file.quizzesFromContent!),
                );
                widget.onCreate(newQuizFile);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(Icons.file_copy),
                    title: Text(
                      "Identification",
                      style: TextStyle(fontWeight: .bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

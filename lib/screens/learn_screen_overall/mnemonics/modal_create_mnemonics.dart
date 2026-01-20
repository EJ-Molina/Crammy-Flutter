import 'dart:convert';

import 'package:crammy_app/models/file_data.dart';
import 'package:crammy_app/models/mnemonics_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


class ShowModalCreateMnemonics extends StatefulWidget {
  const ShowModalCreateMnemonics({
    super.key,
    required this.files,
    required this.onCreate,
  });

  final Function onCreate;
  final List<FileInfo> files;

  @override
  State<ShowModalCreateMnemonics> createState() =>
      _ShowModalCreateMnemonicsState();
}

class _ShowModalCreateMnemonicsState extends State<ShowModalCreateMnemonics> {
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
          "Choose a file to create mnemonics",
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
                // widget.onCreate(file);
                final generatedMnemonics = await onCreateMnemonics(file);
                final newMnemonicsFile = FileInfo(
                  origName: file.origName,
                  filepath: file.filepath,
                  fileExtension: file.fileExtension,
                  fileSize: file.fileSize,
                  contentGenerated: file.contentGenerated,
                  mnemonicsFromContent: generatedMnemonics
                );
                widget.onCreate(newMnemonicsFile);
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

 Future<List<MnemonicsItem>> onCreateMnemonics(FileInfo file) async {
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      systemInstruction: Content.system('''
      You are a professional mnemonic generator. Given the following lesson content, extract the most important concepts and generate a list of mnemonics in JSON format. Each item should have a "Mnemonics" field (the mnemonic itself) and an "Explanation" field (a brief explanation of how the mnemonic helps remember the concept). Output only a JSON array, no extra text.

      Example output:
      [
        {"Mnemonics": "PEMDAS", "Explanation": "PEMDAS helps remember the order of operations: Parentheses, Exponents, Multiplication, Division, Addition, Subtraction."},
        {"Mnemonics": "ROYGBIV", "Explanation": "ROYGBIV helps remember the colors of the rainbow: Red, Orange, Yellow, Green, Blue, Indigo, Violet."}
      ]

      Give me at least 5.
      Lesson content:
      {content}
'''),
    );

    showLoadingDialog(context); // to open the loading dialog
    final response = await model.generateContent([
      Content.text(file.contentGenerated),
    ]);
    Navigator.of(context, rootNavigator: true).pop(); // to close the dialog

    var jsonString = response.text!.trim();
    if (jsonString.startsWith('```')) {
      jsonString = jsonString.replaceAll(RegExp(r'```[a-zA-Z]*'), '').trim();
    }

    final List<dynamic> jsonList = json.decode(jsonString);
    final mnemonics = jsonList
        .map((json) => MnemonicsItem.fromJson(json))
        .toList();

    print(jsonString);
    print('Start: ${jsonString.substring(0, 100)}');
    print('End: ${jsonString.substring(jsonString.length - 100)}');
    return mnemonics;
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../models/file_data.dart';
import '../../../models/quiz_item.dart';

class Generate {
  

  // for Identi
  static Future<void> onCreateIdentificationQuiz(FileInfo file, BuildContext context) async {
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      systemInstruction: Content.system('''
    You are a professional quiz generator. Given the following lesson content, generate a list of identification quiz questions in JSON format. Each item should have the following fields:
    - "type": "ID"
    - "question": the identification question (e.g., "What is the process by which plants make food?")
    - "answer": the correct answer (e.g., "Photosynthesis")

    Output only a JSON array, no extra text.

    Example output:
    [
      {
        "type": "ID",
        "question": "What is the process by which plants make food?",
        "answer": "Photosynthesis"
      },
      {
        "type": "ID",
        "question": "Who developed the theory of relativity?",
        "answer": "Albert Einstein"
      }
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
    final quizID = jsonList.map((json) => QuizItem.fromJson(json)).toList();

    print(jsonString);
    print('Start: ${jsonString.substring(0, 100)}');
    print('End: ${jsonString.substring(jsonString.length - 100)}');
    file.quizzesFromContent = quizID;
  }

  // for T or F
  static Future<void> onCreateTFQuiz(FileInfo file, BuildContext context) async {
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      systemInstruction: Content.system('''
  You are a professional quiz generator. Given the following lesson content, generate a list of True or False quiz questions in JSON format. Each item should have the following fields:
  - "type": "TF"
  - "question": the quiz question
  - "answer": either "True" or "False" (as a string)
  
  Output only a JSON array, no extra text.
  
  Example output:
  [
    {
      "type": "TF",
      "question": "The Earth is flat.",
      "answer": "false"
    },
    {
      "type": "TF",
      "question": "Water boils at 100°C at sea level.",
      "answer": "true"
    }
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
    final quizTF = jsonList.map((json) => QuizItem.fromJson(json)).toList();

    print(jsonString);
    print('Start: ${jsonString.substring(0, 100)}');
    print('End: ${jsonString.substring(jsonString.length - 100)}');
    file.quizzesFromContent = quizTF;
  }

  //for MC
  static Future<void> onCreateMCQuiz(FileInfo file, BuildContext context) async {
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      systemInstruction: Content.system('''
    You are a professional quiz generator. Given the following lesson content, generate a list of multiple choice quiz questions in JSON format. Each item should have the following fields:
    - "type": "MC"
    - "question": the quiz question
    - "choices": a list of 4 possible answers (strings)
    - "answer": the correct answer (must match one of the choices)
    
    Output only a JSON array, no extra text.
    
    Example output:
    [
      {
        "type": "MC",
        "question": "What is the capital of France?",
        "choices": ["Paris", "London", "Berlin", "Madrid"],
        "answer": "Paris"
      },
      {
        "type": "MC",
        "question": "Which planet is known as the Red Planet?",
        "choices": ["Earth", "Mars", "Jupiter", "Venus"],
        "answer": "Mars"
      }
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
    final quizMC = jsonList.map((json) => QuizItem.fromJson(json)).toList();

    print(jsonString);
    print('Start: ${jsonString.substring(0, 100)}');
    print('End: ${jsonString.substring(jsonString.length - 100)}');
    file.quizzesFromContent = quizMC;
  }

  static void showLoadingDialog(BuildContext context) {
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

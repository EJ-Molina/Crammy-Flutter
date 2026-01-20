import 'package:crammy_app/models/quiz_item.dart';
import 'package:crammy_app/screens/learn_screen_overall/quiz/quiz_id_type.dart';
import 'package:crammy_app/screens/learn_screen_overall/quiz/quiz_tf_type.dart';
import 'package:flutter/material.dart';

import 'quiz_mc_type.dart';

class QuizContent extends StatefulWidget {
  const QuizContent({super.key, required this.quizzes, required this.index});
  final List<QuizItem>? quizzes;
  final int index;

  @override
  State<QuizContent> createState() => _QuizContentState();
}

class _QuizContentState extends State<QuizContent> {
  @override
  Widget build(BuildContext context) {
    final quizzes = widget.quizzes;

    switch (quizzes!.first.type) {
      case 'MC':
        return QuizMcType(quizzes: quizzes);
      case 'TF':
        return QuizTfType(quizzes: quizzes);
      case 'ID':
        return QuizIdType(quizzes: quizzes);
      default:
        return Center(child: Text('Unknown quiz type'));
    }
  }
}

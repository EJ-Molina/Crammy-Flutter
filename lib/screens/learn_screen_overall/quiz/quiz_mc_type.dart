import 'package:crammy_app/models/quiz_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

class QuizMcType extends StatefulWidget {
  const QuizMcType({super.key, required this.quizzes});

  final List<QuizItem> quizzes;

  @override
  State<QuizMcType> createState() => _QuizMcTypeState();
}

class _QuizMcTypeState extends State<QuizMcType> {
  var index = 0;
  var score = 0;
  var isDone = false;

  void checkAns(String ans) {
    userAnswers[index] = ans;
    var quizzes = widget.quizzes; // make simpler
    // add or nor
    score += ans == quizzes[index].answer ? 1 : 0;
    if (index < quizzes.length - 1) {
      index++;
    } else {
      isDone = true;
    }
    setState(() {});
  }

  List<String?> userAnswers = [];
  @override
  void initState() {
    super.initState();
    userAnswers = List.filled(widget.quizzes.length, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz - Multiple Choice"),
        backgroundColor: Color(0xFF2D3E50),
        foregroundColor: Colors.white,
      ),
      body: isDone ? resultScreen() : questionScreen(),
    );
  }

  Widget questionScreen() {
    widget.quizzes.forEach((e) => print(e.choices));
    final currentQuiz = widget.quizzes[index];
    print(currentQuiz.answer);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: .5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: LinearProgressBar(
                maxSteps: widget.quizzes.length,
                progressType: ProgressType.linear,
                currentStep: index + 1,
                progressColor: Color(0xFF1EAE98),
                backgroundColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                minHeight: 13,
              ),
            ),
            Gap(20),
            Text(
              "Question ${index + 1} / ${widget.quizzes.length}",
              style: TextStyle(fontSize: 20, fontWeight: .bold),
            ),
            Gap(20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  currentQuiz.question,
                  textAlign: .center,
                  style: TextStyle(fontSize: 20, fontWeight: .bold),
                ),
              ),
            ),
            Gap(20),
            choice(currentQuiz.choices![0]),
            choice(currentQuiz.choices![1]),
            choice(currentQuiz.choices![2]),
            choice(currentQuiz.choices![3]),
          ],
        ),
      ),
    );
  }

  Widget choice(String c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () => checkAns(c),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          backgroundColor: Color(0xFF2D3E50),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          minimumSize: Size(double.infinity, 43),
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(c),
        ),
      ),
    );
  }

  Widget resultScreen() {
    // return Center(
    //   child: Text("${score.toString()} / ${widget.quizzes.length}"),
    // );
    return Center(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 80.0,
                vertical: 20,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Quiz Completed',
                      style: TextStyle(fontWeight: .w600, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Your Score is: ",
                      style: TextStyle(fontWeight: .w600, fontSize: 20),
                    ),
                  ),
                  Text(
                    "${score.toString()} / ${widget.quizzes.length}",
                    style: TextStyle(fontWeight: .w900, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          Gap(20),
          Container(
            decoration: BoxDecoration(
              borderRadius: .circular(12),
              color: Color(0xFF2D3E50),
            ),
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 4),
            child: Text(
              "Answers",
              style: TextStyle(
                fontSize: 18,
                fontWeight: .bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.quizzes.length,
              itemBuilder: (_, index) {
                final quiz = widget.quizzes[index];
                final userAns = userAnswers[index];
                return Column(
                  children: [
                    Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Q${index + 1}: ${quiz.question}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...quiz.choices!.map((choice) {
                              Color? color;
                              if (choice == quiz.answer) {
                                color = Color(0xFF1EAE98);
                              }
                              if (userAns != quiz.answer && choice == userAns) {
                                color = Colors.red;
                              }
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ListTile(
                                  title: Text(
                                    "${color != null && color != Color(0xFF1EAE98) ? "Your answer:" : ""} $choice",
                                    style: TextStyle(
                                      color: color != null
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: color != null
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            Gap(10),
                            Center(
                              child: Text(
                                userAns == quiz.answer
                                    ? "Correct!"
                                    : "Incorrect",
                                style: TextStyle(
                                  color: userAns == quiz.answer
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: .8,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

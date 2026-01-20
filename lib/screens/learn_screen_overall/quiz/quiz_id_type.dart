import 'package:crammy_app/models/quiz_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

class QuizIdType extends StatefulWidget {
  const QuizIdType({super.key, required this.quizzes});

  final List<QuizItem> quizzes;

  @override
  State<QuizIdType> createState() => _QuizIdType();
}

class _QuizIdType extends State<QuizIdType> {
  var index = 0;
  var score = 0;
  var isDone = false;
  var answerCtr = TextEditingController();

  void checkAns(String ans) {
    userAnswers[index] = ans;
    var quizzes = widget.quizzes; // make simpler
    // add or nor
    score +=
        ans.trim().toLowerCase() == quizzes[index].answer?.trim().toLowerCase()
        ? 1
        : 0;
    if (index < quizzes.length - 1) {
      index++;
    } else {
      isDone = true;
    }
    answerCtr.clear();
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
        title: Text("Quiz - Identification"),
        backgroundColor: Color(0xFF2D3E50),
        foregroundColor: Colors.white,
      ),
      body: isDone ? resultScreen() : questionScreen(),
    );
  }

  Widget questionScreen() {
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
              "Question ${index + 1}/ ${widget.quizzes.length}",
              style: TextStyle(fontSize: 20, fontWeight: .bold),
            ),
            Gap(20),
            //QUESTION IN CARD
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
            TextField(
              controller: answerCtr,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                label: Text("Type your answer"),
              ),
            ),
            Gap(50),
            ElevatedButton(
              onPressed: () => checkAns(answerCtr.text),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: .circular(5)),
                backgroundColor: Color(0xFF1EAE98),
                foregroundColor: Colors.white,
              ),
              child: Text(
                "Confirm",
                style: TextStyle(fontWeight: .bold, fontSize: 20),
              ),
            ),
          ],
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Q${index + 1}: ${quiz.question}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Gap(10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    userAns!.toLowerCase().trim() ==
                                        quiz.answer!.toLowerCase().trim()
                                    ? Color(0xFF1EAE98)
                                    : Color(0xFFE94141),
                                borderRadius: .circular(5),
                              ),
                              child: Text(
                                "Answer: ${quiz.answer!.toUpperCase()}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: .bold,
                                ),
                              ),
                            ),
                            Gap(15),
                            Text(
                              "Your Answer: ${userAns.toUpperCase()}",
                              style: TextStyle(fontWeight: .bold),
                            ),
                            Gap(5),
                            Center(
                              child: Text(
                                userAns.toLowerCase().trim() ==
                                        quiz.answer!.toLowerCase().trim()
                                    ? "Correct!"
                                    : "Incorrect",
                                style: TextStyle(
                                  color:
                                      userAns.toLowerCase().trim() ==
                                          quiz.answer!.toLowerCase().trim()
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

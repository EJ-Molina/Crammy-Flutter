import 'package:crammy_app/models/file_data.dart';
import 'package:crammy_app/screens/container_home+learn/show_modal_choose_card.dart';
import 'package:crammy_app/screens/learn_screen_overall/learn_screen.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';

import '../home_screen_overall/home_screen.dart';
import 'camera_screen.dart';
import '../learn_screen_overall/flashcard/modal_create_flashcard.dart';
import '../learn_screen_overall/mnemonics/modal_create_mnemonics.dart';
import '../learn_screen_overall/quiz/modal_create_quiz.dart';

class MyAppContainer extends StatefulWidget {
  const MyAppContainer({super.key});

  @override
  State<MyAppContainer> createState() => _MyAppContainer();
}

class _MyAppContainer extends State<MyAppContainer> {
  List<FileInfo> files = [
    FileInfo(origName: "Example File", contentGenerated: "example"),
  ];
  int index = 0;
  dynamic response;

  // FOR CAMERA TO ADD FILE
  void addFileFromCam(FileInfo file) {
    files.add(file);
    setState(() {});
  }

  int learnTabIndex = 0;

  //FLASHCARD
  List<FileInfo> flashCardData = [];
  void onCreateFlashCard(FileInfo file) {
    flashCardData.add(file);
    setState(() {});
  }

  //MNEMONICS
  List<FileInfo> mnemonicsData = [];
  void onCreateMnemonics(FileInfo file) {
    mnemonicsData.add(file);
    setState(() {});
  }

  //QUIZZES
  List<FileInfo> quizData = [];
  void onCreateQuiz(FileInfo file) {
    quizData.add(file);
    setState(() {});
  }

  // ON DELETION OF DATA OF FLASHCARD, MNEMONICS, QUIZ
  void onDeleteFlashCard(FileInfo file, List<FileInfo> list) {
    list.remove(file);
    setState(() {});
  }

  List<Widget> get screens => [
    HomeScreen(files: files),
    LearnScreen(
      onTabChanged: onTabChange,
      flashCardData: flashCardData,
      mnemonicsData: mnemonicsData,
      quizData: quizData,
      onDelete: onDeleteFlashCard,
    ),
  ];

  void onTabChange(int tabIndex) {
    learnTabIndex = tabIndex;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF2D3E50),
              ),
              child: Text('Crammy Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                setState(() { index = 0; });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Learn'),
              onTap: () {
                setState(() { index = 1; });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 75,
        width: 75,
        child: FloatingActionButton(
          onPressed: () {
            if (index == 0) {
              showModalChoose();
            } else {
              if (learnTabIndex == 0) {
                showModalCreate();
              } else if (learnTabIndex == 1) {
                showModalCreate();
              } else if (learnTabIndex == 2) {
                showModalCreate();
              }
            }
          },
          backgroundColor: Color(0xFF2D3E50),
          child: Icon(Icons.add_rounded, size: 50, color: Color(0xFFA1C4FD)),
        ),
      ),
      bottomNavigationBar: Container(
        color: Color(0xFFC2E9FB),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: index,
            onTap: (selectedIndex) {
              setState(() {
                index = selectedIndex;
              });
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0xFF2D3E50),
            unselectedItemColor: Color(0xFF2D3E50).withValues(alpha: 0.80),
            selectedFontSize: 12,
            items: [
              BottomNavigationBarItem(
                activeIcon: Column(
                  children: [
                    Image.asset("assets/images/line.png"),
                    Icon(Icons.home_rounded, size: 32),
                  ],
                ),
                icon: Icon(Icons.home_rounded, size: 32),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon: Column(
                  children: [
                    Image.asset("assets/images/line.png"),
                    Icon(Icons.book_rounded, size: 32),
                  ],
                ),
                icon: Icon(Icons.book, size: 32),
                label: 'Learn',
              ),
            ],
          ),
        ),
      ),
      // MAIN BODY
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
        child: screens[index],
      ),
    );
  }

  // ACTION BUTTON/MODAL FOR HOME
  void showModalChoose() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ShowModalChooseCard(
          chooseFile: chooseFile,
          takePhoto: takePhoto,
        );
      },
    );
  }

  // ACTION BUTTON/MODAL FOR LEARN
  void showModalCreate() {
    if (learnTabIndex == 0) {
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return ShowModalCreateFlashCard(
            files: files,
            onCreate: onCreateFlashCard,
          );
        },
      );
    } else if (learnTabIndex == 1) {
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return ShowModalCreateMnemonics(
            files: files,
            onCreate: onCreateMnemonics,
          );
        },
      );
    } else if (learnTabIndex == 2) {
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return ShowModalCreateQuiz(files: files, onCreate: onCreateQuiz);
        },
      );
    }
  }

  // OPEN CAMERA
  void takePhoto() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CameraScreen(addFile: addFileFromCam,)));
  }

  // choose file and summarization
  void chooseFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    //DEFINE THE TYPE OF FILE
    final file = result.files.first;
    final bytes = await file.xFile.readAsBytes();
    final fileExtension = file.xFile.path.split('.').last.toLowerCase();

    //START TO PASS IN AI
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      systemInstruction: Content.system(
        '''You are a professional lesson summarizer. Summarize the following content clearly and concisely, preserving the main ideas, themes, and key takeaways. Maintain the tone and style of the lesson. If it's important part, highlight it, and make sure you still got the important informations. Focus on the core arguments, lessons, and practical insights.
Output format:
1. Title:
4. Summarize Version:
5. Key Takeaways / Lessons:
6. Whole content, unsummarize version but in organized format
''',
      ),
    );

    if (fileExtension == "docx") {
      //LOADING INDICATOR WHEN WAITING
      showLoadingDialog(context);

      // Convert .docx bytes to a plain String
      final textContent = docxToText(bytes);
      // print(textContent);
      response = await model.generateContent([Content.text(textContent)]);
    } else if (fileExtension == "pdf" ||
        fileExtension == "jpg" ||
        fileExtension == "png") {
      //LOADING INDICATOR WHEN WAITING
      showLoadingDialog(context);
      //catch path
      final filePath = file.xFile.path;
      response = await model.generateContent([
        Content.multi([
          DataPart(
            lookupMimeType(filePath) ?? 'application/octet-stream',
            bytes,
          ),
        ]),
      ]);
    } else {
      await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                Text('Unsupported File'),
              ],
            ),
            content: Text(
              'Only DOCX, PDF, JPG, and PNG files are supported. Please select a valid file type.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK', style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      );
      return;
    }

    Navigator.of(context, rootNavigator: true).pop(); // to close the dialog
    print(response.text);

    final newFile = FileInfo(
      origName: file.name,
      filepath: file.path,
      fileExtension: file.extension,
      contentGenerated: response.text,
    );
    setState(() {
      files.add(newFile);
      Navigator.pop(context);
    });
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

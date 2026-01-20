import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';

import '../../models/file_data.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({required this.addFile, super.key});
  final Function addFile;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  XFile? picture;
  //for error prevention lang
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupCameraController();
    }
  }

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: picture == null ? showCam() : showCapture(),
    );
  }

  Widget showCapture() {
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          children: [
            Image.file(File(picture!.path)),
            Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    picture = null;
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    size: 90,
                    color: Color(0xFFACA9A9),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (dialogCon) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.only(
                            top: 50,
                            bottom: 20,
                            right: 40,
                            left: 40,
                          ),
                          actionsPadding: EdgeInsets.only(
                            bottom: 20,
                            right: 20,
                            left: 20,
                          ),
                          actionsAlignment: .spaceAround,
                          content: Text(
                            textAlign: .center,
                            "Proceed extracting text from this picture?",
                            style: TextStyle(fontWeight: .bold),
                          ),
                          actions: [
                            FilledButton(
                              onPressed: () {
                                Navigator.of(dialogCon).pop();
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: Colors.black, // Border color
                                    width: 1, // Border width
                                  ),
                                ),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            FilledButton(
                              onPressed: () async {
                                Navigator.of(dialogCon).pop();
                                Navigator.pop(context);
                                await scanImage();
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Color(0xFF1EAE98),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: Colors.black, // Border color
                                    width: 1, // Border width
                                  ),
                                ),
                              ),
                              child: Text(
                                "Extract",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.check_rounded,
                    size: 90,
                    color: Color(0xFFACA9A9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //SHOW ACTUAL CAMERA
  Widget showCam() {
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: .spaceEvenly,
          crossAxisAlignment: .center,
          children: [
            CameraPreview(cameraController!),
            IconButton(
              onPressed: () async {
                picture = await cameraController!.takePicture();
                // Gal.putImage(picture!.path); fpr saving to device
                setState(() {});
              },
              icon: Icon(Icons.camera, color: Colors.white, size: 60),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setupCameraController() async {
    List<CameraDescription> _cameras = await availableCameras();

    if (_cameras.isEmpty) return;
    setState(() {
      cameras = _cameras;
      cameraController = CameraController(
        _cameras.first,
        ResolutionPreset.high,
      );
    });

    cameraController?.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> scanImage() async {
    dynamic response;
    final result = picture;
    if (result == null) return;

    //DEFINE THE TYPE OF FILE
    final file = result;
    final bytes = await file.readAsBytes();
    final fileExtension = file.path.split('.').last.toLowerCase();

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

    if (fileExtension == "jpg" || fileExtension == "png") {
      //LOADING INDICATOR WHEN WAITING
      showLoadingDialog(context);
      //catch path
      final filePath = file.path;
      response = await model.generateContent([
        Content.multi([
          DataPart(
            // look Mime to check the file
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
    final newFile = FileInfo(
      origName: "Photo Taken",
      filepath: file.path,
      fileExtension: file.path.split('.').last.toLowerCase(),
      contentGenerated: response.text,
    );

    if (!mounted) return;
    setState(() {
      widget.addFile(newFile);
    });
    if (mounted) {
      Navigator.pop(context);
    }
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

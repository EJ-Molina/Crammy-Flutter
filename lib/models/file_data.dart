import 'package:crammy_app/models/quiz_item.dart';

import 'flashcard_item.dart';
import 'mnemonics_item.dart';

class FileInfo {
  int? id;
  String origName;
  String? filepath;
  String? fileExtension;
  int? fileSize;
  String contentGenerated;
  String? summary;
  int? quizSetId;
  DateTime? createdAt;
  List<FlashcardItem>? flashcardsFromContent;
  List<MnemonicsItem>? mnemonicsFromContent;
  List<QuizItem>? quizzesFromContent;
  dynamic quizStatistics;

  FileInfo({
    this.id,
    required this.origName,
    this.filepath,
    this.fileExtension,
    this.fileSize,
    required this.contentGenerated,
    this.summary,
    this.quizSetId,
    this.createdAt,
    this.flashcardsFromContent,
    this.mnemonicsFromContent,
    this.quizzesFromContent,
    this.quizStatistics,
  });
}

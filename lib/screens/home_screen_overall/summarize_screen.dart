import 'package:crammy_app/models/file_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SummarizeScreen extends StatelessWidget {
  const SummarizeScreen({super.key, required this.file});

  final FileInfo file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          file.origName,
          style: TextStyle(color: Color(0xFF2D3E50), fontWeight: .bold),
        ),
      ),
      body: ListView(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xFF1EAE98),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Summarized",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: .bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(file.contentGenerated, textAlign: .justify),
          ),
        ],
      ),
    );
  }
}

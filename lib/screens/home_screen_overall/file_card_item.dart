import 'package:crammy_app/screens/home_screen_overall/summarize_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/file_data.dart';

class FileCard extends StatelessWidget {
  const FileCard({
    super.key,
    required this.file,
    required this.index,
    required this.onDelete,
  });

  final int index;
  final FileInfo file;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => SummarizeScreen(file: file)),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.file_copy_rounded, color: Color(0xFF2D3E50)),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "File ${index + 1}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Created from \"${file.origName}\"",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        onDelete(file);
                      },
                      child: Icon(
                        Icons.cancel_outlined,
                        color: Color(0xFF2D3E50),
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.import_contacts_rounded,
                      color: Color(0xFF2D3E50),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../models/file_data.dart';
import '../header_humburger/header_humburger_part_component.dart';
import 'file_card_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.files});

  final List<FileInfo> files;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void onDelete(FileInfo file) {
    widget.files.remove(file);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            //Crammy + Humburger menu
            HeaderPart(),
            //
            SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF2D3E50),
                borderRadius: BorderRadius.circular(12),
              ),
              width: 100,
              height: 30,
              alignment: Alignment.center,
              child: Text(
                "Files",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) {
                  var item = widget.files[index];
                  return FileCard(file: item, index: index, onDelete: onDelete);
                },
                itemCount: widget.files.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

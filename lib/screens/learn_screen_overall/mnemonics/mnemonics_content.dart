import 'package:crammy_app/models/file_data.dart';
import 'package:crammy_app/models/mnemonics_item.dart';
import 'package:flutter/material.dart';

class MnemonicsContent extends StatefulWidget {
  const MnemonicsContent({super.key, required this.file, required this.index});

  final FileInfo file;
  final int index;

  @override
  State<MnemonicsContent> createState() => _MnemonicsContentState();
}

class _MnemonicsContentState extends State<MnemonicsContent> {
  @override
  Widget build(BuildContext context) {
    final List<MnemonicsItem> mnemonicsData =
        widget.file.mnemonicsFromContent ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text("Mnemonics ${widget.index + 1}"),
        // backgroundColor: Color(0xFFA1C4FD),
      ),
      body: ListView.builder(
        itemBuilder: (_, index) {
          var mnemonicData = mnemonicsData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      mnemonicData.mnemonics,
                      textAlign: .center,
                      style: TextStyle(
                        fontWeight: .bold,
                        color: Color(0xFF2D3E50),
                      ),
                    ),
                    Divider(indent: 10, endIndent: 10, color: Colors.black, thickness: .5,),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: .topLeft,
                        child: Text(
                          "Explanation:",
                          style: TextStyle(fontWeight: .w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(mnemonicData.explanation, textAlign: .center),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: mnemonicsData.length,
      ),
    );
  }
}

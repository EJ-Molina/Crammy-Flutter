import 'package:crammy_app/models/file_data.dart';
import 'package:crammy_app/screens/learn_screen_overall/mnemonics/mnemonics_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MnemonicsPage extends StatefulWidget {
  final List<FileInfo>? mnemonicsData;
  final Function onDelete;
  const MnemonicsPage({Key? key, required this.mnemonicsData, required this.onDelete}) : super(key: key);

  @override
  State<MnemonicsPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<MnemonicsPage> {
  // var flashCardData = [];
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: widget.mnemonicsData == null || widget.mnemonicsData!.isEmpty
          ? Center(child: Text("No Mnemonics Created"))
          : ListView.builder(
              itemBuilder: (_, index) {
                var mnemonics = widget.mnemonicsData![index];
                print("index $index HASHHHHH: ${mnemonics.hashCode}");
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) =>
                            MnemonicsContent(file: mnemonics, index: index),
                      ),
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
                            child: Icon(
                              Icons.file_copy_rounded,
                              color: Color(0xFF2D3E50),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mnemonics ${index + 1}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Created from \"${mnemonics.origName}\"",
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
                                    widget.onDelete(
                                      mnemonics,
                                      widget.mnemonicsData,
                                    );
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
              },
              itemCount: widget.mnemonicsData!.length,
            ),
    );
  }
}

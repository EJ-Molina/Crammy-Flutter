import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShowModalChooseCard extends StatefulWidget {
  const ShowModalChooseCard({
    super.key,
    required this.chooseFile,
    required this.takePhoto,
  });
  final Function chooseFile;
  final Function takePhoto;
  @override
  State<ShowModalChooseCard> createState() => _ShowModalChooseCardState();
}

class _ShowModalChooseCardState extends State<ShowModalChooseCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 220,
        child: Column(
          children: [
            SizedBox(height: 15),
            SvgPicture.asset(
              'assets/svg/line_choose_file.svg',
              height: 7,
              width: 14,
            ),
            SizedBox(height: 15),
            Text(
              "Choose an action",
              style: TextStyle(
                color: Color(0xFF2D3E50),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    // CAMERAAAAAAAAAAAAAAAA ICONNN
                    IconButton(
                      onPressed: () {
                        widget.takePhoto();
                      },
                      icon: Icon(Icons.camera_alt_rounded, size: 95),
                    ),
                    Text(
                      "Camera",
                      style: TextStyle(
                        color: Color(0xFF2D3E50),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                //FILEEEEEEEEEEEEEEEEE ICONNN
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.chooseFile();
                      },
                      icon: Icon(Icons.folder_open_rounded, size: 95),
                    ),
                    Text(
                      "Files",
                      style: TextStyle(
                        color: Color(0xFF2D3E50),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  //TO SEE IF THERE IS AVAIL CAMS
}

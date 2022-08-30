import 'package:flutter/material.dart';
import '../../functions/design_widgets.dart';
import 'playlist_functions.dart';

TextEditingController playlistTextController = TextEditingController();

Future openDialog(BuildContext context) async {
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: backgroundColor1,
          title: functionText(
              'Create Playlist', Colors.white, FontWeight.normal, 20),
          content: TextField(
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            controller: playlistTextController,
            autofocus: true,
            decoration: InputDecoration(
                hintText: 'Playlist Name',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: roseColor))),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                if (playlistTextController.text == "") {
                  return;
                } else {
                  playlistCreation(playlistTextController.text);

                  keyUpdate();
                  playlistTextController.clear();
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      });
}

Future updatePlaylistName(BuildContext context, String playlistName) async {
  String value1 = "";
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: backgroundColor1,
          title: functionText(
              'Update Playlist Name', Colors.white, FontWeight.normal, 20),
          content: TextFormField(
            initialValue: playlistName,
            onChanged: (value) {
              value1 = value;
            },
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            autofocus: true,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: roseColor))),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                Navigator.pop(context);
                if (value1 == "") {
                  return;
                }
                await playlistNameUpdate(playlistName, value1);
              },
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      });
}

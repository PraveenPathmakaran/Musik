import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/playlist_Screen/screen_playlist_controller.dart';
import '../../core/colors.dart';
import '../widgets.dart';

TextEditingController playlistTextController = TextEditingController();
final PlaylistController playlistController = Get.put(PlaylistController());

Future<dynamic> playlistCreateDialogue(BuildContext context) async {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: kBackgroundColor1,
          title: functionText(
              'Create Playlist', Colors.white, FontWeight.normal, 20),
          content: TextField(
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            controller: playlistTextController,
            autofocus: true,
            decoration: const InputDecoration(
                hintText: 'Playlist Name',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kRoseColor))),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Get.back();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                if (playlistTextController.text == '') {
                  return;
                } else {
                  playlistController
                      .playlistCreation(playlistTextController.text);

                  playlistController.keyUpdate();
                  playlistTextController.clear();
                  Get.back();
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

Future<dynamic> updatePlaylistName(
    BuildContext context, String playlistName) async {
  String value1 = '';
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: kBackgroundColor1,
          title: functionText(
              'Update Playlist Name', Colors.white, FontWeight.normal, 20),
          content: TextFormField(
            initialValue: playlistName,
            onChanged: (String value) {
              value1 = value;
            },
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            autofocus: true,
            decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kRoseColor))),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Get.back();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                Get.back();
                if (value1 == '') {
                  return;
                }
                await playlistController.playlistNameUpdate(
                    playlistName, value1);
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

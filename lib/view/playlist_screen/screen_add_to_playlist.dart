import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/playlist_Screen/screen_playlist_controller.dart';
import '../../controller/splash_screen/screen_splash.dart';
import '../../core/colors.dart';
import '../widgets.dart';
import 'playlist_widgets.dart';
import 'screen_playlist.dart';

class SreenAddToPlaylist extends StatelessWidget {
  SreenAddToPlaylist({super.key, required this.playlistname});
  final String playlistname;
  final PlaylistController playlistController = Get.put(PlaylistController());

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child:
            // Container(
            //   padding: const EdgeInsets.only(left: 8, right: 8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       functionText('Add Songs to $playlistname', Colors.white,
            //           FontWeight.bold, 17),
            //       TextButton(
            //           onPressed: () {
            //             Get.back();
            //           },
            //           child:
            //               functionText('Close', Colors.white, FontWeight.bold, 17))
            //     ],
            //   ),
            // ),
            ListView.builder(
          controller: ScrollController(),
          itemBuilder: (BuildContext context, int index) {
            log('haa');
            return Card(
              color: kColorListTile,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/images/musicIcon1.png'),
                ),
                title: Text(
                  allAudioListFromDB[index].title.toString(),
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                subtitle: Text(
                  allAudioListFromDB[index].artist.toString(),
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                trailing: IconButton(
                  icon: Obx(() {
                    return playlistController.playlistSongsFromDB
                            .contains(allAudioListFromDB[index])
                        ? functionIcon(Icons.remove, 20, Colors.white)
                        : functionIcon(Icons.add, 20, Colors.white);
                  }),
                  onPressed: () async {
                    playlistController.tempPlaylistId
                            .contains(allAudioListFromDB[index].id.toString())
                        ? await playlistController.playlistSongDelete(
                            allAudioListFromDB[index].id.toString(),
                            playlistname)
                        : await playlistController.addtoPlaylistSongs(
                            allAudioListFromDB[index].id.toString(),
                            playlistname);
                    await playlistController.keyUpdate();
                  },
                ),
              ),
            );
          },
          itemCount: allAudioListFromDB.length,
          shrinkWrap: true,
        ));
  }
}

class ScreenAddToPlaylistFromHome extends StatelessWidget {
  ScreenAddToPlaylistFromHome({super.key, required this.id});
  final String id;
  final PlaylistController playlistController = Get.put(PlaylistController());

  @override
  Widget build(BuildContext context) {
    playlistController.keyUpdate();
    return Obx(() {
      return ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(),
              TextButton.icon(
                  onPressed: () {
                    playlistCreateDialogue(context);
                  },
                  icon: const Icon(
                    Icons.playlist_add_circle_sharp,
                    color: Colors.white,
                  ),
                  label: functionText(
                      'Playlist Create', Colors.white, FontWeight.bold, 20)),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: kWhiteColor),
                ),
              )
            ],
          ),
          ListView.builder(
            controller: controller1,
            shrinkWrap: true,
            itemCount: playlistController.allkey.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  playlistController.getPlaylistSongs(
                      playlistController.allkey[index].toString());
                  if (playlistController.tempPlaylistId.contains(id)) {
                    Get.back();
                    return snackBar(
                        'Song exist in ${playlistController.allkey[index].toString()}',
                        Colors.red,
                        context);
                  }
                  playlistController.addtoPlaylistSongs(
                      id, playlistController.allkey[index].toString());
                  Get.back();
                  snackBar(
                      'Added to ${playlistController.allkey[index].toString()}',
                      kBackgroundColor2,
                      context);
                },
                leading: const Icon(
                  Icons.playlist_play,
                  color: Colors.white,
                  size: 35,
                ),
                title: functionText(playlistController.allkey[index].toString(),
                    Colors.white, FontWeight.normal, 20),
              );
            },
          ),
        ],
      );
    });
  }
}

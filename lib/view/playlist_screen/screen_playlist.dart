import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/playlist_Screen/screen_playlist_controller.dart';

import '../../core/colors.dart';
import '../widgets.dart';
import 'playlist_widgets.dart';
import 'screen_playlist_songs.dart';

ScrollController controller1 = ScrollController();

class ScreenPlaylist extends StatelessWidget {
  ScreenPlaylist({super.key});

  final PlaylistController playlistController = Get.put(PlaylistController());

  @override
  Widget build(BuildContext context) {
    playlistController.keyUpdate();

    return Obx(() {
      return playlistController.allkey.isEmpty
          ? Container(
              color: Colors.black,
              child: Center(
                child: functionText(
                    'Create New Playlist', Colors.white, FontWeight.bold, 20),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: playlistController.allkey.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 80,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: kColorListTile,
                      child: Center(
                        child: ListTile(
                          onTap: () {
                            playlistController.getPlaylistSongs(
                                playlistController.allkey[index].toString());

                            Get.to(
                              ScreenPlaylistAudios(
                                playlistname:
                                    playlistController.allkey[index].toString(),
                              ),
                            );
                          },
                          leading: const Icon(
                            Icons.playlist_play,
                            color: Colors.white,
                            size: 35,
                          ),
                          title: functionText(
                              playlistController.allkey[index].toString(),
                              Colors.white,
                              FontWeight.normal,
                              20),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              playlistController.findPlaylistCount(
                                  playlistController.allkey[index].toString()),
                              IconButton(
                                icon: functionIcon(
                                    Icons.more_vert, 20, Colors.white),
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: kAppbarColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30),
                                      ),
                                    ),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PlayListRemove(
                                        index: index,
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
    });
  }
}

class PlayListRemove extends StatelessWidget {
  const PlayListRemove({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                functionText('', Colors.white, FontWeight.bold, 18),
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: functionText(
                        'Close', Colors.white, FontWeight.bold, 18))
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Get.defaultDialog(
                title: 'Alert',
                content: const Text('Do you want to remove?'),
                cancel: ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () => Get.back(),
                ),
                confirm: ElevatedButton(
                  child: const Text('Confirm'),
                  onPressed: () {
                    playlistController.playlistDelete(
                        playlistController.allkey[index].toString());
                    snackBar(
                        'Deleted Successfully', kBackgroundColor2, context);
                    Get.back();
                    Get.back();
                  },
                ),
              );
            },
            child: functionText(
                'Delete Playlist', Colors.white, FontWeight.bold, 20),
          ),
          TextButton(
              onPressed: () async {
                await updatePlaylistName(
                    context, playlistController.allkey[index].toString());
              },
              child: functionText(
                  'Edit Playlist', Colors.white, FontWeight.bold, 20)),
        ],
      ),
    );
  }
}

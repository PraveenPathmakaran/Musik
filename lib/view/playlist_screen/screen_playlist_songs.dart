import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/audio_functions.dart';
import '../../controller/favorite_screen/screen_favourites_controller.dart';
import '../../controller/home_screen/home_screen_controller.dart';
import '../../controller/playlist_Screen/screen_playlist_controller.dart';
import '../../controller/splash_screen/screen_splash.dart';
import '../../core/colors.dart';
import '../favourite_screen/screen_favourite.dart';
import '../mini_player/mini_player.dart';
import '../play_screen/screen_play.dart';
import '../widgets.dart';
import 'screen_add_to_playlist.dart';

class ScreenPlaylistAudios extends StatelessWidget {
  ScreenPlaylistAudios({super.key, required this.playlistname});
  final String playlistname;

  final FavouritesController favouritesController =
      Get.put(FavouritesController());
  final PlaylistController playlistController = Get.put(PlaylistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: kAppbarColor,
          elevation: 0,
          title: Text(playlistname),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: kAppbarColor,
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return SreenAddToPlaylist(
                      playlistname: playlistname,
                    );
                  });
            },
            child: functionIcon(Icons.add, 15, Colors.white)),
        body: Obx(
          () {
            return playlistController.playlistSongsFromDB.isEmpty
                ? Container(
                    color: Colors.black,
                    child: Center(
                      child: functionText(
                          'No Songs Found', Colors.white, FontWeight.bold, 20),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: ListView.builder(
                      controller: ScrollController(),
                      itemBuilder: (BuildContext context, int index) {
                        return PlaylistSongCard(
                          index: index,
                          playlistname: playlistname,
                        );
                      },
                      itemCount: playlistController.playlistSongsFromDB.length,
                      shrinkWrap: true,
                    ),
                  );
          },
        ),
        bottomNavigationBar: MiniPlayer());
  }
}

class PlaylistSongCard extends StatelessWidget {
  PlaylistSongCard(
      {super.key, required this.index, required this.playlistname});
  final int index;
  final String playlistname;
  final FavouritesController favouritesController =
      Get.put(FavouritesController());
  final PlaylistController playlistController = Get.put(PlaylistController());
  final HomeScreenController _homeScreenController =
      Get.put(HomeScreenController());
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: kColorListTile,
      child: ListTile(
        onTap: () async {
          await createAudiosFileList(playlistController.playlistSongsFromDB);
          await audioPlayer.playlistPlayAtIndex(index);
          await Get.to(const ScreenPlay());
          _homeScreenController.miniPlayerVisibility.value = true;
          favouritesAudioListUpdate = false;
          playlistController.playlistAudioListUpdate = true;
        },
        leading: const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/images/songicon.png'),
        ),
        title: Text(
          playlistController.playlistSongsFromDB[index].title.toString(),
          maxLines: 1,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        subtitle: Text(
          playlistController.playlistSongsFromDB[index].artist.toString(),
          maxLines: 1,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        trailing: IconButton(
          icon: functionIcon(Icons.more_vert, 25, Colors.white),
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
                                  playlistController.playlistSongDelete(
                                      playlistController
                                          .playlistSongsFromDB[index].id
                                          .toString(),
                                      playlistname);

                                  snackBar('Removed From $playlistname',
                                      kBackgroundColor2, context);
                                  Get.back();
                                  Get.back();
                                },
                              ),
                            );
                          },
                          child: functionText('Remove From $playlistname',
                              Colors.white, FontWeight.bold, 20)),
                      TextButton(
                          onPressed: () {
                            if (!tempFavouriteList.contains(playlistController
                                .playlistSongsFromDB[index].id
                                .toString())) {
                              favouritesController.addFavouritesToDB(
                                  playlistController
                                      .playlistSongsFromDB[index].id
                                      .toString());
                              Get.back();
                              snackBar('Added to favourites', kBackgroundColor2,
                                  context);
                            }
                          },
                          child: tempFavouriteList.contains(playlistController
                                  .playlistSongsFromDB[index].id
                                  .toString())
                              ? functionText(
                                  '', Colors.white, FontWeight.bold, 20)
                              : functionText('Add to Favourites', Colors.white,
                                  FontWeight.bold, 20))
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newmusicplayer/controller/favorite_screen/screen_favourites_controller.dart';
import '../../core/colors.dart';
import '../../functions/audio_functions.dart';
import '../../functions/design_widgets.dart';
import '../../model/music_model.dart';
import '../favourite_screen/screen_favourite.dart';
import '../play_screen/screen_play.dart';
import '../splash_screen/screen_splash.dart';
import 'playlist_functions.dart';
import 'screen_add_to_playlist.dart';

bool playlistAudioListUpdate = false; //favourite list remove option
ValueNotifier<List<MusicModel>> playlistSongsFromDB = ValueNotifier([]);
List<String> tempPlaylistId = [];

class ScreenPlaylistAudios extends StatelessWidget {
  final String playlistname;
  ScreenPlaylistAudios({Key? key, required this.playlistname})
      : super(key: key);

  final favouritesController = Get.put(FavouritesController());

  @override
  Widget build(BuildContext context, {bool mounted = true}) {
    return ValueListenableBuilder(
        valueListenable: playlistSongsFromDB,
        builder: (context, value, child) {
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
                onPressed: (() {
                  showModalBottomSheet(
                      backgroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return SreenAddToPlaylist(
                          playlistname: playlistname,
                        );
                      });
                }),
                child: functionIcon(Icons.add, 15, Colors.white)),
            body: playlistSongsFromDB.value.isEmpty
                ? Container(
                    color: Colors.black,
                    child: Center(
                      child: functionText(
                          "No Songs Found", Colors.white, FontWeight.bold, 20),
                    ),
                  )
                : ValueListenableBuilder(
                    valueListenable: playlistSongsFromDB,
                    builder: (context, value, child) {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: ListView.builder(
                          controller: ScrollController(),
                          itemBuilder: ((context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: kColorListTile,
                              child: ListTile(
                                onTap: () async {
                                  await createAudiosFileList(
                                      playlistSongsFromDB.value);
                                  await audioPlayer.playlistPlayAtIndex(index);
                                  if (!mounted) return;
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return const ScreenPlay();
                                    }),
                                  );
                                  miniPlayerVisibility.value = true;
                                  favouritesAudioListUpdate = false;
                                  playlistAudioListUpdate = true;
                                },
                                leading: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage('assets/images/songicon.png'),
                                ),
                                title: Text(
                                  playlistSongsFromDB.value[index].title
                                      .toString(),
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                subtitle: Text(
                                  playlistSongsFromDB.value[index].artist
                                      .toString(),
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                                trailing: IconButton(
                                  icon: functionIcon(
                                      Icons.more_vert, 25, Colors.white),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      backgroundColor: kAppbarColor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30),
                                        ),
                                      ),
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: 300,
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 8, right: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    functionText(
                                                        "",
                                                        Colors.white,
                                                        FontWeight.bold,
                                                        18),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: functionText(
                                                            "Close",
                                                            Colors.white,
                                                            FontWeight.bold,
                                                            18))
                                                  ],
                                                ),
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    playlistSongDelete(
                                                        playlistSongsFromDB
                                                            .value[index].id
                                                            .toString(),
                                                        playlistname);

                                                    snackBar(
                                                        "Removed From $playlistname",
                                                        kBackgroundColor2,
                                                        context);
                                                    Navigator.pop(context);
                                                  },
                                                  child: functionText(
                                                      "Remove From $playlistname",
                                                      Colors.white,
                                                      FontWeight.bold,
                                                      20)),
                                              TextButton(
                                                  onPressed: () {
                                                    tempFavouriteList.contains(
                                                            playlistSongsFromDB
                                                                .value[index].id
                                                                .toString())
                                                        ? favouritesController
                                                            .favouritesRemove(
                                                                playlistSongsFromDB
                                                                    .value[
                                                                        index]
                                                                    .id
                                                                    .toString())
                                                        : favouritesController
                                                            .addFavouritesToDB(
                                                                playlistSongsFromDB
                                                                    .value[
                                                                        index]
                                                                    .id
                                                                    .toString());
                                                    Navigator.pop(context);
                                                    tempFavouriteList.contains(
                                                            playlistSongsFromDB
                                                                .value[index].id
                                                                .toString())
                                                        ? snackBar(
                                                            "Added to favourites",
                                                            kBackgroundColor2,
                                                            context)
                                                        : snackBar(
                                                            "Removed Succesfully",
                                                            kBackgroundColor2,
                                                            context);
                                                  },
                                                  child: tempFavouriteList
                                                          .contains(
                                                              playlistSongsFromDB
                                                                  .value[index]
                                                                  .id
                                                                  .toString())
                                                      ? functionText(
                                                          "Remove From Favourites",
                                                          Colors.white,
                                                          FontWeight.bold,
                                                          20)
                                                      : functionText(
                                                          "Add to Favourites",
                                                          Colors.white,
                                                          FontWeight.bold,
                                                          20))
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
                          itemCount: playlistSongsFromDB.value.length,
                          shrinkWrap: true,
                        ),
                      );
                    }),
            bottomNavigationBar: miniPlayer(context),
          );
        });
  }
}

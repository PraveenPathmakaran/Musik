import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../db/db_functions.dart';
import '../../functions/design_widgets.dart';
import 'playlist_functions.dart';
import 'playlist_widgets.dart';
import 'screen_playlist_songs.dart';

ScrollController controller1 = ScrollController();

class ScreenPlaylist extends StatelessWidget {
  const ScreenPlaylist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    keyUpdate();

    return ValueListenableBuilder(
      valueListenable: allkey,
      builder: (context, value, child) {
        return allkey.value.isEmpty
            ? Container(
                color: Colors.black,
                child: Center(
                  child: functionText(
                      "Create New Playlist", Colors.white, FontWeight.bold, 20),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: allkey.value.length,
                  itemBuilder: ((context, index) {
                    return SizedBox(
                      height: 80,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: kColorListTile,
                        child: Center(
                          child: ListTile(
                            onTap: (() {
                              getPlaylistSongs(allkey.value[index].toString());
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: ((context) {
                                    return ScreenPlaylistAudios(
                                      playlistname:
                                          allkey.value[index].toString(),
                                    );
                                  }),
                                ),
                              );
                            }),
                            leading: const Icon(
                              Icons.playlist_play,
                              color: Colors.white,
                              size: 35,
                            ),
                            title: functionText(allkey.value[index].toString(),
                                Colors.white, FontWeight.normal, 20),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                findPlaylistCount(
                                    allkey.value[index].toString()),
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
                                                  playlistDelete(allkey
                                                      .value[index]
                                                      .toString());
                                                  snackBar(
                                                      "Deleted Successfully",
                                                      kBackgroundColor2,
                                                      context);
                                                  Navigator.pop(context);
                                                },
                                                child: functionText(
                                                    "Delete Playlist",
                                                    Colors.white,
                                                    FontWeight.bold,
                                                    20),
                                              ),
                                              TextButton(
                                                  onPressed: () async {
                                                    await updatePlaylistName(
                                                        context,
                                                        allkey.value[index]
                                                            .toString());
                                                  },
                                                  child: functionText(
                                                      "Edit Playlist",
                                                      Colors.white,
                                                      FontWeight.bold,
                                                      20)),
                                            ],
                                          ),
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
                  }),
                ),
              );
      },
    );
  }
}

class ScreenAddToPlaylistFromHome extends StatelessWidget {
  final String id;

  const ScreenAddToPlaylistFromHome({Key? key, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    keyUpdate();
    return ValueListenableBuilder(
      valueListenable: allkey,
      builder: (context, value, child) {
        return ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                TextButton.icon(
                    onPressed: () {
                      openDialog(context);
                    },
                    icon: const Icon(
                      Icons.playlist_add_circle_sharp,
                      color: Colors.white,
                    ),
                    label: functionText(
                        "Playlist Create", Colors.white, FontWeight.bold, 20)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'))
              ],
            ),
            ListView.builder(
              controller: controller1,
              shrinkWrap: true,
              itemCount: allkey.value.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  onTap: (() {
                    getPlaylistSongs(allkey.value[index].toString());
                    if (tempPlaylistId.contains(id)) {
                      Navigator.pop(context);
                      return snackBar(
                          "Song exist in ${allkey.value[index].toString()}",
                          Colors.red,
                          context);
                    }
                    addtoPlaylistSongs(id, allkey.value[index].toString());
                    Navigator.pop(context);
                    snackBar("Added to ${allkey.value[index].toString()}",
                        kBackgroundColor2, context);
                  }),
                  leading: const Icon(
                    Icons.playlist_play,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: functionText(allkey.value[index].toString(),
                      Colors.white, FontWeight.normal, 20),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

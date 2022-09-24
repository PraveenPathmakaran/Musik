import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../functions/audio_functions.dart';
import '../../functions/design_widgets.dart';
import '../favourite_screen/screen_favourite.dart';
import '../home_screen/home_widgets.dart';
import '../play_screen/screen_play.dart';
import '../playlist_screen/screen_playlist_songs.dart';
import '../splash_screen/screen_splash.dart';

class MusicSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggetionList = allAudioListFromDB
        .where((element) =>
            element.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: suggetionList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: kColorListTile,
            child: ListTile(
              leading: const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/images/musicIcon1.png'),
              ),
              title: Text(
                suggetionList[index].title.toString(),
                maxLines: 1,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              subtitle: Text(
                suggetionList[index].artist.toString(),
                maxLines: 1,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              trailing: IconButton(
                icon: functionIcon(Icons.more_horiz, 20, Colors.white),
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: kBackgroundColor2,
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      builder: (ctx) {
                        return HomeBottomSheet(
                          id: suggetionList[index].id.toString(),
                        );
                      });
                  favouritesAudioListUpdate = false;
                  playlistAudioListUpdate = false;
                },
              ),
              onTap: () async {
                await createAudiosFileList(suggetionList);
                audioPlayer.playlistPlayAtIndex(index);
                miniPlayerVisibility.value = true;
                favouritesAudioListUpdate = false;
                playlistAudioListUpdate = false;

                // ignore: use_build_context_synchronously
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ScreenPlay();
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggetionList = allAudioListFromDB
        .where((element) =>
            element.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return suggetionList.isEmpty
        ? Container(
            color: Colors.black,
            child: const Center(
              child: Text(
                'No Results Found',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        : Container(
            color: Colors.black,
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: suggetionList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: kColorListTile,
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage('assets/images/musicIcon1.png'),
                    ),
                    title: Text(
                      suggetionList[index].title.toString(),
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    subtitle: Text(
                      suggetionList[index].artist.toString(),
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    trailing: IconButton(
                      icon: functionIcon(Icons.more_horiz, 20, Colors.white),
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: kBackgroundColor2,
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            builder: (ctx) {
                              return HomeBottomSheet(
                                id: suggetionList[index].id.toString(),
                              );
                            });
                      },
                    ),
                    onTap: () async {
                      await createAudiosFileList(suggetionList);
                      audioPlayer.playlistPlayAtIndex(index);
                      miniPlayerVisibility.value = true;
                      favouritesAudioListUpdate = false;
                      playlistAudioListUpdate = false;

                      // ignore: use_build_context_synchronously
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const ScreenPlay();
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: kAppbarColor),
      textTheme: const TextTheme(headline6: TextStyle(color: Colors.white)),
      hintColor: Colors.white,
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
      ),
    );
  }
}

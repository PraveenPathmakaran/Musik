import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../functions/audio_functions.dart';
import '../../functions/design_widgets.dart';
import '../favourite_screen/favourites_functions.dart';
import '../favourite_screen/screen_favourite.dart';
import '../play_screen/screen_play.dart';
import '../playlist_screen/screen_playlist.dart';
import '../playlist_screen/screen_playlist_songs.dart';
import '../splash_screen/screen_splash.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return allAudioListFromDB.isEmpty
        ? Container(
            color: Colors.black,
            child: Center(
              child: functionText(
                  "No Songs Found", Colors.white, FontWeight.bold, 20),
            ),
          )
        : Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            color: Colors.black,
            child: SingleChildScrollView(
              child: Column(children: [
                ListView.builder(
                  controller: ScrollController(),
                  itemBuilder: ((context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: const EdgeInsets.all(3),
                      color: const Color(0xFF14202E),
                      child: ListTile(
                          onTap: () async {
                            await createAudiosFileList(allAudioListFromDB);
                            await audioPlayer.playlistPlayAtIndex(index);
                            if (!mounted) return;
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ScreenPlay();
                                },
                              ),
                            );
                            miniPlayerVisibility.value = true;
                            favouritesAudioListUpdate = false;
                            playlistAudioListUpdate = false;
                          },
                          leading: const CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('assets/images/musicIcon1.png'),
                          ),
                          title: Text(
                            allAudioListFromDB[index].title.toString(),
                            maxLines: 1,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                          subtitle: Text(
                            allAudioListFromDB[index].artist.toString(),
                            maxLines: 1,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                          trailing: IconButton(
                            icon:
                                functionIcon(Icons.more_vert, 20, Colors.white),
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: appbarColor,
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30),
                                    ),
                                  ),
                                  builder: (ctx) {
                                    return SizedBox(
                                      height: 300,
                                      child: HomeBottomSheet(
                                        id: allAudioListFromDB[index]
                                            .id
                                            .toString(),
                                      ),
                                    );
                                  });
                            },
                          )),
                    );
                  }),
                  itemCount: allAudioListFromDB.length,
                  shrinkWrap: true,
                ),
              ]),
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}

class DrawerContent extends StatelessWidget {
  const DrawerContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  functionText(appName, whiteColor, FontWeight.bold, 35),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  functionText('Music Player', whiteColor, FontWeight.bold, 25),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      functionTextButton(() {}, 'Notifications'),
                      ValueListenableBuilder(
                          valueListenable: notification,
                          builder: (context, value, child) {
                            return Switch(
                              activeTrackColor: roseColor,
                              activeColor: whiteColor,
                              inactiveTrackColor: Colors.white,
                              value: notification.value,
                              onChanged: ((value) {
                                notification.value = value;
                                audioPlayer.showNotification = value;
                              }),
                            );
                          })
                    ],
                  ),
                  functionTextButton(() {}, 'Share'),
                  functionTextButton(() {}, 'Privacy Policy'),
                  functionTextButton(() {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(12),
                            title: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              minVerticalPadding: 0,
                              leading: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    AssetImage('assets/images/musicIcon1.png'),
                              ),
                              title: functionText("Play\nMusic Player",
                                  Colors.black, FontWeight.bold, 20),
                              subtitle: const Text(
                                  "It is a Ad free Music player Play all local storage musics"),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  showLicensePage(
                                      context: context,
                                      applicationName: "Musik",
                                      applicationIcon: Image.asset(
                                        "assets/images/appIcon.png",
                                        width: 50,
                                        height: 50,
                                      ));
                                },
                                child: const Text("View License"),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Close"))
                            ],
                          );
                        });
                  }, 'About'),
                  functionTextButton(() {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Really"),
                          content: const Text("Do you want to close the app?"),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text("No")),
                            TextButton(
                                onPressed: () {
                                  SystemNavigator.pop();
                                },
                                child: const Text("Yes"))
                          ],
                        );
                      },
                    );
                  }, 'Exit'),
                ],
              ),
              Column(
                children: [
                  functionText("Version", Colors.white, FontWeight.bold, 15),
                  functionText("1.0.0", Colors.white, FontWeight.bold, 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeBottomSheet extends StatelessWidget {
  final String id;
  final int? index;
  const HomeBottomSheet({Key? key, required this.id, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context, {bool value = true}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              functionText("", Colors.white, FontWeight.bold, 18),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                      functionText("Close", Colors.white, FontWeight.bold, 18))
            ],
          ),
        ),
        TextButton(
            onPressed: () async {
              // if (tempFavouriteList.contains(id)) {
              //   if (tabController.index == 1 &&
              //       audioPlayer.playlist!.audios.isNotEmpty &&
              //       favouritesAudioListUpdate) {
              //     audioPlayer.playlist!.audios
              //         .removeWhere((element) => element.metas.id == id);
              //   }
              //   await favouritesRemove(id);
              // } else {
              //   await addFavouritesToDB(id);
              // }
              tempFavouriteList.contains(id)
                  ? favouritesRemove(id)
                  : addFavouritesToDB(id);
              if (!value) {}
              Navigator.pop(context);
              tempFavouriteList.contains(id)
                  ? snackBar("Added to favourites", backgroundColor2, context)
                  : snackBar("Removed Succesfully", backgroundColor2, context);
            },
            child: ValueListenableBuilder(
              valueListenable: favouritesListFromDb,
              builder: (context, value, child) {
                return tempFavouriteList.contains(id)
                    ? functionText("Remove From Favourites", Colors.white,
                        FontWeight.bold, 20)
                    : functionText(
                        "Add to Favourites", Colors.white, FontWeight.bold, 20);
              },
            )),
        TextButton(
          child: functionText(
              "Add to Playlist ", Colors.white, FontWeight.bold, 20),
          onPressed: () {
            Navigator.pop(context);
            showModalBottomSheet(
                backgroundColor: appbarColor,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                builder: (context) {
                  return ScreenAddToPlaylistFromHome(
                    id: id,
                  );
                });
          },
        ),
      ],
    );
  }
}

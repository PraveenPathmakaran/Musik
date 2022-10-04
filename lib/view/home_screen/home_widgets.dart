import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/audio_functions.dart';
import '../../controller/home_screen/home_screen_controller.dart';
import '../../controller/playlist_Screen/screen_playlist_controller.dart';
import '../../controller/splash_screen/screen_splash.dart';
import '../../core/colors.dart';
import '../favourite_screen/screen_favourite.dart';
import '../play_screen/screen_play.dart';
import '../widgets.dart';
import 'screen_home_bottomsheet.dart';

class ScreenHome extends StatelessWidget {
  ScreenHome({super.key});

  final HomeScreenController _homeScreenController =
      Get.put(HomeScreenController());

  final PlaylistController _playlistController = Get.put(PlaylistController());

  @override
  Widget build(BuildContext context) {
    return allAudioListFromDB.isEmpty
        ? Container(
            color: Colors.black,
            child: Center(
              child: functionText(
                  'No Songs Found', Colors.white, FontWeight.bold, 20),
            ),
          )
        : Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            color: Colors.black,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
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
                        await Get.to(const ScreenPlay());

                        _homeScreenController.miniPlayerVisibility.value = true;
                        favouritesAudioListUpdate = false;
                        _playlistController.playlistAudioListUpdate = false;
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      subtitle: Text(
                        allAudioListFromDB[index].artist.toString(),
                        maxLines: 1,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      trailing: IconButton(
                        icon: functionIcon(Icons.more_vert, 20, Colors.white),
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: kAppbarColor,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30),
                                ),
                              ),
                              builder: (BuildContext ctx) {
                                return SizedBox(
                                  height: 300,
                                  child: HomeBottomSheet(
                                    id: allAudioListFromDB[index].id.toString(),
                                  ),
                                );
                              });
                        },
                      )),
                );
              },
              itemCount: allAudioListFromDB.length,
              shrinkWrap: true,
            ),
          );
  }
}

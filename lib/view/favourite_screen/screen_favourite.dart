import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/audio_functions.dart';
import '../../controller/home_screen/home_screen_controller.dart';
import '../../controller/playlist_Screen/screen_playlist_controller.dart';
import '../../controller/splash_screen/screen_splash.dart';
import '../../core/colors.dart';
import '../home_screen/screen_home_bottomsheet.dart';
import '../play_screen/screen_play.dart';
import '../widgets.dart';

bool favouritesAudioListUpdate = false; //favourite list remove option

class ScreenFavourite extends StatelessWidget {
  ScreenFavourite({super.key});
  final HomeScreenController _homeScreenController =
      Get.put(HomeScreenController());
  final PlaylistController _playlistController = Get.put(PlaylistController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return favouritesListFromDb.isEmpty
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
                controller: ScrollController(),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: kColorListTile,
                    child: ListTile(
                      onTap: () async {
                        await createAudiosFileList(favouritesListFromDb);
                        await audioPlayer.playlistPlayAtIndex(index);
                        await Get.to(const ScreenPlay());
                        _homeScreenController.miniPlayerVisibility.value = true;
                        favouritesAudioListUpdate = true;
                        _playlistController.playlistAudioListUpdate = false;
                      },
                      leading: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            AssetImage('assets/images/songicon.png'),
                      ),
                      title: Text(
                        favouritesListFromDb[index].title.toString(),
                        maxLines: 1,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      subtitle: Text(
                        favouritesListFromDb[index].artist.toString(),
                        maxLines: 1,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      trailing: IconButton(
                        icon: functionIcon(Icons.more_vert, 20, Colors.white),
                        onPressed: () async {
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
                                    id: favouritesListFromDb[index]
                                        .id
                                        .toString(),
                                    index: index,
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  );
                },
                itemCount: favouritesListFromDb.length,
                shrinkWrap: true,
              ),
            );
    });
  }
}

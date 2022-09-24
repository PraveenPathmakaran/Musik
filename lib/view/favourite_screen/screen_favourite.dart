import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors.dart';
import '../../functions/audio_functions.dart';
import '../../functions/design_widgets.dart';
import '../home_screen/home_widgets.dart';
import '../play_screen/screen_play.dart';
import '../playlist_screen/screen_playlist_songs.dart';
import '../splash_screen/screen_splash.dart';

bool favouritesAudioListUpdate = false; //favourite list remove option

class ScreenFavourite extends StatelessWidget {
  const ScreenFavourite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return favouritesListFromDb.isEmpty
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
                        await createAudiosFileList(favouritesListFromDb);
                        await audioPlayer.playlistPlayAtIndex(index);
                        await Get.to(const ScreenPlay());
                        miniPlayerVisibility.value = true;
                        favouritesAudioListUpdate = true;
                        playlistAudioListUpdate = false;
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
                              builder: (ctx) {
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
                }),
                itemCount: favouritesListFromDb.length,
                shrinkWrap: true,
              ),
            );
    });
  }
}

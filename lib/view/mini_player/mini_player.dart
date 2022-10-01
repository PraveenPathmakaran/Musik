import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_screen/home_screen_controller.dart';
import '../../controller/splash_screen/screen_splash.dart';
import '../../core/colors.dart';
import '../play_screen/screen_play.dart';
import '../widgets.dart';

class MiniPlayer extends StatelessWidget {
  MiniPlayer({super.key});
  final HomeScreenController _homeScreenController =
      Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Visibility(
        visible: _homeScreenController.miniPlayerVisibility.value,
        child: audioPlayer.builderRealtimePlayingInfos(builder:
            (BuildContext context, RealtimePlayingInfos realtimePlayingInfos) {
          return Card(
            color: kAppbarColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: ListTile(
              tileColor: Colors.transparent,
              onTap: () => Get.to(
                const ScreenPlay(),
              ),
              leading: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/images/musicIcon1.png'),
              ),
              title: Text(
                realtimePlayingInfos.current!.audio.audio.metas.title
                    .toString(),
                maxLines: 1,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                realtimePlayingInfos.current!.audio.audio.metas.title
                    .toString(),
                maxLines: 1,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                  onPressed: () async {
                    if (songSkip) {
                      songSkip = false;
                      await audioPlayer.previous();
                      songSkip = true;
                    }
                  },
                  icon: functionIcon(Icons.skip_previous, 40, Colors.white),
                ),
                IconButton(
                    onPressed: () {
                      audioPlayer.playOrPause();
                    },
                    icon: realtimePlayingInfos.isPlaying
                        ? functionIcon(Icons.pause, 40, Colors.white)
                        : functionIcon(
                            Icons.play_arrow_rounded, 40, Colors.white)),
                IconButton(
                  onPressed: () async {
                    if (songSkip) {
                      songSkip = false;
                      await audioPlayer.next();
                      songSkip = true;
                    }
                  },
                  icon: functionIcon(Icons.skip_next, 40, Colors.white),
                ),
              ]),
            ),
          );
        }),
      );
    });
  }
}

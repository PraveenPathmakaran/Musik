import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../../functions/design_widgets.dart';
import '../favourite_screen/favourites_functions.dart';
import '../playlist_screen/screen_playlist.dart';
import '../splash_screen/screen_splash.dart';

RealtimePlayingInfos? realtimePlayingInfos1;

ValueNotifier<bool> loopButton = ValueNotifier(true);

class ScreenPlay extends StatelessWidget {
  const ScreenPlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Now Playing'),
        centerTitle: true,
      ),
      body: audioPlayer.builderRealtimePlayingInfos(
          builder: (contex, realtimePlayingInfos) {
        realtimePlayingInfos1 = realtimePlayingInfos;
        // ignore: prefer_const_constructors
        return PlayContainer();
      }),
    );
  }
}

class PlayContainer extends StatelessWidget {
  const PlayContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
          ),
          const CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage('assets/images/songsImage.png'),
            radius: 130,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 7),
            child: functionText(
                realtimePlayingInfos1!.current!.audio.audio.metas.title
                    .toString(),
                Colors.white,
                FontWeight.w600,
                16),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  if (tempFavouriteList.contains(
                      realtimePlayingInfos1!.current!.audio.audio.metas.id)) {
                    favouritesRemove(realtimePlayingInfos1!
                        .current!.audio.audio.metas.id
                        .toString());
                  } else {
                    addFavouritesToDB(realtimePlayingInfos1!
                        .current!.audio.audio.metas.id
                        .toString());
                  }
                },
                icon: ValueListenableBuilder(
                  valueListenable: favouritesListFromDb,
                  builder: (context, value, child) {
                    return tempFavouriteList.contains(realtimePlayingInfos1!
                            .current!.audio.audio.metas.id)
                        ? functionIcon(Icons.favorite, 30, roseColor)
                        : functionIcon(Icons.favorite, 30, Colors.white);
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (loopButton.value) {
                      audioPlayer.setLoopMode(LoopMode.single);
                      loopButton.value = false;
                    } else {
                      audioPlayer.setLoopMode(LoopMode.none);
                      loopButton.value = true;
                    }
                  },
                  icon: ValueListenableBuilder(
                    valueListenable: loopButton,
                    builder: (context, value, child) {
                      return loopButton.value
                          ? functionIcon(Icons.repeat, 35, whiteColor)
                          : functionIcon(Icons.repeat_one, 35, whiteColor);
                    },
                  )),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: backgroundColor2,
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        builder: (context) {
                          return ScreenAddToPlaylistFromHome(
                            id: realtimePlayingInfos1!
                                .current!.audio.audio.metas.id
                                .toString(),
                          );
                        });
                  },
                  icon: functionIcon(Icons.playlist_play, 35, whiteColor))
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          slider(realtimePlayingInfos1!),
          Container(
            transform: Matrix4.translationValues(0, -5, 0),
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 15),
            child: timeStamps(realtimePlayingInfos1!),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  if (songSkip) {
                    songSkip = false;
                    await audioPlayer.previous();
                    songSkip = true;
                  }
                },
                child: functionIcon(Icons.skip_previous, 55, Colors.white),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  audioPlayer.playOrPause();
                },
                child: realtimePlayingInfos1!.isPlaying
                    ? functionIcon(Icons.pause, 55, Colors.white)
                    : functionIcon(Icons.play_arrow_rounded, 55, Colors.white),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  if (songSkip) {
                    songSkip = false;
                    await audioPlayer.next();
                    songSkip = true;
                  }
                },
                child: functionIcon(Icons.skip_next, 55, Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}

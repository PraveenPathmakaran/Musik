import 'dart:collection';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:permission_handler/permission_handler.dart';
import '../../db/db_functions.dart';
import '../../functions/audio_functions.dart';
import '../../functions/design_widgets.dart';
import '../../model/music_model.dart';
import '../favourite_screen/favourites_functions.dart';
import '../home_screen/screen_home.dart';

final audioPlayer = AssetsAudioPlayer.withId("0");
List<MusicModel> allAudioListFromDB = [];
List<Map<dynamic, dynamic>> allSongs = []; //converting method cahnnel audios
List<MusicModel> allMusicModelSongs = []; //map converted to music model
List<String> tempFavouriteList = []; //favourite audi songs id list
List<Audio> audioSongsList = []; //converted audio list audiomodel

ValueNotifier<List<MusicModel>> favouritesListFromDb =
    ValueNotifier([]); //for add and remove

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  static const audioChannel = MethodChannel("audio");
  @override
  void initState() {
    gotoHome(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              functionText(
                appName,
                whiteColor,
                FontWeight.bold,
                48,
              ),
              functionText(
                'Music Player',
                whiteColor,
                FontWeight.bold,
                24,
              ),
            ],
          ),
        ),
      ),
    );
  }

//Storage permission
  Future<void> gotoHome(BuildContext context, {bool mounted = true}) async {
    try {
      if (await Permission.storage.request().isGranted) {
        await getAllAudios();
        if (!mounted) return;
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) {
            return const ScreenHomeMain();
          }),
        );
      } else {
        await Permission.storage.request();
        if (await Permission.storage.request().isGranted) {
          await getAllAudios();
          if (!mounted) return;
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) {
              return const ScreenHomeMain();
            }),
          );
        } else {}
      }
    } catch (e) {
      return;
    }
  }

  Future getAllAudios() async {
    final value = await audioChannel.invokeMethod<List<Object?>>("getAudios");
    //method channel songs convert to flutter map
    for (int i = 0; i < value!.length; i++) {
      final value2 = HashMap.from(value[i] as Map<dynamic, dynamic>);
      allSongs.add(value2);
    }
    //converting music model
    for (int i = 0; i < allSongs.length; i++) {
      final value = MusicModel.fromJson(allSongs[i]);

      allMusicModelSongs.add(value);
    }

    await addAudiosToDB();
    await createAudiosFileList(allAudioListFromDB);
    await getAllFavouritesFromDB();
  }
}

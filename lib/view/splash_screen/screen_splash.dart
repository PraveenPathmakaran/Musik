import 'dart:collection';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:permission_handler/permission_handler.dart';
import '../../core/colors.dart';
import '../../db/db_functions.dart';
import '../../functions/audio_functions.dart';
import '../../functions/design_widgets.dart';
import '../../model/music_model.dart';
import '../favourite_screen/favourites_functions.dart';
import '../home_screen/screen_home.dart';
import 'package:get/get.dart';

final audioPlayer = AssetsAudioPlayer.withId("0");
List<MusicModel> allAudioListFromDB = [];
List<MusicModel> allMusicModelSongs = []; //map converted to music model
List<String> tempFavouriteList = []; //favourite audi songs id list
List<Audio> audioSongsList = []; //converted audio list audiomodel

ValueNotifier<List<MusicModel>> favouritesListFromDb =
    ValueNotifier([]); //for add and remove

// final favouritesListFromDb = [].obs;

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  static const audioChannel = MethodChannel("audio");
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await gotoHome(context);
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              functionText(
                appName,
                kWhiteColor,
                FontWeight.bold,
                48,
              ),
              functionText(
                'Music Player',
                kWhiteColor,
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
  Future<void> gotoHome(BuildContext context) async {
    try {
      if (await Permission.storage.request().isGranted) {
        await getAllAudios();
        await Get.off(const ScreenHomeMain());
      } else {
        await Permission.storage.request();
        if (await Permission.storage.request().isGranted) {
          await getAllAudios();

          await Get.off(const ScreenHomeMain());
        } else {}
      }
    } catch (e) {
      return;
    }
  }

  Future getAllAudios() async {
    final audios = await audioChannel.invokeMethod<List<Object?>>("getAudios");
    for (int i = 0; i < audios!.length; i++) {
      final musicModelaudio =
          MusicModel.fromJson(HashMap.from(audios[i] as Map<dynamic, dynamic>));
      allMusicModelSongs.add(musicModelaudio);
    }

    await addAudiosToDB();
    await createAudiosFileList(allAudioListFromDB);
    await getAllFavouritesFromDB();
  }
}

import 'dart:collection';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import '../../model/music_model.dart';
import '../../view/home_screen/screen_home.dart';
import '../audio_functions.dart';
import '../favorite_screen/screen_favourites_controller.dart';

final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
final RxList<MusicModel> favouritesListFromDb = <MusicModel>[].obs;
List<Audio> audioSongsList = <Audio>[]; //converted audio list audiomodel
List<String> tempFavouriteList = <String>[]; //favourite audio songs id list
List<MusicModel> allMusicModelSongs =
    <MusicModel>[]; //map converted to music model
List<MusicModel> allAudioListFromDB = <MusicModel>[];

class ScreenSplashController extends GetxController {
  static const MethodChannel audioChannel = MethodChannel('audio');

  final FavouritesController favouritesController =
      Get.put(FavouritesController());
  Future<void> gotoHome(BuildContext context) async {
    try {
      if (await Permission.storage.request().isGranted) {
        await getAllAudios();
        await Get.off(ScreenHomeMain());
      } else {
        await Permission.storage.request();
        if (await Permission.storage.request().isGranted) {
          await getAllAudios();

          await Get.off(ScreenHomeMain());
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<dynamic> getAllAudios() async {
    final List<Object?>? audios =
        await audioChannel.invokeMethod<List<Object?>>('getAudios');
    for (int i = 0; i < audios!.length; i++) {
      final MusicModel musicModelaudio =
          // ignore: cast_nullable_to_non_nullable, always_specify_types
          MusicModel.fromJson(HashMap.from(audios[i] as Map<dynamic, dynamic>));
      allMusicModelSongs.add(musicModelaudio);
    }

    await addAudiosToDB();
    await createAudiosFileList(allAudioListFromDB);
    await favouritesController.getAllFavouritesFromDB();
  }

  Future<void> addAudiosToDB() async {
    await musicDB.put('all_songs', allMusicModelSongs);
    await getAllAudiosFromDB();
  }

  Future<void> getAllAudiosFromDB() async {
    allAudioListFromDB.clear();
    if (musicDB.isEmpty) {
      return;
    }
    allAudioListFromDB = musicDB.get('all_songs')!;
    allAudioListFromDB.sort(
      (MusicModel a, MusicModel b) => a.title!.compareTo(b.title!),
    );
  }
}

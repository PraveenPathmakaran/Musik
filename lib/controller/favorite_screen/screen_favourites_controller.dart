import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../model/music_model.dart';
import '../splash_screen/screen_splash.dart';

class FavouritesController extends GetxController {
  Future<void> addFavouritesToDB(String id) async {
    if (tempFavouriteList.contains(id)) {
      return;
    } else {
      tempFavouriteList.add(id);
      await favouriteDB.put('favourite', tempFavouriteList);
      getAllFavouritesFromDB();
    }
  }

  Future<void> getAllFavouritesFromDB() async {
    if (favouriteDB.isEmpty) {
      return;
    }
    tempFavouriteList = favouriteDB.get('favourite')!;
    await getFavouritesAudios(tempFavouriteList);
  }

  Future<void> getFavouritesAudios(List<String> favouritesList) async {
    favouritesListFromDb.value = allAudioListFromDB.where((MusicModel element) {
      return favouritesList.contains(element.id);
    }).toList();
    favouritesListFromDb.sort(
      (MusicModel a, MusicModel b) => a.title!.compareTo(b.title!),
    );
  }

  Future<void> favouritesRemove(String id) async {
    tempFavouriteList.remove(id);
    await favouriteDB.put('favourite', tempFavouriteList);
    await getFavouritesAudios(tempFavouriteList);
    await getAllFavouritesFromDB();

    try {
      if (audioPlayer.playlist != null && audioPlayer.isPlaying.value) {
        final Audio? audio = audioSongsList
            .firstWhereOrNull((Audio element) => element.metas.id == id);

        if (audio != null && audioPlayer.playlist!.contains(audio)) {
          audioPlayer.playlist!.remove(audio);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

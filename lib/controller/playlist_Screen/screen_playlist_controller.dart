import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../model/music_model.dart';
import '../splash_screen/screen_splash.dart';

class PlaylistController extends GetxController {
  final RxList<dynamic> allkey = <dynamic>[].obs;
  List<String> tempPlaylistId = <String>[];
  final RxList<MusicModel> playlistSongsFromDB = <MusicModel>[].obs;
  bool playlistAudioListUpdate = false; //favourite list remove option

  Future<void> keyUpdate() async {
    allkey.clear();
    final List<dynamic> allkey1 = playlistDB.keys.toList();
    allkey.value = allkey1;
  }

  Future<void> playlistCreation(String key) async {
    final bool keys = playlistDB.containsKey(key);
    if (keys) {
      return;
    }
    final List<String> emptyList = <String>[];
    await playlistDB.put(key, emptyList);
    keyUpdate();
  }

  Future<void> playlistDelete(String playlistname) async {
    playlistDB.delete(playlistname);
    keyUpdate();
  }

  Future<void> addtoPlaylistSongs(String id, String playlistname) async {
    if (tempPlaylistId.contains(id)) {
      return;
    }
    tempPlaylistId.add(id);
    await playlistDB.put(playlistname, tempPlaylistId);
    getPlaylistSongs(playlistname);
  }

  Future<void> getPlaylistSongs(String playlistname) async {
    tempPlaylistId = playlistDB.get(playlistname)!;

    playlistSongsFromDB.value = allAudioListFromDB.where((MusicModel element) {
      return tempPlaylistId.contains(element.id);
    }).toList();
    playlistSongsFromDB.sort(
      (MusicModel a, MusicModel b) => a.title!.compareTo(b.title!),
    );
  }

  Future<void> playlistSongDelete(String id, String playlistname) async {
    tempPlaylistId.remove(id);

    playlistDB.put(playlistname, tempPlaylistId);
    await getPlaylistSongs(playlistname);
    await keyUpdate();
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

  Future<void> playlistNameUpdate(
      String playlistname, String newplaylistname) async {
    if (newplaylistname == '') {
      return;
    }
    List<String>? tempList = playlistDB.get(playlistname);
    tempList ??= <String>[];
    await playlistDB.put(newplaylistname, tempList);
    await playlistDelete(playlistname);
    await keyUpdate();
  }

  Widget findPlaylistCount(String playlistname) {
    final List<String>? value = playlistDB.get(playlistname);
    if (value == null) {
      return const SizedBox();
    }

    return value.isEmpty
        ? const SizedBox()
        : Center(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                color: Colors.black,
              ),
              padding: const EdgeInsets.all(7),
              width: 30,
              height: 30,
              child: Text(
                value.length.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}

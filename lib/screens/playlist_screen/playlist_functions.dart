import 'package:flutter/material.dart';
import '../../db/db_functions.dart';
import '../../main.dart';
import '../splash_screen/screen_splash.dart';
import 'screen_playlist_songs.dart';

Future<void> keyUpdate() async {
  allkey.value.clear();
  final allkey1 = playlistDB.keys.toList();
  allkey.value = allkey1;
  //allkey.notifyListeners();
}

Future<void> playlistCreation(String key) async {
  bool keys = playlistDB.containsKey(key);
  if (keys) {
    return;
  }
  List<String> emptyList = [];
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

  playlistSongsFromDB.value = allAudioListFromDB.where((element) {
    return tempPlaylistId.contains(element.id);
  }).toList();
  playlistSongsFromDB.value.sort(
    (a, b) => a.title!.compareTo(b.title!),
  );
  // playlistSongsFromDB.notifyListeners();
}

Future<void> playlistSongDelete(String id, String playlistname) async {
  tempPlaylistId.remove(id);
  playlistDB.put(playlistname, tempPlaylistId);
  await getPlaylistSongs(playlistname);
  //playlistSongsFromDB.notifyListeners();
  await keyUpdate();
}

Future<void> playlistNameUpdate(
    String playlistname, String newplaylistname) async {
  if (newplaylistname == "") {
    return;
  }
  List<String>? tempList = playlistDB.get(playlistname);
  tempList ??= [];
  await playlistDB.put(newplaylistname, tempList);
  await playlistDelete(playlistname);
  await keyUpdate();
}

Widget findPlaylistCount(String playlistname) {
  final value = playlistDB.get(playlistname);
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

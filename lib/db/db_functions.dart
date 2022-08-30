import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/splash_screen/screen_splash.dart';

ValueNotifier<List<dynamic>> allkey = ValueNotifier([]);
Future<void> addAudiosToDB() async {
  await musicDB.put("all_songs", allMusicModelSongs);
  await getAllAudiosFromDB();
}

Future<void> getAllAudiosFromDB() async {
  allAudioListFromDB.clear();
  if (musicDB.isEmpty) {
    return;
  }
  allAudioListFromDB = musicDB.get('all_songs')!;
  allAudioListFromDB.sort(
    (a, b) => a.title!.compareTo(b.title!),
  );
}

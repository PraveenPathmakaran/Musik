import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newmusicplayer/screens/splash_screen/screen_splash.dart';
import 'model/music_model.dart';

late Box<List<MusicModel>> musicDB;
late Box<List<String>> favouriteDB;
late Box<List<String>> playlistDB;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusicModelAdapter().typeId)) {
    Hive.registerAdapter(MusicModelAdapter());
  }

  musicDB = await Hive.openBox('music_db');
  favouriteDB = await Hive.openBox('favourite_box');
  playlistDB = await Hive.openBox('playlist_box');

  runApp(const MusicApp());
}

class MusicApp extends StatefulWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      home: const ScreenSplash(),
    );
  }
}

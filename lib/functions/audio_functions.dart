//list of asset audio songs
import 'package:assets_audio_player/assets_audio_player.dart';
import '../model/music_model.dart';
import '../screens/play_screen/screen_play.dart';
import '../screens/splash_screen/screen_splash.dart';
import 'design_widgets.dart';

Future<void> createAudiosFileList(List<MusicModel> audioConvertList) async {
  audioSongsList.clear();
  for (int i = 0; i < audioConvertList.length; i++) {
    audioSongsList.add(
      Audio.file(
        audioConvertList[i].path.toString(),
        metas: Metas(
          id: audioConvertList[i].id.toString(),
          title: audioConvertList[i].title.toString(),
          artist: audioConvertList[i].artist.toString(),
          image: const MetasImage.asset('assets/music.png'),
        ),
      ),
    );
  }
  await setupPlaylist();
  loopButton.value = true;
}

//playlist setup
Future<void> setupPlaylist() async {
  await audioPlayer.open(Playlist(audios: audioSongsList),
      autoStart: false,
      loopMode: LoopMode.playlist,
      showNotification: notification.value,
      notificationSettings: const NotificationSettings(stopEnabled: false));
}

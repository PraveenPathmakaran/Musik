//list of asset audio songs
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import '../model/music_model.dart';
import 'home_screen/home_screen_controller.dart';
import 'play_screen/screen_play_controller.dart';
import 'splash_screen/screen_splash.dart';

Future<void> createAudiosFileList(List<MusicModel> audioConvertList) async {
  final ScreenPlayController screenPlayController =
      Get.put(ScreenPlayController());

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
  screenPlayController.loopButton.value = true;
}

//playlist setup
Future<void> setupPlaylist() async {
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());
  await audioPlayer.open(Playlist(audios: audioSongsList),
      autoStart: false,
      loopMode: LoopMode.playlist,
      showNotification: homeScreenController.notification.value,
      notificationSettings: const NotificationSettings(stopEnabled: false));
}

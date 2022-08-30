import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import '../screens/play_screen/screen_play.dart';
import '../screens/splash_screen/screen_splash.dart';

Color backgroundColor1 = const Color(0xFF2C3639);
Color backgroundColor2 = const Color(0xFF1e1c1d);
Color appbarColor = const Color(0xff0B2840);
Color colorListTile = const Color(0xFF14202E);
Color whiteColor = Colors.white;
Color roseColor = const Color(0xFFaf1337);
ValueNotifier<bool> notification = ValueNotifier(true);
const String appName = "Musik";

double screenHeight = 0;
double screenWidth = 0;
ValueNotifier<bool> miniPlayerVisibility = ValueNotifier(false);
bool songSkip = true;

//---------------------------functions for common usage

//common text function
Widget functionText(
    String content, Color color, FontWeight weight, double fontSize) {
  return Text(
    content,
    style: TextStyle(
      color: color,
      fontWeight: weight,
      fontSize: fontSize,
    ),
  );
}

//common icon
Widget functionIcon(IconData icon1, double iconSize, Color iconColor) {
  return Icon(
    icon1,
    size: iconSize,
    color: iconColor,
  );
}

//text function
Widget functionTextButton(Function() textFunction, String text) {
  return TextButton(
    style: ButtonStyle(
        alignment: Alignment.centerLeft,
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.all(0),
        )),
    onPressed: textFunction,
    child: functionText(
      text,
      whiteColor,
      FontWeight.bold,
      20,
    ),
  );
}

Widget miniPlayer(BuildContext context) {
  return Visibility(
    visible: miniPlayerVisibility.value,
    child: audioPlayer.builderRealtimePlayingInfos(
        builder: (context, realtimePlayingInfos) {
      return Card(
        color: appbarColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: ListTile(
          tileColor: Colors.transparent,
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: ((context) => const ScreenPlay()))),
          leading: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage('assets/images/musicIcon1.png'),
          ),
          title: Text(
            realtimePlayingInfos.current!.audio.audio.metas.title.toString(),
            maxLines: 1,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            realtimePlayingInfos.current!.audio.audio.metas.title.toString(),
            maxLines: 1,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              onPressed: () async {
                if (songSkip) {
                  songSkip = false;
                  await audioPlayer.previous();
                  songSkip = true;
                }
              },
              icon: functionIcon(Icons.skip_previous, 40, Colors.white),
            ),
            IconButton(
                onPressed: () {
                  audioPlayer.playOrPause();
                },
                icon: realtimePlayingInfos.isPlaying
                    ? functionIcon(Icons.pause, 40, Colors.white)
                    : functionIcon(Icons.play_arrow_rounded, 40, Colors.white)),
            IconButton(
              onPressed: () async {
                if (songSkip) {
                  songSkip = false;
                  await audioPlayer.next();
                  songSkip = true;
                }
              },
              icon: functionIcon(Icons.skip_next, 40, Colors.white),
            ),
          ]),
        ),
      );
    }),
  );
}

//------------------------------playscreen slider

Widget slider(RealtimePlayingInfos realtimePlayingInfos) {
  return Stack(
    children: [
      SliderTheme(
        data: const SliderThemeData(
            thumbColor: Colors.white,
            activeTrackColor: Color(0xffe45923),
            inactiveTrackColor: Colors.grey,
            overlayColor: Colors.transparent),
        child: Slider.adaptive(
          value: realtimePlayingInfos.currentPosition.inSeconds.toDouble(),
          //added 10000 some songs failed assertion value>=min&&valu<=max is not true
          max: realtimePlayingInfos.duration.inSeconds <= 0
              ? 10000
              : realtimePlayingInfos.duration.inSeconds.toDouble() + 3,
          min: 0,
          onChanged: ((value) {
            if (value <= 0) {
              audioPlayer.seek(const Duration(seconds: 0));
            } else if (value >= realtimePlayingInfos.duration.inSeconds) {
              audioPlayer.seek(realtimePlayingInfos.duration);
            } else {
              audioPlayer.seek(Duration(seconds: value.toInt()));
            }
          }),
        ),
      ),
    ],
  );
}

Widget timeStamps(RealtimePlayingInfos realtimePlayingInfos) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          transformString(realtimePlayingInfos.currentPosition.inSeconds),
          style: const TextStyle(color: Colors.grey),
        ),
        SizedBox(
          width: screenWidth * 0.7,
        ),
        Text(
          transformString(realtimePlayingInfos.duration.inSeconds),
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}

String transformString(int seconds) {
  String minuteString =
      '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
  String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
  return '$minuteString:$secondString';
}
//------------------------------playscreen slider end

void snackBar(String content, Color color, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(content),
    duration: const Duration(seconds: 1),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import '../controller/splash_screen/screen_splash.dart';
import '../core/colors.dart';

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
          EdgeInsets.zero,
        )),
    onPressed: textFunction,
    child: functionText(
      text,
      kWhiteColor,
      FontWeight.bold,
      20,
    ),
  );
}

//------------------------------playscreen slider

Widget slider(RealtimePlayingInfos realtimePlayingInfos) {
  return Stack(
    children: <Widget>[
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
          onChanged: (double value) {
            if (value <= 0) {
              audioPlayer.seek(Duration.zero);
            } else if (value >= realtimePlayingInfos.duration.inSeconds) {
              audioPlayer.seek(realtimePlayingInfos.duration);
            } else {
              audioPlayer.seek(Duration(seconds: value.toInt()));
            }
          },
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
      children: <Widget>[
        Text(
          transformString(realtimePlayingInfos.currentPosition.inSeconds),
          style: const TextStyle(color: Colors.grey),
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
  final String minuteString =
      '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
  final String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
  return '$minuteString:$secondString';
}
//------------------------------playscreen slider end

void snackBar(String content, Color color, BuildContext context) {
  final SnackBar snackBar = SnackBar(
    content: Text(content),
    duration: const Duration(seconds: 1),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

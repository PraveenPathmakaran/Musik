import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/splash_screen/screen_splash.dart';
import '../../core/colors.dart';
import '../../core/constant.dart';
import '../widgets.dart';

class ScreenSplash extends StatelessWidget {
  ScreenSplash({super.key});

  final ScreenSplashController _screenSplashController =
      Get.put(ScreenSplashController());
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _screenSplashController.gotoHome(context);
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              functionText(
                appName,
                kWhiteColor,
                FontWeight.bold,
                48,
              ),
              functionText(
                'Music Player',
                kWhiteColor,
                FontWeight.bold,
                24,
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              const CircularProgressIndicator(
                color: kWhiteColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

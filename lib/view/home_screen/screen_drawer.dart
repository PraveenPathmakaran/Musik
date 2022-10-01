import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../controller/home_screen/home_screen_controller.dart';
import '../../controller/splash_screen/screen_splash.dart';
import '../../core/colors.dart';
import '../../core/constant.dart';
import '../widgets.dart';

class DrawerContent extends StatelessWidget {
  DrawerContent({super.key});
  final HomeScreenController _homeScreenController =
      Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  functionText(appName, kWhiteColor, FontWeight.bold, 35),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  functionText(
                      'Music Player', kWhiteColor, FontWeight.bold, 25),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: <Widget>[
                      functionTextButton(() {}, 'Notifications'),
                      Obx(() {
                        return Switch(
                          activeTrackColor: kRoseColor,
                          activeColor: kWhiteColor,
                          inactiveTrackColor: Colors.white,
                          value: _homeScreenController.notification.value,
                          onChanged: (bool value) {
                            _homeScreenController.notification.value = value;
                            audioPlayer.showNotification = value;
                          },
                        );
                      })
                    ],
                  ),
                  functionTextButton(() {
                    Share.share(
                        'https://play.google.com/store/apps/details?id=com.musik.music_player');
                  }, 'Share'),
                  functionTextButton(() {
                    showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            title: const Text(
                              'Privacy Policy',
                            ),
                            content: const SingleChildScrollView(
                              child: Text(privacyPolicyContent),
                            ),
                            actions: <Widget>[
                              Center(
                                child: IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(Icons.close)),
                              )
                            ],
                          );
                        });
                  }, 'Privacy Policy'),
                  functionTextButton(() {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(12),
                            title: ListTile(
                              contentPadding: EdgeInsets.zero,
                              minVerticalPadding: 0,
                              leading: const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    AssetImage('assets/images/musicIcon1.png'),
                              ),
                              title: functionText('Play\nMusic Player',
                                  Colors.black, FontWeight.bold, 20),
                              subtitle: const Text(
                                  'It is a Ad free Music player Play all local storage musics'),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  showLicensePage(
                                      context: context,
                                      applicationName: 'Musik',
                                      applicationIcon: Image.asset(
                                        'assets/images/appIcon.png',
                                        width: 50,
                                        height: 50,
                                      ));
                                },
                                child: const Text('View License'),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('Close'))
                            ],
                          );
                        });
                  }, 'About'),
                  functionTextButton(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Really'),
                          content: const Text('Do you want to close the app?'),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('No')),
                            TextButton(
                                onPressed: () {
                                  SystemNavigator.pop();
                                },
                                child: const Text('Yes'))
                          ],
                        );
                      },
                    );
                  }, 'Exit'),
                ],
              ),
              Column(
                children: <Widget>[
                  functionText('Version', Colors.white, FontWeight.bold, 15),
                  functionText('1.0.0', Colors.white, FontWeight.bold, 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

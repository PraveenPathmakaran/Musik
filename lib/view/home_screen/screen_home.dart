import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controller/home_screen/home_screen_controller.dart';
import '../../core/colors.dart';
import '../favourite_screen/screen_addtofavourite.dart';
import '../favourite_screen/screen_favourite.dart';
import '../mini_player/mini_player.dart';
import '../playlist_screen/playlist_widgets.dart';
import '../playlist_screen/screen_playlist.dart';
import '../screen_search/screen_search.dart';
import '../widgets.dart';
import 'home_widgets.dart';
import 'screen_drawer.dart';

class ScreenHomeMain extends StatelessWidget {
  ScreenHomeMain({super.key});

  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  final HomeScreenController _homeScreenController =
      Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: DefaultTabController(
        length: 3,
        child: Builder(
          builder: (BuildContext context) {
            final TabController controller = DefaultTabController.of(context)!;
            controller.addListener(() {
              if (!controller.indexIsChanging) {
                _homeScreenController.tabIndex = controller.index;
                controller.index == 0
                    ? _homeScreenController.floatingBtnVisibility.value = false
                    : _homeScreenController.floatingBtnVisibility.value = true;
              }
            });

            return Scaffold(
                floatingActionButton: Obx(() {
                  return Visibility(
                    visible: _homeScreenController.floatingBtnVisibility.value,
                    child: FloatingActionButton(
                        backgroundColor: kAppbarColor,
                        onPressed: () {
                          if (_homeScreenController.tabIndex == 1) {
                            showModalBottomSheet(
                                backgroundColor: Colors.black,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30),
                                  ),
                                ),
                                builder: (BuildContext ctx) {
                                  return const ScreenAddToFavourits();
                                });
                          } else if (_homeScreenController.tabIndex == 2) {
                            playlistCreateDialogue(context);
                          }
                        },
                        child: functionIcon(Icons.add, 20, Colors.white)),
                  );
                }),
                backgroundColor: Colors.black,
                extendBodyBehindAppBar: true,
                drawer: Drawer(
                  width: 250,
                  backgroundColor: kAppbarColor,
                  child: DrawerContent(),
                ),
                appBar: AppBar(
                  title: const Text('Music Player'),
                  centerTitle: true,
                  backgroundColor: kAppbarColor,
                  bottom: TabBar(
                    onTap: (int value) {
                      value == 0
                          ? _homeScreenController.floatingBtnVisibility.value =
                              false
                          : _homeScreenController.floatingBtnVisibility.value =
                              true;
                      _homeScreenController.tabIndex = value;
                    },
                    tabs: <Widget>[
                      Tab(
                        text: 'Home',
                        icon: functionIcon(Icons.home, 25, kWhiteColor),
                      ),
                      Tab(
                        text: 'Favourites',
                        icon: functionIcon(Icons.favorite, 25, kWhiteColor),
                      ),
                      Tab(
                        text: 'Playlist',
                        icon:
                            functionIcon(Icons.playlist_play, 25, kWhiteColor),
                      ),
                    ],
                  ),
                  elevation: 0,
                  actions: <Widget>[
                    IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: MusicSearch(),
                          );
                        },
                        icon: const Icon(Icons.search))
                  ],
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(Icons.settings));
                    },
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    ScreenHome(),
                    ScreenFavourite(),
                    ScreenPlaylist(),
                  ],
                ),
                bottomNavigationBar: MiniPlayer());
          },
        ),
      ),
    );
  }
}

Future<bool> _onBackButtonPressed(BuildContext context) async {
  final bool? exitApp = await showDialog(
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
  return exitApp!;
}

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import '../../functions/design_widgets.dart';
import '../favourite_screen/screen_addtofavourite.dart';
import '../favourite_screen/screen_favourite.dart';
import '../playlist_screen/playlist_widgets.dart';
import '../playlist_screen/screen_playlist.dart';
import '../screen_search/screen_search.dart';
import 'home_widgets.dart';

late TabController tabController;
bool floatingBtnVisibility = true;

class ScreenHomeMain extends StatefulWidget {
  const ScreenHomeMain({Key? key}) : super(key: key);

  @override
  State<ScreenHomeMain> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHomeMain>
    with TickerProviderStateMixin {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    tabController.addListener(_handleSelected);
  }

//floating action button icon change
  void _handleSelected() {
    setState(() {
      tabController.index;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      tabController.index == 0
          ? floatingBtnVisibility = false
          : floatingBtnVisibility = true;
    });
    return ValueListenableBuilder(
      valueListenable: miniPlayerVisibility,
      builder: (BuildContext context, bool value, Widget? child) {
        return WillPopScope(
          onWillPop: () => _onBackButtonPressed(context),
          child: Scaffold(
              floatingActionButton: Visibility(
                visible: floatingBtnVisibility,
                child: FloatingActionButton(
                    backgroundColor: appbarColor,
                    onPressed: (() {
                      if (tabController.index == 1) {
                        showModalBottomSheet(
                            backgroundColor: Colors.black,
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            builder: (context) {
                              return const ScreenAddToFavourits();
                            });
                      } else if (tabController.index == 2) {
                        openDialog(context);
                      } else {}
                    }),
                    child: functionIcon(Icons.add, 20, Colors.white)),
              ),
              backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              drawer: Drawer(
                width: 250,
                backgroundColor: appbarColor,
                child: const DrawerContent(),
              ),
              appBar: AppBar(
                title: const Text('Music Player'),
                centerTitle: true,
                backgroundColor: appbarColor,
                bottom: TabBar(
                  onTap: (value) {},
                  controller: tabController,
                  tabs: [
                    Tab(
                      text: 'Home',
                      icon: functionIcon(Icons.home, 25, whiteColor),
                    ),
                    Tab(
                      text: 'Favourites',
                      icon: functionIcon(Icons.favorite, 25, whiteColor),
                    ),
                    Tab(
                      text: 'Playlist',
                      icon: functionIcon(Icons.playlist_play, 25, whiteColor),
                    ),
                  ],
                ),
                elevation: 0,
                actions: [
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
                controller: tabController,
                children: const [
                  ScreenHome(),
                  ScreenFavourite(),
                  ScreenPlaylist(),
                ],
              ),
              bottomNavigationBar: miniPlayer(context)),
        );
      },
    );
  }
}

Future<bool> _onBackButtonPressed(BuildContext context) async {
  bool exitApp = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Really"),
        content: const Text("Do you want to close the app?"),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"))
        ],
      );
    },
  );
  return exitApp;
}

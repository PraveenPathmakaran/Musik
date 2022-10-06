import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/favorite_screen/screen_favourites_controller.dart';
import '../../controller/splash_screen/screen_splash.dart';
import '../../core/colors.dart';
import '../playlist_screen/screen_add_to_playlist.dart';
import '../widgets.dart';

class HomeBottomSheet extends StatelessWidget {
  HomeBottomSheet({super.key, required this.id, this.index});
  final String id;
  final int? index;

  final FavouritesController favouritesController =
      Get.put(FavouritesController());

  @override
  Widget build(BuildContext context, {bool value = true}) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              functionText('', Colors.white, FontWeight.bold, 18),
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child:
                      functionText('Close', Colors.white, FontWeight.bold, 18))
            ],
          ),
        ),
        TextButton(
            onPressed: () async {
              if (tempFavouriteList.contains(id)) {
                Get.defaultDialog(
                  title: 'Alert',
                  content: const Text('Do you want to remove?'),
                  cancel: ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () => Get.back(),
                  ),
                  confirm: ElevatedButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      favouritesController.favouritesRemove(id);

                      Get.back();
                      Get.back();
                    },
                  ),
                );
              } else {
                favouritesController.addFavouritesToDB(id);
                Get.back();
              }
              tempFavouriteList.contains(id)
                  ? snackBar('Added to favourites', kBackgroundColor2, context)
                  : snackBar('Removed Succesfully', kBackgroundColor2, context);
            },
            child: tempFavouriteList.contains(id)
                ? functionText(
                    'Remove From Favourites', Colors.white, FontWeight.bold, 20)
                : functionText(
                    'Add to Favourites', Colors.white, FontWeight.bold, 20)),
        TextButton(
          child: functionText(
              'Add to Playlist ', Colors.white, FontWeight.bold, 20),
          onPressed: () {
            Get.back();
            showModalBottomSheet(
                backgroundColor: kAppbarColor,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                builder: (BuildContext context) {
                  return ScreenAddToPlaylistFromHome(
                    id: id,
                  );
                });
          },
        ),
      ],
    );
  }
}

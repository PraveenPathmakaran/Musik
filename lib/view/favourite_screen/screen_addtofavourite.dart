import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/favorite_screen/screen_favourites_controller.dart';
import '../../controller/splash_screen/screen_splash.dart';
import '../../core/colors.dart';
import '../widgets.dart';

// class ScreenAddToFavourits extends StatelessWidget {
//   const ScreenAddToFavourits({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: <Widget>[
//             Container(
//               padding: const EdgeInsets.only(left: 8, right: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   functionText(
//                       'Add to Favourites', Colors.white, FontWeight.bold, 18),
//                   TextButton(
//                       onPressed: () {
//                         Get.back();
//                       },
//                       child: functionText(
//                           'Close', Colors.white, FontWeight.bold, 18))
//                 ],
//               ),
//             ),
//             ListView.builder(
//               itemCount: allAudioListFromDB.length,
//               shrinkWrap: true,
//               controller: ScrollController(),
//               itemBuilder: (BuildContext context, int index) {
//                 return Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   color: kColorListTile,
//                   child: ListTile(
//                     leading: const CircleAvatar(
//                       radius: 35,
//                       backgroundColor: Colors.transparent,
//                       backgroundImage:
//                           AssetImage('assets/images/musicIcon1.png'),
//                     ),
//                     title: Text(
//                       allAudioListFromDB[index].title.toString(),
//                       maxLines: 1,
//                       style: const TextStyle(color: Colors.white, fontSize: 15),
//                     ),
//                     subtitle: Text(
//                       allAudioListFromDB[index].artist.toString(),
//                       maxLines: 1,
//                       style: const TextStyle(color: Colors.white, fontSize: 10),
//                     ),
//                     trailing: IconButton(
//                       icon: Obx(() {
//                         return favouritesListFromDb
//                                 .contains(allAudioListFromDB[index])
//                             ? functionIcon(Icons.remove, 20, Colors.white)
//                             : functionIcon(Icons.add, 20, Colors.white);
//                       }),
//                       onPressed: () async {
//                         final FavouritesController favouritesController =
//                             Get.put(FavouritesController());

//                         tempFavouriteList.contains(
//                                 allAudioListFromDB[index].id.toString())
//                             ? await favouritesController.favouritesRemove(
//                                 allAudioListFromDB[index].id.toString())
//                             : await favouritesController.addFavouritesToDB(
//                                 allAudioListFromDB[index].id.toString());
//                       },
//                     ),
//                   ),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class ScreenAddToFavourits extends StatelessWidget {
  const ScreenAddToFavourits({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      itemCount: allAudioListFromDB.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        log('1');
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: kColorListTile,
          child: ListTile(
            leading: const CircleAvatar(
              radius: 35,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/images/musicIcon1.png'),
            ),
            title: Text(
              allAudioListFromDB[index].title.toString(),
              maxLines: 1,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            subtitle: Text(
              allAudioListFromDB[index].artist.toString(),
              maxLines: 1,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            trailing: IconButton(
              icon: Obx(() {
                return favouritesListFromDb.contains(allAudioListFromDB[index])
                    ? functionIcon(Icons.remove, 20, Colors.white)
                    : functionIcon(Icons.add, 20, Colors.white);
              }),
              onPressed: () async {
                final FavouritesController favouritesController =
                    Get.put(FavouritesController());

                tempFavouriteList
                        .contains(allAudioListFromDB[index].id.toString())
                    ? await favouritesController.favouritesRemove(
                        allAudioListFromDB[index].id.toString())
                    : await favouritesController.addFavouritesToDB(
                        allAudioListFromDB[index].id.toString());
              },
            ),
          ),
        );
      },
    );
  }
}

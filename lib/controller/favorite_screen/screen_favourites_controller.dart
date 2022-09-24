import 'package:get/get.dart';
import '../../main.dart';
import '../../view/splash_screen/screen_splash.dart';

class FavouritesController extends GetxController {
  Future<void> addFavouritesToDB(String id) async {
    if (tempFavouriteList.contains(id)) {
      return;
    } else {
      tempFavouriteList.add(id);
      await favouriteDB.put("favourite", tempFavouriteList);
      getAllFavouritesFromDB();
    }
  }

  Future<void> getAllFavouritesFromDB() async {
    if (favouriteDB.isEmpty) {
      return;
    }
    tempFavouriteList = favouriteDB.get("favourite")!;
    await getFavouritesAudios(tempFavouriteList);
  }

  Future<void> getFavouritesAudios(List<String> favouritesList) async {
    favouritesListFromDb.value = allAudioListFromDB.where((element) {
      return favouritesList.contains(element.id);
    }).toList();
    favouritesListFromDb.sort(
      (a, b) => a.title!.compareTo(b.title!),
    );
  }

  Future<void> favouritesRemove(String id) async {
    tempFavouriteList.remove(id);
    await favouriteDB.put("favourite", tempFavouriteList);
    await getFavouritesAudios(tempFavouriteList);
    await getAllFavouritesFromDB();
  }
}

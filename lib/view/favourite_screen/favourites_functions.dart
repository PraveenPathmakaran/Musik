import '../../main.dart';
import '../splash_screen/screen_splash.dart';

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
  favouritesListFromDb.notifyListeners();
}

Future<void> getFavouritesAudios(List<String> favouritesList) async {
  favouritesListFromDb.value = allAudioListFromDB.where((element) {
    return favouritesList.contains(element.id);
  }).toList();
  favouritesListFromDb.value.sort(
    (a, b) => a.title!.compareTo(b.title!),
  );
}

Future<void> favouritesRemove(String id) async {
  tempFavouriteList.remove(id);
  await favouriteDB.put("favourite", tempFavouriteList);
  await getFavouritesAudios(tempFavouriteList);
  await getAllFavouritesFromDB();
}

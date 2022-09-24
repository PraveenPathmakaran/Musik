import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../functions/design_widgets.dart';
import '../splash_screen/screen_splash.dart';
import 'favourites_functions.dart';

class ScreenAddToFavourits extends StatelessWidget {
  const ScreenAddToFavourits({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  functionText(
                      "Add to Favourites", Colors.white, FontWeight.bold, 18),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: functionText(
                          "Close", Colors.white, FontWeight.bold, 18))
                ],
              ),
            ),
            ValueListenableBuilder(
                valueListenable: favouritesListFromDb,
                builder: (context, value, child) {
                  return ListView.builder(
                    controller: ScrollController(),
                    itemBuilder: ((context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: kColorListTile,
                        child: ListTile(
                          leading: const CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('assets/images/musicIcon1.png'),
                          ),
                          title: Text(
                            allAudioListFromDB[index].title.toString(),
                            maxLines: 1,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                          subtitle: Text(
                            allAudioListFromDB[index].artist.toString(),
                            maxLines: 1,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                          trailing: IconButton(
                            icon: favouritesListFromDb.value
                                    .contains(allAudioListFromDB[index])
                                ? functionIcon(Icons.remove, 20, Colors.white)
                                : functionIcon(Icons.add, 20, Colors.white),
                            onPressed: () async {
                              tempFavouriteList.contains(
                                      allAudioListFromDB[index].id.toString())
                                  ? await favouritesRemove(
                                      allAudioListFromDB[index].id.toString())
                                  : await addFavouritesToDB(
                                      allAudioListFromDB[index].id.toString());
                            },
                          ),
                        ),
                      );
                    }),
                    itemCount: allAudioListFromDB.length,
                    shrinkWrap: true,
                  );
                })
          ],
        ),
      ),
    );
  }
}

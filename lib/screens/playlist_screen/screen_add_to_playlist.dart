import 'package:flutter/material.dart';
import '../../functions/design_widgets.dart';
import '../splash_screen/screen_splash.dart';
import 'playlist_functions.dart';
import 'screen_playlist_songs.dart';

class SreenAddToPlaylist extends StatelessWidget {
  final String playlistname;
  const SreenAddToPlaylist({Key? key, required this.playlistname})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: playlistSongsFromDB,
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      functionText("Add Songs to $playlistname", Colors.white,
                          FontWeight.bold, 17),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: functionText(
                              "Close", Colors.white, FontWeight.bold, 17))
                    ],
                  ),
                ),
                ListView.builder(
                  controller: ScrollController(),
                  itemBuilder: ((context, index) {
                    return Card(
                      color: colorListTile,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
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
                          icon: playlistSongsFromDB.value
                                  .contains(allAudioListFromDB[index])
                              ? functionIcon(Icons.remove, 20, Colors.white)
                              : functionIcon(Icons.add, 20, Colors.white),
                          onPressed: () async {
                            tempPlaylistId.contains(
                                    allAudioListFromDB[index].id.toString())
                                ? await playlistSongDelete(
                                    allAudioListFromDB[index].id.toString(),
                                    playlistname)
                                : await addtoPlaylistSongs(
                                    allAudioListFromDB[index].id.toString(),
                                    playlistname);
                            await keyUpdate();
                          },
                        ),
                      ),
                    );
                  }),
                  itemCount: allAudioListFromDB.length,
                  shrinkWrap: true,
                ),
              ]),
            ),
          );
        });
  }
}

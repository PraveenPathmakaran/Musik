import 'package:hive_flutter/hive_flutter.dart';
part 'music_model.g.dart';

@HiveType(typeId: 1)
class MusicModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? path;
  @HiveField(2)
  String? title;
  @HiveField(3)
  String? artist;
  MusicModel({this.id, this.path, this.title, this.artist});

  MusicModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    path = json['path'];
    title = json['title'];
    artist = json['artist'];
  }
}

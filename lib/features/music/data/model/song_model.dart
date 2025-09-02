import 'package:music_app/features/music/domain/entities/song_entity.dart';

// ignore: must_be_immutable
class SongModel extends SongEntity {
  SongModel({
    super.id,
    required super.title,
    required super.artistName,
    required super.previewUrl,
    required super.thumbnailUrl,
    required super.userId,
    required super.songId,
  });

  // From API (Deezer)
  factory SongModel.fromApiJson(Map<String, dynamic> json) {
    return SongModel(
      userId: json['user']?['id']?.toString() ?? '',
      title: json['title'] ?? '',
      artistName: json['artist']?['name'] ?? '',
      previewUrl: json['preview'] ?? '',
      thumbnailUrl: json['artist']?['picture_medium'] ?? '',
      songId: json['id']?.toString() ?? '',
    );
  }

  // From MongoDB
  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      artistName: json['artistName'] ?? '',
      previewUrl: json['previewUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      songId: json['songId'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'songId': songId,
      'userId': userId,
      'title': title,
      'artistName': artistName,
      'previewUrl': previewUrl,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}

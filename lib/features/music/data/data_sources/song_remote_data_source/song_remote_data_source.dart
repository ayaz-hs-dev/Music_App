import 'package:music_app/features/music/domain/entities/song_entity.dart';

abstract class SongRemoteDataSource {
  Future<List<SongEntity>> searchSong(String songQuery);
  Future<void> addSong(SongEntity song);
  Future<void> deleteSong(String songId, String userId);
  // Future<void> deleteSong(String id);
  Future<List<SongEntity>> getSongs(String userId);
}

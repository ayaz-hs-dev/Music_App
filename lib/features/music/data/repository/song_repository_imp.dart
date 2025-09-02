import 'package:music_app/features/music/data/data_sources/song_remote_data_source/song_remote_data_source.dart';
import 'package:music_app/features/music/domain/entities/song_entity.dart';
import 'package:music_app/features/music/domain/repository/song_repository.dart';

class SongRepositoryImp implements SongRepository {
  final SongRemoteDataSource remoteDataSource;

  SongRepositoryImp({required this.remoteDataSource});
  @override
  Future<List<SongEntity>> searchSong(String songQuery) {
    return remoteDataSource.searchSong(songQuery);
  }

  @override
  Future<void> addSong(SongEntity song) {
    return remoteDataSource.addSong(song);
  }

  @override
  Future<void> deleteSong(String songId, String userId) {
    return remoteDataSource.deleteSong(songId, userId);
  }

  @override
  Future<List<SongEntity>> getSongs(String userId) {
    return remoteDataSource.getSongs(userId);
  }
}

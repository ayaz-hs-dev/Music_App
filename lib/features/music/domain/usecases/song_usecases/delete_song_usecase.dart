import 'package:music_app/features/music/domain/repository/song_repository.dart';

class DeleteSongUsecase {
  final SongRepository songRepository;

  DeleteSongUsecase({required this.songRepository});

  Future<void> call(String songId, String userId) async {
    return songRepository.deleteSong(songId, userId);
  }
}

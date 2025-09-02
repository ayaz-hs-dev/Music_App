import 'package:music_app/features/music/domain/entities/song_entity.dart';
import 'package:music_app/features/music/domain/repository/song_repository.dart';

class AddSongUsecase {
  final SongRepository songRepository;

  AddSongUsecase({required this.songRepository});

  Future<void> call(SongEntity songEntity) async {
    return songRepository.addSong(songEntity);
  }
}

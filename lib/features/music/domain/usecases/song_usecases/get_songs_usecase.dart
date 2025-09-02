import 'package:music_app/features/music/domain/entities/song_entity.dart';
import 'package:music_app/features/music/domain/repository/song_repository.dart';

class GetSongsUsecase {
  final SongRepository songRepository;

  GetSongsUsecase({required this.songRepository});

  Future<List<SongEntity>> call(String userId) async {
    return songRepository.getSongs(userId);
  }
}

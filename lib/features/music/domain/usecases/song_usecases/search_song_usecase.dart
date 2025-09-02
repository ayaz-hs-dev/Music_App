import 'package:music_app/features/music/domain/entities/song_entity.dart';
import 'package:music_app/features/music/domain/repository/song_repository.dart';

class SearchSongUsecase {
  final SongRepository songRepository;

  SearchSongUsecase({required this.songRepository});

  Future<List<SongEntity>> call(String songQuery) async {
    return songRepository.searchSong(songQuery);
  }
}

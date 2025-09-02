import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_app/features/music/domain/entities/song_entity.dart';
import 'package:music_app/features/music/domain/usecases/song_usecases/add_song_usecase.dart';
import 'package:music_app/features/music/domain/usecases/song_usecases/delete_song_usecase.dart';
import 'package:music_app/features/music/domain/usecases/song_usecases/get_songs_usecase.dart';

part 'song_state.dart';

class SongCubit extends Cubit<SongState> {
  final AddSongUsecase addSongUsecase;
  final GetSongsUsecase getSongsUsecase;
  final DeleteSongUsecase deleteSongUsecase;
  SongCubit({
    required this.addSongUsecase,
    required this.getSongsUsecase,
    required this.deleteSongUsecase,
  }) : super(SongInitial());

  // Get all songs
  Future<void> getSongs(String userId) async {
    emit(SongLoading());
    try {
      final songs = await getSongsUsecase(userId);
      emit(SongLoaded(songs: songs));
    } catch (e) {
      emit(SongError(message: e.toString()));
    }
  }

  // Add a new song
  Future<void> addSong(SongEntity song) async {
    try {
      await addSongUsecase(song);
      getSongs(song.userId); // Refresh list
    } catch (e) {
      emit(SongError(message: e.toString()));
    }
  }

  // Delete a song
  Future<void> deleteSong(String songId, String userId) async {
    try {
      await deleteSongUsecase(songId, userId);
      getSongs(userId); // Refresh list
    } catch (e) {
      emit(SongError(message: e.toString()));
    }
  }
}

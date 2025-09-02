import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_app/features/music/domain/entities/song_entity.dart';
import 'package:music_app/features/music/domain/usecases/song_usecases/search_song_usecase.dart';

part 'search_song_state.dart';

class SearchSongCubit extends Cubit<SearchSongState> {
  final SearchSongUsecase searchSongs;
  Timer? _debounce;

  SearchSongCubit({required this.searchSongs}) : super(SearchInitial());

  void onQueryChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (q.trim().isEmpty) {
        emit(SearchInitial());
        return;
      }
      emit(SearchLoading());
      try {
        final results = await searchSongs(q);
        emit(SearchLoaded(results));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

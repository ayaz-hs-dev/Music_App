part of 'search_song_cubit.dart';

sealed class SearchSongState extends Equatable {
  const SearchSongState();
}

final class SearchInitial extends SearchSongState {
  @override
  List<Object> get props => [];
}

class SearchLoading extends SearchSongState {
  @override
  List<Object?> get props => [];
}

class SearchLoaded extends SearchSongState {
  final List<SongEntity> songs;
  const SearchLoaded(this.songs);
  @override
  List<Object?> get props => [songs];
}

class SearchError extends SearchSongState {
  final String message;
  const SearchError(this.message);
  @override
  List<Object?> get props => [message];
}

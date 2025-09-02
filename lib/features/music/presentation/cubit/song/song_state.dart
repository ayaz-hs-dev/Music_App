part of 'song_cubit.dart';

sealed class SongState extends Equatable {
  const SongState();
}

final class SongInitial extends SongState {
  @override
  List<Object> get props => [];
}

class SongLoading extends SongState {
  @override
  List<Object?> get props => [];
}

class SongLoaded extends SongState {
  final List<SongEntity> songs;

  const SongLoaded({required this.songs});

  @override
  List<Object?> get props => [songs];
}

class SongError extends SongState {
  final String message;

  const SongError({required this.message});

  @override
  List<Object?> get props => [message];
}

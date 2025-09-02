import 'package:http/http.dart' as http;
import 'package:music_app/features/music/data/data_sources/comment_remote_data_source/comment_remote_data_source.dart';
import 'package:music_app/features/music/data/data_sources/comment_remote_data_source/comment_remote_data_source_impl.dart';
import 'package:music_app/features/music/data/data_sources/song_remote_data_source/song_remote_data_source.dart';
import 'package:music_app/features/music/data/data_sources/song_remote_data_source/song_remote_data_source_impl.dart';
import 'package:music_app/features/music/data/repository/comment_repository_impl.dart';
import 'package:music_app/features/music/data/repository/song_repository_imp.dart';
import 'package:music_app/features/music/domain/repository/comment_repository.dart';
import 'package:music_app/features/music/domain/repository/song_repository.dart';
import 'package:music_app/features/music/domain/usecases/comment_usecases/add_comment_usecase.dart';
import 'package:music_app/features/music/domain/usecases/comment_usecases/get_comments_by_song_id_usecase.dart';
import 'package:music_app/features/music/domain/usecases/song_usecases/add_song_usecase.dart';
import 'package:music_app/features/music/domain/usecases/song_usecases/delete_song_usecase.dart';
import 'package:music_app/features/music/domain/usecases/song_usecases/get_songs_usecase.dart';
import 'package:music_app/features/music/domain/usecases/song_usecases/search_song_usecase.dart';
import 'package:music_app/features/music/presentation/cubit/comment/comment_cubit.dart';

import 'package:music_app/features/music/presentation/cubit/search_song/search_song_cubit.dart';
import 'package:music_app/features/music/presentation/cubit/song/song_cubit.dart';
import 'package:music_app/main_injection.dart';

Future<void> songInjection() async {
  // 1️⃣ DATA SOURCE (bottom-most dependency)
  sl.registerLazySingleton<SongRemoteDataSource>(
    () => SongRemoteDataSourceImpl(client: http.Client()),
  );
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceImpl(),
  );

  // 2️⃣ REPOSITORY
  sl.registerLazySingleton<SongRepository>(
    () => SongRepositoryImp(remoteDataSource: sl.call()),
  );
  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(remoteDataSource: sl.call()),
  );

  // 3️⃣ USE CASE
  sl.registerLazySingleton<SearchSongUsecase>(
    () => SearchSongUsecase(songRepository: sl.call()),
  );
  sl.registerLazySingleton<AddSongUsecase>(
    () => AddSongUsecase(songRepository: sl.call()),
  );
  sl.registerLazySingleton<GetSongsUsecase>(
    () => GetSongsUsecase(songRepository: sl.call()),
  );
  sl.registerLazySingleton<DeleteSongUsecase>(
    () => DeleteSongUsecase(songRepository: sl.call()),
  );
  sl.registerLazySingleton<AddCommentUsecase>(
    () => AddCommentUsecase(commentRepository: sl.call()),
  );
  sl.registerLazySingleton<GetCommentsBySongIdUsecase>(
    () => GetCommentsBySongIdUsecase(commentRepository: sl.call()),
  );

  // 4️⃣ CUBIT (top-most dependency)
  sl.registerFactory<SearchSongCubit>(
    () => SearchSongCubit(searchSongs: sl.call()),
  );
  sl.registerFactory<SongCubit>(
    () => SongCubit(
      addSongUsecase: sl.call(),
      getSongsUsecase: sl.call(),
      deleteSongUsecase: sl.call(),
    ),
  );
  sl.registerFactory<CommentCubit>(
    () => CommentCubit(
      addCommentUsecase: sl.call(),
      getCommentsBySongIdUsecase: sl.call(),
    ),
  );
}

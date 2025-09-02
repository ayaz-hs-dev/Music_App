import 'package:music_app/features/music/data/data_sources/comment_remote_data_source/comment_remote_data_source.dart';
import 'package:music_app/features/music/domain/entities/comment_entity.dart';
import 'package:music_app/features/music/domain/repository/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({required this.remoteDataSource});
  @override
  Future<void> addComments(CommentEntity comment) async {
    return remoteDataSource.addComments(comment);
  }

  @override
  Future<List<CommentEntity>> getCommentsBySong(String songId) async {
    return remoteDataSource.getCommentsBySong(songId);
  }
}

import 'package:music_app/features/music/domain/entities/comment_entity.dart';

abstract class CommentRemoteDataSource {
  Future<List<CommentEntity>> getCommentsBySong(String songId);
  Future<void> addComments(CommentEntity comment);
}

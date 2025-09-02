import 'package:music_app/features/music/domain/entities/comment_entity.dart';
import 'package:music_app/features/music/domain/repository/comment_repository.dart';

class GetCommentsBySongIdUsecase {
  final CommentRepository commentRepository;

  GetCommentsBySongIdUsecase({required this.commentRepository});

  Future<List<CommentEntity>> call(String songId) async {
    return commentRepository.getCommentsBySong(songId);
  }
}

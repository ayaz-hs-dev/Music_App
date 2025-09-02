import 'package:music_app/features/music/domain/entities/comment_entity.dart';
import 'package:music_app/features/music/domain/repository/comment_repository.dart';

class AddCommentUsecase {
  final CommentRepository commentRepository;

  AddCommentUsecase({required this.commentRepository});

  Future<void> call(CommentEntity comment) async {
    return commentRepository.addComments(comment);
  }
}

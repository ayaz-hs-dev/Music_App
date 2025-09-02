// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:music_app/features/music/domain/entities/comment_entity.dart';
import 'package:music_app/features/music/domain/usecases/comment_usecases/add_comment_usecase.dart';
import 'package:music_app/features/music/domain/usecases/comment_usecases/get_comments_by_song_id_usecase.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final AddCommentUsecase addCommentUsecase;
  final GetCommentsBySongIdUsecase getCommentsBySongIdUsecase;

  CommentCubit({
    required this.addCommentUsecase,
    required this.getCommentsBySongIdUsecase,
  }) : super(CommentInitial());

  Future<void> loadComments(String songId) async {
    emit(CommentLoading());
    try {
      final comments = await getCommentsBySongIdUsecase(songId);
      emit(CommentLoaded(comments));
    } catch (e) {
      emit(CommentError("Failed to load comments: $e"));
    }
  }

  Future<void> addComment(CommentEntity comment, String songId) async {
    try {
      await addCommentUsecase(comment);

      // Fetch updated comments
      final updatedComments = await getCommentsBySongIdUsecase(songId);

      // Emit success + updated list
      emit(CommentLoaded(updatedComments));
      // Optionally: emit(CommentAdded()) if you want a "success action"
    } catch (e) {
      emit(CommentError("Failed to add comment: $e"));
    }
  }
}

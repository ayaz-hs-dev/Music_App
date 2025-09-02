part of 'comment_cubit.dart';

sealed class CommentState extends Equatable {
  const CommentState();
}

final class CommentInitial extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentLoading extends CommentState {
  @override
  List<Object?> get props => [];
}

class CommentLoaded extends CommentState {
  final List<CommentEntity> comments;

  const CommentLoaded(this.comments);

  @override
  List<Object?> get props => [comments];
}

class CommentError extends CommentState {
  final String message;

  const CommentError(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentAdded extends CommentState {
  @override
  List<Object?> get props => [];
}

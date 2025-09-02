import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String? commentId;
  final String? comment;
  final String? userId;
  final String? userName;
  final String? userAvatar;
  final String? songId;

  const CommentEntity({
    this.commentId,
    this.comment,
    this.userId,
    this.userName,
    this.userAvatar,
    this.songId,
  });

  @override
  List<Object?> get props => [
    commentId,
    comment,
    userId,
    userName,
    userAvatar,
    songId,
  ];
}

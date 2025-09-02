import 'package:music_app/features/music/domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  const CommentModel({
    super.commentId,
    super.comment,
    super.userId,
    super.userName,
    super.userAvatar,
    super.songId,
  });

  // Factory constructor to create CommentModel from JSON
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['commentId'] ?? '',
      comment: json['comment'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      songId: json['songId'] ?? '',
    );
  }

  // Convert CommentModel back to JSON (for POST requests)
  Map<String, dynamic> toJson() {
    return {
      "comment": comment,
      "userId": userId,
      "userName": userName,
      "userAvatar": userAvatar,
      "songId": songId,
    };
  }
}

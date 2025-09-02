import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:music_app/features/music/data/data_sources/comment_remote_data_source/comment_remote_data_source.dart';
import 'package:music_app/features/music/data/model/comment_model.dart';
import 'package:music_app/features/music/domain/entities/comment_entity.dart';

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  // final String baseUrl = "http://10.0.2.2:3000/comments"; // 👈 change if needed
  final String baseUrl =
      "http://192.168.1.5:3000/comments"; // 👈 change if needed

  @override
  Future<void> addComments(CommentEntity commentEntity) async {
    CommentModel commentModel = CommentModel(
      commentId: commentEntity.commentId,
      comment: commentEntity.comment,
      userId: commentEntity.userId,
      userName: commentEntity.userName,
      userAvatar: commentEntity.userAvatar,
      songId: commentEntity.songId,
    );

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(commentModel.toJson()),
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var data = jsonDecode(response.body);
        debugPrint("Comment added successfully!");
        debugPrint("Comment data: $data");
      } else {
        debugPrint("Failed to add  comment: ${response.statusCode}");
        throw Exception(
          "Failed to add comments (status: ${response.statusCode})",
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception("Error fetching comments for song $e");
    }
  }

  @override
  Future<List<CommentEntity>> getCommentsBySong(String songId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/song/$songId"),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          return data.map((json) => CommentModel.fromJson(json)).toList();
        } else {
          throw Exception("Unexpected response format: $data");
        }
      } else {
        throw Exception(
          "Failed to load comments (status: ${response.statusCode})",
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception("Error fetching comments for song $songId: $e");
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:music_app/features/music/data/data_sources/song_remote_data_source/song_remote_data_source.dart';
import 'package:music_app/features/music/data/model/song_model.dart';
import 'package:music_app/features/music/domain/entities/song_entity.dart';

class SongRemoteDataSourceImpl implements SongRemoteDataSource {
  final http.Client client;

  SongRemoteDataSourceImpl({required this.client});

  @override
  Future<List<SongEntity>> searchSong(String songQuery) async {
    final response = await client.get(
      Uri.parse('https://api.deezer.com/search?q=$songQuery'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List tracksJson = data['data'];
      debugPrint("Thumbnail URL: $data");

      return tracksJson.map((json) => SongModel.fromApiJson(json)).toList();
    } else {
      throw Exception('Failed to fetch tracks');
    }
  }

  // final String baseUrl = 'http://10.0.2.2:3000/songs';
  final String baseUrl = 'http://192.168.1.5:3000/songs';

  // Add a song
  @override
  Future<void> addSong(SongEntity song) async {
    SongModel songModel = SongModel(
      id: song.id,
      userId: song.userId,
      title: song.title,
      artistName: song.artistName,
      previewUrl: song.previewUrl,
      thumbnailUrl: song.thumbnailUrl,
      songId: song.songId,
    );

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(songModel.toJson()),
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var data = jsonDecode(response.body);
        debugPrint("Song added successfully!");
        debugPrint("Song data: $data");
      } else {
        debugPrint("Failed to create song: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  // Delete a song by songId + userId
  @override
  Future<void> deleteSong(String songId, String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$songId/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        debugPrint("Song deleted successfully!");
      } else if (response.statusCode == 404) {
        debugPrint("Song not found.");
      } else {
        debugPrint("Failed to delete Song: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  // Get all songs for a given userId
  @override
  Future<List<SongEntity>> getSongs(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$userId'), // 👈 use params instead of query
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SongModel.fromJson(json)).toList();
      } else {
        debugPrint("Failed to fetch songs: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching songs: $e");
      return [];
    }
  }
}

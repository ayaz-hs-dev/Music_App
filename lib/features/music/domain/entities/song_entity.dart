// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class SongEntity extends Equatable {
  String? id;
  final String songId;
  final String userId;
  final String title;
  final String artistName;
  final String previewUrl;
  final String thumbnailUrl;

  SongEntity({
    this.id,
    required this.songId,
    required this.userId,
    required this.title,
    required this.artistName,
    required this.previewUrl,
    required this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [
    userId,
    id,
    songId,
    title,
    artistName,
    previewUrl,
    thumbnailUrl,
  ];
}

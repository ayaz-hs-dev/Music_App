import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/app/theme/style.dart';
import 'package:music_app/features/global/widgets/custom_image_widget.dart';
import 'package:music_app/features/global/widgets/custom_text_field_widget.dart';
import 'package:music_app/features/music/domain/entities/song_entity.dart';
import 'package:music_app/features/music/presentation/cubit/search_song/search_song_cubit.dart';
import 'package:music_app/features/music/presentation/cubit/song/song_cubit.dart';
import 'package:music_app/features/music/presentation/pages/music_player_page.dart';
import 'package:music_app/features/users/presentation/cubit/user/user_cubit.dart';

class SearchOnlineMusicPage extends StatefulWidget {
  const SearchOnlineMusicPage({super.key});

  @override
  State<SearchOnlineMusicPage> createState() => _SearchOnlineMusicPageState();
}

class _SearchOnlineMusicPageState extends State<SearchOnlineMusicPage> {
  final TextEditingController searchMusicController = TextEditingController();
  String? currentUserId; // nullable until fetched

  @override
  void initState() {
    super.initState();
    _loadUserId(); // call async function separately
  }

  Future<void> _loadUserId() async {
    final userCubit = context.read<UserCubit>();
    final id = await userCubit.getCurrentId();
    setState(() {
      currentUserId = id;
    });
  }

  @override
  void dispose() {
    searchMusicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          CustomTextFieldWidget(
            controller: searchMusicController,
            hintText: "Search Music",
            onChanged: (query) {
              context.read<SearchSongCubit>().onQueryChanged(query);
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<SearchSongCubit, SearchSongState>(
              builder: (context, searchState) {
                if (searchState is SearchInitial) {
                  return _buildInitialView();
                } else if (searchState is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (searchState is SearchLoaded) {
                  final songs = searchState.songs;
                  if (songs.isEmpty) return _buildEmptyView();

                  return BlocBuilder<SongCubit, SongState>(
                    builder: (context, songState) {
                      return ListView.builder(
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];

                          // check if already favorited
                          bool isFavorited = false;
                          if (songState is SongLoaded) {
                            isFavorited = songState.songs.any(
                              (s) =>
                                  s.songId == song.songId &&
                                  s.userId == currentUserId,
                            );
                          }

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: backgroundColor,
                            child: ListTile(
                              leading: CustomImageWidget(
                                imagePath: song.thumbnailUrl,
                                size: 40,
                                isCircular: false,
                                isNetwork: true,
                              ),
                              title: Text(song.title),
                              subtitle: Text(song.artistName),
                              trailing: SizedBox(
                                width: 97,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.star,
                                        color: isFavorited
                                            ? tabColor
                                            : greyColor,
                                      ),
                                      onPressed: currentUserId == null
                                          ? null
                                          : () {
                                              final songEntity = SongEntity(
                                                userId: currentUserId!,
                                                title: song.title,
                                                artistName: song.artistName,
                                                previewUrl: song.previewUrl,
                                                thumbnailUrl: song.thumbnailUrl,
                                                songId: song.songId,
                                              );

                                              if (isFavorited) {
                                                context
                                                    .read<SongCubit>()
                                                    .deleteSong(
                                                      song.songId,
                                                      currentUserId!,
                                                    );
                                              } else {
                                                context
                                                    .read<SongCubit>()
                                                    .addSong(songEntity);
                                              }
                                            },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.play_circle_fill,
                                        color: tabColor,
                                      ),
                                      onPressed: () {
                                        showMusicPlayerBottomSheet(
                                          context,
                                          songTitle: song.title,
                                          artistName: song.artistName,
                                          audioSource: song.previewUrl,
                                          songId: null,
                                          albumArtUrl: song.thumbnailUrl,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (searchState is SearchError) {
                  return Center(child: Text(searchState.message));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/2.json', width: 250, height: 250),
          const SizedBox(height: 10),
          const Text(
            "Search for music you like...",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/2.json', width: 250, height: 250),
          const SizedBox(height: 10),
          const Text("No songs found.", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

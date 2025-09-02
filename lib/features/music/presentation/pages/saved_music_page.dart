import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:music_app/app/theme/style.dart';
import 'package:music_app/features/global/widgets/custom_image_widget.dart';
import 'package:music_app/features/global/widgets/custom_text_field_widget.dart';
import 'package:music_app/features/music/domain/entities/comment_entity.dart';
import 'package:music_app/features/music/presentation/cubit/comment/comment_cubit.dart';
import 'package:music_app/features/music/presentation/cubit/song/song_cubit.dart';
import 'package:music_app/features/music/presentation/pages/music_player_page.dart';
import 'package:music_app/features/users/presentation/cubit/user/user_cubit.dart';

class SavedOnlineMusicPage extends StatefulWidget {
  const SavedOnlineMusicPage({super.key});

  @override
  State<SavedOnlineMusicPage> createState() => _SavedOnlineMusicPageState();
}

class _SavedOnlineMusicPageState extends State<SavedOnlineMusicPage> {
  TextEditingController commentController = TextEditingController();
  static String currentUserId = "";
  @override
  void initState() {
    super.initState();
    _loadUserId(); // loads userId and then songs
  }

  Future<void> _loadUserId() async {
    final userCubit = context.read<UserCubit>();
    final id = await userCubit.getCurrentId();
    setState(() => currentUserId = id);

    // Load songs only after userId is ready ✅
    await _loadSongs();
  }

  Future<void> _loadSongs() async {
    if (currentUserId.isNotEmpty) {
      context.read<SongCubit>().getSongs(currentUserId);
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          currentUserId = state.user.id!;
          context.read<SongCubit>().getSongs(currentUserId);
        }
      },
      child: BlocBuilder<SongCubit, SongState>(
        builder: (context, state) {
          if (state is SongLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SongLoaded) {
            final songs = state.songs;
            if (songs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/lottie/No-Data.json", width: 250),
                    const SizedBox(height: 10),
                    const Text("There is not any music saved yet!"),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: songs.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final song = songs[index];
                return GestureDetector(
                  onTap: () {
                    showMusicPlayerBottomSheet(
                      context,
                      songTitle: song.title,
                      artistName: song.artistName,
                      audioSource: song.previewUrl,
                      albumArtUrl: song.thumbnailUrl,
                    );
                  },
                  child: Card(
                    elevation: 3,
                    color: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          CustomImageWidget(
                            imagePath: song.thumbnailUrl,
                            isNetwork: true,
                            size: 70,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  song.title,
                                  style: const TextStyle(fontSize: 18),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  song.artistName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: greyColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  context.read<SongCubit>().deleteSong(
                                    song.songId,
                                    song.userId,
                                  );
                                },
                                icon: const Icon(Icons.star, color: tabColor),
                              ),
                              IconButton(
                                onPressed: () {
                                  _commentSection(
                                    controller: commentController,
                                    title: song.title,
                                    songId: song.songId,
                                  );
                                },
                                icon: const Icon(
                                  Icons.comment_sharp,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _commentSection({
    required TextEditingController controller,
    required String title,
    required String songId,
  }) {
    // Load comments every time bottom sheet is opened
    context.read<CommentCubit>().loadComments(songId);
    context.read<UserCubit>().getUser();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: Column(
              children: [
                // ---- Header ----
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Comments of ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "($title)",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // ---- Comments List ----
                Expanded(
                  child: BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, state) {
                      if (state is CommentLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CommentLoaded) {
                        final comments = state.comments;
                        if (comments.isEmpty) {
                          return const Center(child: Text("No comments yet!"));
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final c = comments[index];
                            return ListTile(
                              leading: CustomImageWidget(
                                imagePath: "assets/user/${c.userAvatar!}",
                                isNetwork:
                                    c.userAvatar?.startsWith("http") ?? false,
                                size: 50,
                              ),
                              title: Text(
                                c.userName ?? "Unknown User",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(c.comment ?? ""),
                            );
                          },
                        );
                      } else if (state is CommentError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),

                // ---- Comment Input ----
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    if (state is UserLoaded) {
                      final user = state.user;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextFieldWidget(
                          controller: controller,
                          hintText: "Write a comment...",
                          suffixIcon: Icons.send,
                          onSuffixTap: () {
                            if (controller.text.trim().isNotEmpty) {
                              context.read<CommentCubit>().addComment(
                                CommentEntity(
                                  songId: songId,
                                  userName: user.name,
                                  comment: controller.text.trim(),
                                  userId: user.id,
                                  userAvatar:
                                      user.avatar ??
                                      "assets/default-avatar.png",
                                ),
                                songId,
                              );
                              controller.clear();

                              // Immediately refresh comment list
                              context.read<CommentCubit>().loadComments(songId);
                            }
                          },
                        ),
                      );
                    } else if (state is UserLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return const Center(child: Text("No user data"));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:music_app/features/music/presentation/pages/music_player_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:music_app/app/theme/style.dart';

class DeviceMusicPage extends StatefulWidget {
  static SongModel? currentlyPlayingSong;
  const DeviceMusicPage({super.key});

  @override
  State<DeviceMusicPage> createState() => _DeviceMusicPageState();
}

class _DeviceMusicPageState extends State<DeviceMusicPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  // Store the currently playing song's ID to update the UI

  Future<List<SongModel>>? _songsFuture;

  @override
  void initState() {
    super.initState();
    requestStoragePermission().then((_) => _loadSongs());
  }

  void _loadSongs() {
    _songsFuture = _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    setState(() {}); // triggers FutureBuilder to rebuild
  }

  Future<void> requestStoragePermission() async {
    // on_audio_query plugin needs permission to read storage.
    PermissionStatus status;

    // For Android 13 (API 33) and above, use Permission.audio.
    // For older versions, use Permission.storage.
    if (await _isAndroid13OrHigher()) {
      status = await Permission.audio.request();
    } else {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      // Permission granted. We can now query for songs.
      // Calling setState will trigger a rebuild, which will then call the FutureBuilder.
      setState(() {});
    } else {
      // Handle the case where permission is denied.
      debugPrint("Storage permission denied.");
    }
  }

  Future<bool> _isAndroid13OrHigher() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt >= 33;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WidgetStateColor.transparent,
      body: FutureBuilder<List<SongModel>>(
        future: _songsFuture,
        builder: (context, item) {
          if (item.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (item.hasError || item.data == null) {
            return Center(
              child: Text(item.error?.toString() ?? "Failed to load songs."),
            );
          }

          if (item.data!.isEmpty) {
            return const Center(child: Text("No songs found on this device."));
          }

          final songs = item.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            spacing: 0,
            children: [
              IconButton(
                onPressed: _loadSongs,
                icon: const Icon(Icons.refresh),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: songs.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (BuildContext context, int index) {
                    final song = songs[index];

                    final isPlaying =
                        song == DeviceMusicPage.currentlyPlayingSong;

                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        showMusicPlayerBottomSheet(
                          context,
                          songTitle: song.title,
                          artistName: song.artist ?? "Unknown Artist",
                          songId: song.id,
                          audioSource: song
                              .data, // pass id for artwork instead of imagePath
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
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: QueryArtworkWidget(
                                  id: song.id,
                                  type: ArtworkType.AUDIO,
                                  artworkFit: BoxFit.cover,
                                  nullArtworkWidget: const Icon(
                                    Icons.music_note,
                                    color: Colors.white,
                                  ),
                                  artworkBorder: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      song.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      song.artist ?? "Unknown Artist",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_fill,
                                color: tabColor,
                                size: 30,
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

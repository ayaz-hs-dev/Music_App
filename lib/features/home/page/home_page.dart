import 'package:flutter/material.dart';
import 'package:music_app/app/const/page_const.dart';
import 'package:music_app/app/theme/style.dart';
import 'package:music_app/features/global/widgets/custom_image_widget.dart';
import 'package:music_app/features/music/presentation/pages/device_music_page.dart';
import 'package:music_app/features/music/presentation/pages/music_player_page.dart';
import 'package:music_app/features/music/presentation/pages/saved_music_page.dart';
import 'package:music_app/features/music/presentation/pages/search_online_music_page.dart';
import 'package:music_app/service/audio_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomePage extends StatefulWidget {
  final int? index;
  const HomePage({super.key, this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  SongModel? currentSong = DeviceMusicPage.currentlyPlayingSong;
  TabController? _tabController;
  int _currentTabIndex = 0;
  bool isShowingBottomSheet = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      if (!_tabController!.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController!.index;
        });
      }
    });
    if (widget.index != null) {
      setState(() {
        _currentTabIndex = widget.index!;
        _tabController!.animateTo(_currentTabIndex);
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: WidgetStateColor.transparent,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              const Icon(Icons.music_note, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              const Text(
                "Music",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 28,
                ),
                color: Colors.grey.shade900.withOpacity(0.9),
                iconSize: 28,
                onSelected: (value) {},
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "Settings",
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageConst.settingsPage);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.settings, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Settings',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.6),

          indicator: const BoxDecoration(),
          controller: _tabController,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          tabs: [
            _buildTab("Saved", Icons.favorite_border, 0),
            _buildTab("Search", Icons.search, 1),
            _buildTab("Device", Icons.library_music, 2),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade800,
              Colors.indigo.shade500,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            SavedOnlineMusicPage(),
            SearchOnlineMusicPage(),
            DeviceMusicPage(),
          ],
        ),
      ),
      bottomSheet: isShowingBottomSheet
          ? Stack(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    showMusicPlayerBottomSheet(
                      context,
                      songTitle: AudioManager().currentTitle ?? '',
                      artistName: AudioManager().currentArtist ?? '',
                      audioSource: AudioManager().currentSource ?? '',
                      albumArtUrl: AudioManager().currentImageUrl,
                    );
                  },
                  child: StreamBuilder(
                    stream: AudioManager().onPlayerStateChanged,
                    builder: (context, snapshot) {
                      final isPlaying = AudioManager().isPlaying;
                      return Container(
                        height: 100,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: backgroundColor.withOpacity(0.95),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: backgroundColor,
                              blurRadius: 15,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Song Image with animation
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CustomImageWidget(
                                  isCircular: false,
                                  isNetwork: true,
                                  imagePath:
                                      AudioManager().currentImageUrl ??
                                      "assets/user/user1.jpg",
                                  size: 70,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Song Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AudioManager().currentTitle ?? "No Song",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    AudioManager().currentArtist ??
                                        "Unknown Artist",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            // Action Buttons
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.skip_previous,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    // TODO: implement skip previous
                                  },
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo.shade500,
                                        Colors.blue.shade400,
                                      ],
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                    onPressed: () async {
                                      await AudioManager().togglePlayPause();
                                      setState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    Icons.skip_next,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    // TODO: implement skip next
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isShowingBottomSheet = !isShowingBottomSheet;
                      });
                    },
                    icon: const Icon(Icons.cancel, color: Colors.white),
                  ),
                ),
              ],
            )
          : null,
      floatingActionButton: isShowingBottomSheet
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  isShowingBottomSheet = !isShowingBottomSheet;
                });
              },
              backgroundColor: Colors.blue.shade400,
              child: const Icon(Icons.music_note, color: Colors.white),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTab(String title, IconData icon, int index) {
    final isSelected = _currentTabIndex == index;
    return Tab(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? Colors.white.withOpacity(0.5)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          // spacing: -10,
          children: [
            // const SizedBox(width: 8),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:music_app/app/const/page_const.dart';
// import 'package:music_app/app/theme/style.dart';
// import 'package:music_app/features/global/widgets/custom_image_widget.dart';
// import 'package:music_app/features/music/presentation/pages/device_music_page.dart';

// import 'package:music_app/features/music/presentation/pages/saved_music_page.dart';
// import 'package:music_app/features/music/presentation/pages/search_online_music_page.dart';
// import 'package:music_app/service/audio_manager.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// class HomePage extends StatefulWidget {
//   final int? index;
//   const HomePage({super.key, this.index});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   SongModel? currentSong = DeviceMusicPage.currentlyPlayingSong;
//   TabController? _tabController;
//   int _currentTabIndex = 0;
//   bool isShowingBottomSheet = false;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);

//     _tabController!.addListener(() {
//       setState(() {
//         _currentTabIndex = _tabController!.index;
//       });
//     });
//     // debugPrint("Curerent Index is $_currentTabIndex");
//     if (widget.index != null) {
//       setState(() {
//         _currentTabIndex = widget.index!;
//         _tabController!.animateTo(1);
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _tabController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text("Listen Music"),
//         actions: [
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.more_vert, color: greyColor, size: 28),
//             color: appBarColor,
//             iconSize: 28,
//             onSelected: (value) {},
//             itemBuilder: (context) => <PopupMenuEntry<String>>[
//               PopupMenuItem<String>(
//                 value: "Settings",
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pushNamed(context, PageConst.settingsPage);
//                   },
//                   child: const Text('Settings'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//         bottom: TabBar(
//           labelColor: tabColor,
//           unselectedLabelColor: greyColor,
//           indicatorColor: tabColor,
//           controller: _tabController,
//           tabs: [
//             Tab(text: "Saved"),
//             Tab(text: "Search"),
//             Tab(text: "Device"),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,

//         children: [
//           SavedOnlineMusicPage(),
//           SearchOnlineMusicPage(),
//           DeviceMusicPage(),
//         ],
//       ),
//       bottomSheet: isShowingBottomSheet
//           ? StreamBuilder(
//               stream: AudioManager().onPlayerStateChanged,
//               builder: (context, snapshot) {
//                 final isPlaying = AudioManager().isPlaying;
//                 return Stack(
//                   children: [
//                     Container(
//                       height: 100,
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       decoration: BoxDecoration(
//                         color: appBarColor,
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(10),
//                           topRight: Radius.circular(10),
//                         ),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 8,
//                             offset: Offset(0, -2),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           // Song Image
//                           CustomImageWidget(
//                             isCircular: false,
//                             isNetwork: true,
//                             imagePath:
//                                 AudioManager().currentImageUrl ??
//                                 "assets/user/user1.jpg",
//                             size: 70,
//                           ),
//                           const SizedBox(width: 12),

//                           // Song Info
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   AudioManager().currentTitle ?? "No Song",
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   AudioManager().currentArtist ?? "",
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white70,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ),

//                           // Action Buttons
//                           Row(
//                             children: [
//                               IconButton(
//                                 icon: const Icon(
//                                   Icons.skip_previous,
//                                   color: tabColor,
//                                   size: 28,
//                                 ),
//                                 onPressed: () {
//                                   // TODO: implement skip previous
//                                 },
//                               ),
//                               const SizedBox(width: 8),
//                               IconButton(
//                                 icon: Icon(
//                                   isPlaying
//                                       ? Icons.pause_circle_filled
//                                       : Icons.play_circle_fill,
//                                   color: tabColor,
//                                   size: 36,
//                                 ),
//                                 onPressed: () async {
//                                   await AudioManager().togglePlayPause();
//                                   setState(() {}); // Update play/pause icon
//                                 },
//                               ),
//                               const SizedBox(width: 8),
//                               IconButton(
//                                 icon: const Icon(
//                                   Icons.skip_next,
//                                   color: tabColor,
//                                   size: 28,
//                                 ),
//                                 onPressed: () {
//                                   // TODO: implement skip next
//                                 },
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Close Button
//                     Positioned(
//                       child: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             isShowingBottomSheet = false;
//                           });
//                         },
//                         icon: const Icon(Icons.cancel),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             )
//           : null,

//       floatingActionButton: isShowingBottomSheet
//           ? null
//           : FloatingActionButton.small(
//               onPressed: () {
//                 setState(() {
//                   isShowingBottomSheet = !isShowingBottomSheet;
//                 });
//               },
//               child: const Icon(Icons.music_note),
//             ),
//     );
//   }
// }

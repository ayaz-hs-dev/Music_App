import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/app/theme/style.dart';
import 'package:music_app/service/audio_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';

// 🎵 Music Player BottomSheet
Future<void> showMusicPlayerBottomSheet(
  BuildContext context, {
  required String songTitle,
  required String artistName,
  required String audioSource, // can be URL or local path
  int? songId,
  String? albumArtUrl, // optional, only for local artwork
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: tabColor,
    builder: (context) {
      return _MusicPlayerSheet(
        songTitle: songTitle,
        artistName: artistName,
        audioSource: audioSource,
        songId: songId,
        albumArtUrl: albumArtUrl,
      );
    },
  );
}

class _MusicPlayerSheet extends StatefulWidget {
  final String songTitle;
  final String artistName;
  final String audioSource;
  final int? songId; // for local artwork
  final String? albumArtUrl; // for online artwork

  const _MusicPlayerSheet({
    required this.songTitle,
    required this.artistName,
    required this.audioSource,
    this.songId,
    this.albumArtUrl,
  });

  @override
  State<_MusicPlayerSheet> createState() => _MusicPlayerSheetState();
}

class _MusicPlayerSheetState extends State<_MusicPlayerSheet> {
  final AudioManager _audioPlayer = AudioManager();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;

  bool get _isUrl => widget.audioSource.startsWith("http");

  @override
  void initState() {
    super.initState();

    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((
      state,
    ) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((
      newDuration,
    ) {
      if (mounted) setState(() => _duration = newDuration);
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((
      newPosition,
    ) {
      if (mounted) setState(() => _position = newPosition);
    });

    // Auto play on open
    _playAudio();
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _playAudio() async {
    try {
      // Reset position and duration for new song
      setState(() {
        _position = Duration.zero;
        _duration = Duration.zero;
      });

      await AudioManager().play(
        widget.audioSource,
        isUrl: _isUrl,
        title: widget.songTitle,
        artist: widget.artistName,
        imageUrl: widget.albumArtUrl,
      );
    } catch (e) {
      _showError("Error playing audio: $e");
    }
  }

  Future<void> _pauseAudio() async => await _audioPlayer.pause();

  Future<void> _togglePlayPause() async =>
      _isPlaying ? await _pauseAudio() : await _playAudio();

  Future<void> _seekAudio(double value) async {
    final position = Duration(seconds: value.toInt());
    await _audioPlayer.seek(position);
  }

  Future<void> _skipForward() async {
    final newPos = _position + const Duration(seconds: 10);
    await _audioPlayer.seek(newPos > _duration ? _duration : newPos);
  }

  Future<void> _skipBackward() async {
    final newPos = _position - const Duration(seconds: 10);
    await _audioPlayer.seek(newPos < Duration.zero ? Duration.zero : newPos);
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    Widget artworkWidget;

    // Determine which artwork to show
    if (_isUrl && widget.albumArtUrl != null) {
      artworkWidget = ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          widget.albumArtUrl!,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.music_note, size: 120, color: Colors.white),
        ),
      );
    } else if (!_isUrl && widget.songId != null) {
      artworkWidget = SizedBox(
        width: 200,
        height: 200,
        child: QueryArtworkWidget(
          id: widget.songId!,
          type: ArtworkType.AUDIO,
          artworkFit: BoxFit.cover,
          nullArtworkWidget: const Icon(
            Icons.music_note,
            size: 120,
            color: Colors.white,
          ),
          artworkBorder: BorderRadius.circular(20),
        ),
      );
    } else {
      artworkWidget = const Icon(
        Icons.music_note,
        size: 120,
        color: Colors.white,
      );
    }

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: tabColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          artworkWidget,
          const SizedBox(height: 20),
          Text(
            widget.songTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.artistName,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 30),
          Slider(
            value: _position.inSeconds.toDouble().clamp(
              0.0,
              _duration.inSeconds.toDouble() > 0
                  ? _duration.inSeconds.toDouble()
                  : 1.0,
            ),
            min: 0,
            max: _duration.inSeconds.toDouble() > 0
                ? _duration.inSeconds.toDouble()
                : 1,
            activeColor: Colors.white,
            inactiveColor: Colors.grey,
            onChanged: _seekAudio,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  _formatDuration(_duration),
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.replay_10,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: _skipBackward,
              ),
              const SizedBox(width: 30),
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 30),
              IconButton(
                icon: const Icon(
                  Icons.forward_10,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: _skipForward,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

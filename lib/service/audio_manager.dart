import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:music_app/service/task_handler.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  String? currentTitle;
  String? currentArtist;
  String? currentImageUrl;
  String? currentSource;
  bool isUrl = false;

  Stream<PlayerState> get onPlayerStateChanged => _player.onPlayerStateChanged;
  Stream<Duration> get onPositionChanged => _player.onPositionChanged;
  Stream<Duration> get onDurationChanged => _player.onDurationChanged;

  Future<void> play(
    String source, {
    bool isUrl = false,
    String? title,
    String? artist,
    String? imageUrl,
  }) async {
    currentSource = source;
    this.isUrl = isUrl;
    currentTitle = title;
    currentArtist = artist;
    currentImageUrl = imageUrl;

    await _player.stop();
    await _player.play(isUrl ? UrlSource(source) : DeviceFileSource(source));
    isPlaying = true;
    WidgetsFlutterBinding.ensureInitialized();
    if (await FlutterForegroundTask.isRunningService) {
      await updateNotification(title: title, artist: artist);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _startService(
          currentTitle ?? 'Playing Music',
          currentArtist ?? '',
        );
      });
    }
  }

  Future<void> pause() async {
    await _player.pause();
    isPlaying = false;
    await stopService();
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await pause();
    } else {
      await _player.resume();
      isPlaying = true;
    }
  }

  Future<void> seek(Duration position) async => await _player.seek(position);

  Future<void> stop() async {
    await _player.stop();
    isPlaying = false;
    await stopService();
  }

  Future<void> updateNotification({String? title, String? artist}) async {
    currentTitle = title ?? currentTitle;
    currentArtist = artist ?? currentArtist;

    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.updateService(
        notificationTitle: currentTitle ?? 'Playing Music',
        notificationText: currentArtist ?? '',
      );
    }
  }

  Future<ServiceRequestResult> _startService(
    String taskTitle,
    String taskText,
  ) async {
    return FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: taskTitle,
      notificationText: taskText,
      notificationIcon: null,
      notificationInitialRoute: '/',
      callback: startCallback,
      notificationButtons: [
        NotificationButton(id: 'stop', text: "Stop"),
        NotificationButton(id: 'play_pause', text: "Play/Pause"),
      ],
    );
  }

  AudioPlayer get player => _player;

  Future<void> stopService() async {
    await FlutterForegroundTask.stopService();
    debugPrint("Service stopped");
  }
}

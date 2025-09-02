import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void startCallback() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.setTaskHandler(MusicTaskHandler());
}

class MusicTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter? taskStarter) async {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint("Foreground Started");
  }

  @override
  void onNotificationButtonPressed(String id) {
    debugPrint("Button pressed in TaskHandler: $id");
    FlutterForegroundTask.sendDataToMain(id);
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp();
    debugPrint("Notification pressed");
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isBool) async {
    debugPrint("Foreground Destroyed");
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    debugPrint("onRepeatEvent");
  }
}




















    // if (id == 'stop') {
    //   AudioManager().stopService();
    //   AudioManager().pause();
    //   debugPrint("Stop pressed");
    // }
    // if (id == 'play_pause') {
    //   AudioManager().togglePlayPause();
    //   debugPrint("Play pressed");
    // }
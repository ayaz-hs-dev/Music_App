import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:music_app/app/theme/style.dart';
import 'package:music_app/features/home/page/home_page.dart';
import 'package:music_app/features/music/presentation/cubit/comment/comment_cubit.dart';
import 'package:music_app/features/music/presentation/cubit/search_song/search_song_cubit.dart';
import 'package:music_app/features/music/presentation/cubit/song/song_cubit.dart';
import 'package:music_app/features/users/presentation/cubit/auth/auth_cubit.dart';
import 'package:music_app/features/users/presentation/cubit/user/user_cubit.dart';
import 'package:music_app/features/users/presentation/pages/login_page.dart';
import 'package:music_app/main_injection.dart' as di;
import 'package:music_app/route/on_genearte_route.dart';
import 'package:music_app/service/audio_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  // Initialize once here
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'foreground_service',
      channelName: 'Foreground Service',
      channelDescription: 'Foreground service is running',
      onlyAlertOnce: true,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.repeat(5000),
      autoRunOnBoot: true,
      autoRunOnMyPackageReplaced: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );

  FlutterForegroundTask.initCommunicationPort();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<Object?> _taskDataListenable = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Ask permissions after UI is ready
      final permission =
          await FlutterForegroundTask.checkNotificationPermission();
      if (permission != NotificationPermission.granted) {
        await FlutterForegroundTask.requestNotificationPermission();
      }

      if (Platform.isAndroid) {
        if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
          await FlutterForegroundTask.requestIgnoreBatteryOptimization();
        }
      }

      if (!await FlutterForegroundTask.canScheduleExactAlarms) {
        await FlutterForegroundTask.openAlarmsAndRemindersSettings();
      }
    });
  }

  void _onReceiveTaskData(Object data) async {
    if (data is String) {
      switch (data) {
        case 'play_pause':
          await AudioManager().togglePlayPause();
          break;
        case 'stop':
          await AudioManager().stopService();
          await AudioManager().pause();
          break;
      }
    }
  }

  @override
  void dispose() {
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    _taskDataListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthCubit>()..appStarted()),
        BlocProvider(create: (context) => di.sl<UserCubit>()),
        BlocProvider(create: (context) => di.sl<SearchSongCubit>()),
        BlocProvider(create: (context) => di.sl<SongCubit>()),
        BlocProvider(create: (context) => di.sl<CommentCubit>()),
      ],
      child: MaterialApp(
        title: 'Music App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: tabColor,
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(backgroundColor: appBarColor),
          dialogTheme: const DialogThemeData(backgroundColor: appBarColor),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: whiteColor),
            bodyMedium: TextStyle(color: whiteColor),
            titleLarge: TextStyle(color: whiteColor),
          ),
        ),
        initialRoute: "/",
        onGenerateRoute: OnGenerateRoute.route,
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return HomePage();
                }
                return const LoginPage();
              },
            );
          },
        },
      ),
    );
  }
}

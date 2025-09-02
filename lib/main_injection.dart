import 'package:get_it/get_it.dart';
import 'package:music_app/features/music/song_injection.dart';
import 'package:music_app/features/users/user_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await userInjection();
  await songInjection();
}

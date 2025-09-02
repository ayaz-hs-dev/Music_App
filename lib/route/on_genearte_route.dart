import 'package:flutter/material.dart';
import 'package:music_app/app/const/page_const.dart';
import 'package:music_app/features/home/page/home_page.dart';

import 'package:music_app/features/settings/settings_page.dart';
import 'package:music_app/features/users/presentation/pages/edit_profile_page.dart';
import 'package:music_app/features/users/presentation/pages/get_in_existing_user.dart';
import 'package:music_app/features/users/presentation/pages/login_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    // final args = settings.arguments;
    final name = settings.name;

    switch (name) {
      case PageConst.homePage:
        {
          return materialPageBuilder(HomePage());
        }
      case PageConst.loginPage:
        {
          return materialPageBuilder(LoginPage());
        }
      case PageConst.existingUserPageLogIn:
        {
          return materialPageBuilder(GetInExistingUserPage());
        }
      case PageConst.settingsPage:
        {
          return materialPageBuilder(SettingsPage());
        }
      case PageConst.editProfilePage:
        {
          return materialPageBuilder(EditProfilePage());
        }
    }
    return null;
  }
}

dynamic materialPageBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Error")),
      body: const Center(child: Text("Error")),
    );
  }
}

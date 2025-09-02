import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/app/const/page_const.dart';
import 'package:music_app/app/theme/style.dart';
import 'package:music_app/features/global/widgets/custom_image_widget.dart';
import 'package:music_app/features/users/presentation/cubit/auth/auth_cubit.dart';
import 'package:music_app/features/users/presentation/cubit/user/user_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();

    final userCubit = context.read<UserCubit>();
    userCubit.getUser();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // App Bar
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // User Profile Section
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: BlocBuilder<UserCubit, UserState>(
                          builder: (context, state) {
                            if (state is UserLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              );
                            } else if (state is UserLoaded) {
                              final user = state.user;
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Profile Card
                                  Container(
                                    padding: EdgeInsets.all(30),
                                    decoration: BoxDecoration(
                                      color: backgroundColor.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 15,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        // Profile Image
                                        Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 10,
                                                offset: Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: ClipOval(
                                            child: CustomImageWidget(
                                              imagePath:
                                                  "assets/user/${user.avatar}",
                                              isCircular: true,
                                              size: 150,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        // User Name
                                        Text(
                                          "${user.name}",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: tabColor,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        // User Info
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: backgroundColor,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            "Music Enthusiast",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: tabColor,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 40),

                                  // Settings Options
                                ],
                              );
                            } else if (state is UserError) {
                              return Center(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red.shade400,
                                        size: 60,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Error: ${state.error}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.red.shade400,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.person_outline,
                                        color: Colors.grey.shade400,
                                        size: 60,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "No user data available",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit Profile Button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 8,
                                backgroundColor: Colors.blue.shade500,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                shadowColor: tabColor.withOpacity(0.4),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  PageConst.editProfilePage,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit, size: 24),
                                  SizedBox(width: 10),
                                  Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          // Log Out Button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 8,
                                backgroundColor: Colors.red.shade400,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                shadowColor: Colors.red.withOpacity(0.4),
                              ),
                              onPressed: () {
                                _showLogoutDialog(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout, size: 24),
                                  SizedBox(width: 10),
                                  Text(
                                    "Log Out",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red.shade400, size: 28),
              SizedBox(width: 10),
              Text(
                "Confirm Logout",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to log out?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              ),
              onPressed: () {
                Navigator.pop(context);
                context.read<AuthCubit>().loggedOut().then((_) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    PageConst.loginPage,
                    (route) => false,
                  );
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Log Out",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:music_app/app/const/page_const.dart';
// import 'package:music_app/app/theme/style.dart';
// import 'package:music_app/features/global/widgets/button_widget.dart';
// import 'package:music_app/features/global/widgets/custom_image_widget.dart';
// import 'package:music_app/features/users/presentation/cubit/auth/auth_cubit.dart';
// import 'package:music_app/features/users/presentation/cubit/user/user_cubit.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   @override
//   void initState() {
//     super.initState();

//     final userCubit = context.read<UserCubit>();
//     userCubit.getUser();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Settings")),
//       body: Container(
//         margin: EdgeInsets.all(10),
//         width: double.infinity,
//         child: BlocBuilder<UserCubit, UserState>(
//           builder: (context, state) {
//             if (state is UserLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is UserLoaded) {
//               final user = state.user;
//               return Column(
//                 children: [
//                   CustomImageWidget(
//                     imagePath: "assets/user/${user.avatar}",
//                     size: 200,
//                   ),
//                   SizedBox(height: 10),
//                   Text("${user.name}", style: TextStyle(fontSize: 20)),
//                 ],
//               );
//             } else if (state is UserError) {
//               return Center(child: Text("Error: ${state.error}"));
//             } else {
//               return Center(child: Text("No user data"));
//             }
//           },
//         ),
//       ),
//       bottomSheet: Container(
//         width: double.infinity,
//         height: 300,
//         color: backgroundColor,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           spacing: 20,
//           children: <Widget>[
//             buttonWidget(
//               buttonName: "Edit Profile",
//               onPressed: () {
//                 Navigator.pushNamed(context, PageConst.editProfilePage);
//               },
//             ),
//             buttonWidget(
//               buttonName: "Log Out",
//               onPressed: () {
//                 context.read<AuthCubit>().loggedOut().then((_) {
//                   Navigator.pushNamedAndRemoveUntil(
//                     context,
//                     PageConst.loginPage,
//                     (route) => false,
//                   );
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

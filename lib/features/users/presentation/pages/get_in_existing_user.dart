import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/app/const/page_const.dart';
import 'package:music_app/app/theme/style.dart';
import 'package:music_app/features/global/widgets/custom_text_field_widget.dart';
import 'package:music_app/features/users/presentation/cubit/user/user_cubit.dart';

class GetInExistingUserPage extends StatefulWidget {
  const GetInExistingUserPage({super.key});

  @override
  State<GetInExistingUserPage> createState() => _GetInExistingUserPageState();
}

class _GetInExistingUserPageState extends State<GetInExistingUserPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  TextEditingController userNameController = TextEditingController();

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
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
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo and Title
                    Container(
                      margin: EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: tabColor,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Sign in to continue to your account",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Login Card
                    Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Username",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Enter your username to sign in",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 20),
                          CustomTextFieldWidget(
                            controller: userNameController,
                            hintText: "Enter your username...",
                            prefixIcon: Icons.person,
                            isValidated: true,
                          ),
                          SizedBox(height: 40),

                          // Login Button with BlocListener
                          BlocListener<UserCubit, UserState>(
                            listener: (context, state) {
                              if (state is UserLoaded) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  PageConst.homePage,
                                  (route) => false,
                                );
                              } else if (state is UserError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(child: Text(state.error)),
                                      ],
                                    ),
                                    backgroundColor: Colors.red.shade400,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 8,
                                  backgroundColor: tabColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  shadowColor: Colors.indigo.withOpacity(0.4),
                                ),
                                onPressed: () {
                                  String input = userNameController.text.trim();
                                  final regex = RegExp(
                                    r'^(?=.*[a-z])(?=.*[!@#\$&*~]).{8,}$',
                                  );

                                  if (input.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                "Username cannot be empty",
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Colors.red.shade400,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    );
                                    return;
                                  } else if (!regex.hasMatch(input)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                "Invalid username format",
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Colors.red.shade400,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  context.read<UserCubit>().signInWithUserName(
                                    input,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login, size: 24),
                                    SizedBox(width: 10),
                                    Text(
                                      "Sign In",
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
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    // Create Account Link
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, PageConst.loginPage);
                      },
                      child: Text(
                        "Don't have an account? Create one",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
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
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:music_app/app/const/page_const.dart';
// import 'package:music_app/app/theme/style.dart';
// import 'package:music_app/features/global/widgets/button_widget.dart';
// import 'package:music_app/features/global/widgets/custom_text_field_widget.dart';
// import 'package:music_app/features/users/presentation/cubit/user/user_cubit.dart';

// class GetInExistingUserPage extends StatefulWidget {
//   const GetInExistingUserPage({super.key});

//   @override
//   State<GetInExistingUserPage> createState() => _GetInExistingUserPageState();
// }

// class _GetInExistingUserPageState extends State<GetInExistingUserPage> {
//   TextEditingController userNameController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Login Page")),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.only(top: 50),
//         child: Container(
//           margin: EdgeInsets.all(15),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 25),

//               CustomTextFieldWidget(
//                 controller: userNameController,
//                 hintText: "Enter your User Name.....",
//                 isValidated: true,
//               ),
//               SizedBox(height: 60),
//               BlocListener<UserCubit, UserState>(
//                 listener: (context, state) {
//                   if (state is UserLoaded) {
//                     Navigator.pushNamedAndRemoveUntil(
//                       context,
//                       PageConst.homePage,
//                       (route) => false,
//                     );
//                   } else if (state is UserError) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(state.error),
//                         backgroundColor: tabColor,
//                       ),
//                     );
//                   }
//                 },
//                 child: buttonWidget(
//                   buttonName: "Get In",
//                   onPressed: () {
//                     String input = userNameController.text.trim();

//                     final regex = RegExp(r'^(?=.*[a-z])(?=.*[!@#\$&*~]).{8,}$');
//                     if (input.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text("Username cannot be empty"),
//                           backgroundColor: tabColor,
//                         ),
//                       );
//                       return;
//                     } else if (!regex.hasMatch(input)) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text("Invalid username format"),
//                           backgroundColor: tabColor,
//                         ),
//                       );
//                       return;
//                     }

//                     context.read<UserCubit>().signInWithUserName(input);
//                   },
//                 ),
//               ),
//               SizedBox(height: 20),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, PageConst.loginPage);
//                 },
//                 child: Text("If don't have an User!"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

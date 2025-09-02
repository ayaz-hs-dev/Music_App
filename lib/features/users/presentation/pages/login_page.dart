import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/app/const/page_const.dart';
import 'package:music_app/app/theme/style.dart';
import 'package:music_app/features/global/widgets/custom_image_widget.dart';
import 'package:music_app/features/global/widgets/custom_text_field_widget.dart';
import 'package:music_app/features/users/domain/entities/user_entity.dart';
import 'package:music_app/features/users/presentation/cubit/user/user_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  TextEditingController userNameController = TextEditingController();
  int selectedIndex = 0;
  List<String> userAvatarImage = [
    "user1.jpg",
    "user2.jpg",
    "user3.jpg",
    "user4.jpg",
    "user5.jpg",
    "user7.jpg",
  ];

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
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo and Title
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
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
                            Icons.music_note,
                            size: 60,
                            color: tabColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Create Your Profile",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Join our music community",
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  // Avatar Selection Section
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    padding: EdgeInsets.all(20),
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
                      children: [
                        Text(
                          "Select Your Avatar",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple.shade800,
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: GridView.builder(
                            padding: EdgeInsets.all(8),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 1,
                                ),
                            itemCount: userAvatarImage.length,
                            itemBuilder: (context, index) {
                              bool isSelected = selectedIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.deepPurple
                                          : Colors.transparent,
                                      width: isSelected ? 3 : 0,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Colors.deepPurple
                                                  .withOpacity(0.5),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Stack(
                                    children: [
                                      CustomImageWidget(
                                        imagePath:
                                            "assets/user/${userAvatarImage[index]}",
                                        isCircular: true,
                                      ),
                                      if (isSelected)
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurple,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Username Input Section
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    padding: EdgeInsets.all(20),
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
                          "Create Username",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple.shade800,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Must be at least 8 characters with 1 lowercase & 1 special character",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 15),
                        CustomTextFieldWidget(
                          controller: userNameController,
                          hintText: "Enter your username...",
                          prefixIcon: Icons.person,
                          isValidated: true,
                        ),
                      ],
                    ),
                  ),

                  // Sign Up Button
                  Container(
                    width: double.infinity,
                    height: 55,
                    margin: EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        shadowColor: Colors.deepPurple.withOpacity(0.4),
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
                                    child: Text("Username cannot be empty"),
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.red.shade400,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
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
                                      "Username must be at least 8 chars, include 1 lowercase & 1 special char",
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.red.shade400,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                          return;
                        }

                        UserEntity user = UserEntity(
                          name: input,
                          avatar: userAvatarImage[selectedIndex],
                        );
                        context.read<UserCubit>().createUser(user).then((_) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            PageConst.homePage,
                            (route) => false,
                          );
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.music_note, size: 24),
                          SizedBox(width: 10),
                          Text(
                            "Join Now",
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

                  // Existing User Link
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        PageConst.existingUserPageLogIn,
                      );
                    },
                    child: Text(
                      "Already have an account? Sign In",
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
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:music_app/app/const/page_const.dart';
// import 'package:music_app/app/theme/style.dart';
// import 'package:music_app/features/global/widgets/button_widget.dart';
// import 'package:music_app/features/global/widgets/custom_image_widget.dart';
// import 'package:music_app/features/global/widgets/custom_text_field_widget.dart';
// import 'package:music_app/features/users/domain/entities/user_entity.dart';
// import 'package:music_app/features/users/presentation/cubit/user/user_cubit.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController userNameController = TextEditingController();
//   int selectedIndex = 0;
//   List<String> userAvatarImage = [
//     "user1.jpg",
//     "user2.jpg",
//     "user3.jpg",
//     "user4.jpg",
//     "user5.jpg",
//     "user7.jpg",
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("SignUp Page")),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.only(top: 50),
//         child: Container(
//           margin: EdgeInsets.all(15),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Select a Avatar for yourself"),
//               SizedBox(height: 25),
//               SizedBox(
//                 width: 250,
//                 height: 250,
//                 child: GridView.builder(
//                   padding: EdgeInsets.all(16),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3, // number of columns
//                     crossAxisSpacing: 20,
//                     mainAxisSpacing: 20,
//                     childAspectRatio: 1,
//                   ),
//                   itemCount: userAvatarImage.length,
//                   itemBuilder: (context, index) {
//                     bool isSelected = selectedIndex == index;

//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedIndex = index; // toggle selection
//                         });
//                       },
//                       child: Stack(
//                         children: [
//                           CustomImageWidget(
//                             imagePath: "assets/user/${userAvatarImage[index]}",
//                             isCircular: true,
//                           ),
//                           if (isSelected)
//                             Positioned(
//                               top: 0,
//                               right: 0,
//                               child: Icon(
//                                 Icons.check_circle,
//                                 color: tabColor,
//                                 size: 24,
//                               ),
//                             ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               CustomTextFieldWidget(
//                 controller: userNameController,
//                 hintText: "Enter your User Name.....",
//                 isValidated: true,
//               ),
//               SizedBox(height: 20),
//               buttonWidget(
//                 buttonName: "Get In",
//                 onPressed: () {
//                   String input = userNameController.text.trim();

//                   // ✅ Validation regex: at least 8 chars, 1 lowercase, 1 special char
//                   final regex = RegExp(r'^(?=.*[a-z])(?=.*[!@#\$&*~]).{8,}$');

//                   if (input.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text("Username cannot be empty"),
//                         backgroundColor: tabColor,
//                       ),
//                     );
//                     return;
//                   } else if (!regex.hasMatch(input)) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           "Username must be at least 8 chars, include 1 lowercase & 1 special char",
//                         ),
//                         backgroundColor: tabColor,
//                       ),
//                     );
//                     return;
//                   }

//                   // ✅ If valid → navigate
//                   UserEntity user = UserEntity(
//                     name: input,
//                     avatar: userAvatarImage[selectedIndex],
//                   );

//                   context.read<UserCubit>().createUser(user).then((_) {
//                     Navigator.pushNamedAndRemoveUntil(
//                       context,
//                       PageConst.homePage,
//                       (route) => false,
//                     );
//                   });
//                 },
//               ),
//               SizedBox(height: 20),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, PageConst.existingUserPageLogIn);
//                 },
//                 child: Text("If User Exist Already!"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

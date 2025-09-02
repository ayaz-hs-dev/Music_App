import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/app/const/page_const.dart';
import 'package:music_app/app/theme/style.dart';
import 'package:music_app/features/global/widgets/custom_image_widget.dart';
import 'package:music_app/features/global/widgets/custom_text_field_widget.dart';
import 'package:music_app/features/users/domain/entities/user_entity.dart';
import 'package:music_app/features/users/presentation/cubit/auth/auth_cubit.dart';
import 'package:music_app/features/users/presentation/cubit/user/user_cubit.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>
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
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header Section
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(Icons.edit, size: 60, color: Colors.blue),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Edit Your Profile",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Update your avatar and username",
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
                      color: backgroundColor.withOpacity(0.9),
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
                            color: Colors.blue.shade800,
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
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: isSelected ? 3 : 0,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: tabColor.withOpacity(0.5),
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
                                              color: tabColor,
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

                  // Username Section
                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: backgroundColor.withOpacity(0.9),
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
                          "Update Username",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade800,
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

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Delete Button
                        Expanded(
                          child: Container(
                            height: 55,
                            margin: EdgeInsets.only(right: 10),
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
                                showDeleteDialog(
                                  context,
                                  onConfirm: () {
                                    context.read<AuthCubit>().loggedOut();
                                    context.read<UserCubit>().deleteUser().then(
                                      (_) {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          PageConst.loginPage,
                                          (route) => false,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    size: 20,
                                  ), // Reduced icon size
                                  SizedBox(width: 8), // Reduced spacing
                                  Flexible(
                                    // Added Flexible widget
                                    child: Text(
                                      "Delete Profile",
                                      style: TextStyle(
                                        fontSize: 14, // Reduced font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow
                                          .ellipsis, // Added overflow handling
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Save Button
                        Expanded(
                          child: Container(
                            height: 55,
                            margin: EdgeInsets.only(left: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 8,
                                backgroundColor: Colors.white,
                                foregroundColor: tabColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                shadowColor: tabColor.withOpacity(0.4),
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
                                  name: userNameController.text,
                                  avatar: userAvatarImage[selectedIndex],
                                );
                                context.read<UserCubit>().updateUser(user).then(
                                  (_) {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.save,
                                    size: 20,
                                  ), // Reduced icon size
                                  SizedBox(width: 8), // Reduced spacing
                                  Flexible(
                                    // Added Flexible widget
                                    child: Text(
                                      "Save Changes",
                                      style: TextStyle(
                                        fontSize: 14, // Reduced font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow
                                          .ellipsis, // Added overflow handling
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Expanded(
                // Added Expanded widget
                child: Text(
                  "Confirm Delete",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                  overflow: TextOverflow.ellipsis, // Added overflow handling
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to delete your profile? This action cannot be undone.",
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
                onConfirm();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_forever, size: 20),
                  SizedBox(width: 8),
                  Text("Delete", style: TextStyle(fontWeight: FontWeight.bold)),
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
// import 'package:music_app/features/global/widgets/custom_text_field_widget.dart';
// import 'package:music_app/features/users/domain/entities/user_entity.dart';
// import 'package:music_app/features/users/presentation/cubit/user/user_cubit.dart';

// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});

//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
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
//       appBar: AppBar(title: Text("Edit Profile")),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: EdgeInsets.all(10),
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             spacing: 10,
//             children: [
//               SizedBox(height: 50),
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
//                 hintText: "User Name",
//                 isValidated: true,
//               ),
//               SizedBox(height: 90),
//               Container(
//                 width: double.infinity,
//                 color: backgroundColor,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   spacing: 20,
//                   children: <Widget>[
//                     buttonWidget(
//                       buttonName: "Delete Profile",
//                       onPressed: () {
//                         showDeleteDialog(
//                           context,
//                           onConfirm: () {
//                             context.read<UserCubit>().deleteUser().then((_) {
//                               Navigator.pushNamedAndRemoveUntil(
//                                 context,
//                                 PageConst.loginPage,
//                                 (route) => false,
//                               );
//                             });
//                             debugPrint("Item Deleted ");
//                           },
//                         );
//                       },
//                     ),
//                     buttonWidget(
//                       buttonName: "Save",
//                       // onPressed: () {

//                       // },
//                       onPressed: () {
//                         String input = userNameController.text.trim();

//                         // ✅ Validation regex: at least 8 chars, 1 lowercase, 1 special char
//                         final regex = RegExp(
//                           r'^(?=.*[a-z])(?=.*[!@#\$&*~]).{8,}$',
//                         );

//                         if (input.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text("Username cannot be empty"),
//                               backgroundColor: tabColor,
//                             ),
//                           );
//                           return;
//                         } else if (!regex.hasMatch(input)) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                 "Username must be at least 8 chars, include 1 lowercase & 1 special char",
//                               ),
//                               backgroundColor: tabColor,
//                             ),
//                           );
//                           return;
//                         }

//                         UserEntity user = UserEntity(
//                           name: userNameController.text,
//                           avatar: userAvatarImage[selectedIndex],
//                         );
//                         context.read<UserCubit>().updateUser(user).then((_) {
//                           Navigator.pop(context);
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void showDeleteDialog(
//     BuildContext context, {
//     required VoidCallback onConfirm,
//   }) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: Text("Confirm Delete"),
//           content: Text("Are you sure you want to delete this item?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("Cancel"),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: tabColor),
//               onPressed: () {
//                 Navigator.pushNamedAndRemoveUntil(
//                   context,
//                   PageConst.loginPage,
//                   (route) => false,
//                 );
//                 // Close dialog
//                 onConfirm(); // Call the delete action
//               },
//               child: Text("Delete"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

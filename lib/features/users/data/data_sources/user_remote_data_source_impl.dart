import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_app/features/users/data/data_sources/user_remote_data_source.dart';
import 'package:music_app/features/users/data/model/user_model.dart';
import 'package:music_app/features/users/domain/entities/user_entity.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  String currentId = '';
  // final String baseUrl = 'http://10.0.2.2:3000/users';
  final String baseUrl = 'http://192.168.1.5:3000/users';

  @override
  Future<void> createUser(UserEntity user) async {
    UserModel userModel = UserModel(name: user.name, avatar: user.avatar);

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userModel.toJson()),
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var data = jsonDecode(response.body);
        await setCurrentId(data["_id"]);
        debugPrint("User created successfully! ID: $currentId");
      } else {
        debugPrint("Failed to create user: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        debugPrint("User deleted successfully!");
      } else if (response.statusCode == 404) {
        debugPrint("User not found.");
      } else {
        debugPrint("Failed to delete user: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Future<void> signInWithUserName(String name) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/signin"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        await setCurrentId(data["_id"]);
        debugPrint(
          "Signed in successfully as ${data['name']} (ID: $currentId)",
        );
      } else if (response.statusCode == 404) {
        debugPrint("User not found. Please sign up first.");
      } else {
        debugPrint("Sign in failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error signing in: $e");
    }
  }

  @override
  Future<UserEntity> getSingleUser(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        debugPrint("User not found");
        return UserEntity();
      } else {
        throw Exception("Failed to fetch user: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
      return UserEntity();
    }
  }

  @override
  Future<List<UserEntity>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl), // ✅ include id in URL if needed
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // assuming the response is a list of users (JSON array)
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => UserModel.fromJson(e)).toList();
      } else if (response.statusCode == 404) {
        debugPrint("User not found");
        return []; // ✅ return empty list
      } else {
        throw Exception("Failed to fetch user: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
      return []; // ✅ return empty list instead of UserEntity()
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    try {
      UserModel userModel = UserModel(name: user.name, avatar: user.avatar);
      debugPrint("PUT to: $baseUrl/$currentId");
      debugPrint("Body: ${jsonEncode(userModel.toJson())}");

      final response = await http.put(
        Uri.parse('$baseUrl/$currentId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userModel.toJson()),
      );

      if (response.statusCode == 200) {
        debugPrint("User updated successfully!");
      } else if (response.statusCode == 404) {
        debugPrint("User not found.");
      } else {
        debugPrint("Failed to update user: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Future<String> getCurrentID() async {
    final prefs = await SharedPreferences.getInstance();
    currentId = prefs.getString("currentId") ?? "";
    // debugPrint("Your Current id is $currentId");
    return currentId;
  }

  Future<void> setCurrentId(String id) async {
    currentId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("currentId", id);
  }

  @override
  Future<bool> isSignIn() async {
    String id = await getCurrentID(); // ✅ reuse getCurrentId
    debugPrint("Are we SignIn or Not? ${id.isNotEmpty} and currentId is $id");
    return id.isNotEmpty;
  }

  @override
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("currentId");
    debugPrint("User Loged Out");
  }

  @override
  Future<bool> verifyUser(String name) {
    // TODO: implement verifyUser
    throw UnimplementedError();
  }
}

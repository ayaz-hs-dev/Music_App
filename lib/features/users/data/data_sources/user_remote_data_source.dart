import 'package:music_app/features/users/domain/entities/user_entity.dart';

abstract class UserRemoteDataSource {
  // * Credintial
  Future<String> getCurrentID();
  Future<bool> isSignIn();
  Future<bool> verifyUser(String name);
  Future<void> signInWithUserName(String name);
  Future<void> signOut();

  // * User
  Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
  Future<void> deleteUser(String id);
  Future<UserEntity> getSingleUser(String id);
  Future<List<UserEntity>> getUsers();
}

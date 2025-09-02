import 'package:music_app/features/users/data/data_sources/user_remote_data_source.dart';
import 'package:music_app/features/users/domain/entities/user_entity.dart';
import 'package:music_app/features/users/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});
  @override
  Future<void> createUser(UserEntity user) async =>
      remoteDataSource.createUser(user);

  @override
  Future<void> deleteUser(String id) async => remoteDataSource.deleteUser(id);

  @override
  Future<String> getCurrentID() async => remoteDataSource.getCurrentID();

  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  @override
  Future<void> signInWithUserName(String name) async =>
      remoteDataSource.signInWithUserName(name);

  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> updateUser(UserEntity user) async =>
      remoteDataSource.updateUser(user);

  @override
  Future<bool> verifyUser(String name) async =>
      remoteDataSource.verifyUser(name);

  @override
  Future<UserEntity> getSingleUser(String id) =>
      remoteDataSource.getSingleUser(id);

  @override
  Future<List<UserEntity>> getUsers() async {
    return remoteDataSource.getUsers();
  }
}

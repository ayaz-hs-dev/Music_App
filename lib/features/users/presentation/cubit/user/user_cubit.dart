// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_app/features/users/domain/entities/user_entity.dart';
import 'package:music_app/features/users/domain/usecases/credinitial/get_current_id_usecase.dart';
import 'package:music_app/features/users/domain/usecases/credinitial/sign_in_with_user_name_usecase.dart';
import 'package:music_app/features/users/domain/usecases/user/create_user_usecase.dart';
import 'package:music_app/features/users/domain/usecases/user/delete_user_usecase.dart';
import 'package:music_app/features/users/domain/usecases/user/get_single_user_usecase.dart';
import 'package:music_app/features/users/domain/usecases/user/get_users_usecases.dart';
import 'package:music_app/features/users/domain/usecases/user/update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final CreateUserUseCase createUserUseCase;
  final SignInWithUserNameUseCase signInWithUserNameUseCase;
  final GetSingleUserUseCase getUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUsecase deleteUserUseCase;
  final GetCurrentIdUsecase getCurrentIdUsecase;
  final GetUsersUseCase getUsersUseCase;

  UserCubit({
    required this.createUserUseCase,
    required this.signInWithUserNameUseCase,
    required this.getUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
    required this.getCurrentIdUsecase,
    required this.getUsersUseCase,
  }) : super(UserInitial());

  Future<void> createUser(UserEntity user) async {
    emit(UserLoading());
    try {
      await createUserUseCase(user); // backend create

      // get the current ID from remote datasource
      final id = await getCurrentIdUsecase();

      if (id.isEmpty) {
        emit(UserError("Failed to get current ID"));
        return;
      }

      // fetch the full user from backend
      final createdUser = await getUserUseCase(id);

      emit(UserLoaded(createdUser)); // emit the actual user
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> signInWithUserName(String name) async {
    emit(UserLoading());
    try {
      await signInWithUserNameUseCase(name);
      final id = await getCurrentIdUsecase();
      if (id.isEmpty) {
        emit(UserError("Failed to get current ID after sign in"));
        return;
      }
      final user = await getUserUseCase(id);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError("Sign in failed: $e"));
    }
  }

  Future<UserEntity> getUser() async {
    emit(UserLoading());
    try {
      final id = await getCurrentIdUsecase();
      if (id.isEmpty) {
        emit(UserError("The id is empty"));
        return UserEntity();
      }
      final user = await getUserUseCase(id);
      emit(UserLoaded(user));
      return user;
    } catch (e) {
      emit(UserError(e.toString()));
      return UserEntity();
    }
  }

  Future<List<UserEntity>> getUsers() async {
    emit(UserLoading());
    try {
      final users = await getUsersUseCase();
      emit(UsersLoaded(users));
      return users;
    } catch (e) {
      emit(UserError(e.toString()));
      return [];
    }
  }

  Future<void> updateUser(UserEntity user) async {
    emit(UserLoading());
    try {
      await updateUserUseCase(user);
      emit(const UserSuccess("User updated successfully"));
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> deleteUser() async {
    emit(UserLoading());
    try {
      final id = await getCurrentIdUsecase();
      await deleteUserUseCase(id);
      emit(const UserSuccess("User deleted successfully"));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<String> getCurrentId() async {
    final id = await getCurrentIdUsecase();
    return id;
  }
}

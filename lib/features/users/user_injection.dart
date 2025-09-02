import 'package:music_app/features/users/data/data_sources/user_remote_data_source.dart';
import 'package:music_app/features/users/data/data_sources/user_remote_data_source_impl.dart';
import 'package:music_app/features/users/data/repository/user_repository_impl.dart';
import 'package:music_app/features/users/domain/repository/user_repository.dart';
import 'package:music_app/features/users/domain/usecases/credinitial/get_current_id_usecase.dart';
import 'package:music_app/features/users/domain/usecases/credinitial/is_sign_in_usecase.dart';
import 'package:music_app/features/users/domain/usecases/credinitial/sign_in_with_user_name_usecase.dart';
import 'package:music_app/features/users/domain/usecases/credinitial/sign_out_usecase.dart';
import 'package:music_app/features/users/domain/usecases/user/create_user_usecase.dart';
import 'package:music_app/features/users/domain/usecases/user/delete_user_usecase.dart';
import 'package:music_app/features/users/domain/usecases/user/get_single_user_usecase.dart';
import 'package:music_app/features/users/domain/usecases/user/get_users_usecases.dart';
import 'package:music_app/features/users/domain/usecases/user/update_user_usecase.dart';
import 'package:music_app/features/users/presentation/cubit/auth/auth_cubit.dart';
import 'package:music_app/features/users/presentation/cubit/user/user_cubit.dart';
import 'package:music_app/main_injection.dart';

Future<void> userInjection() async {
  // * CUBIT INJECTION

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      getCurrentidUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      signOutUseCase: sl.call(),
    ),
  );
  sl.registerFactory<UserCubit>(
    () => UserCubit(
      createUserUseCase: sl.call(),
      getUserUseCase: sl.call(),
      updateUserUseCase: sl.call(),
      deleteUserUseCase: sl.call(),
      getCurrentIdUsecase: sl.call(),
      signInWithUserNameUseCase: sl.call(),
      getUsersUseCase: sl.call(),
    ),
  );

  // * USE CASES INJECTION

  sl.registerLazySingleton<CreateUserUseCase>(
    () => CreateUserUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton<UpdateUserUseCase>(
    () => UpdateUserUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton<DeleteUserUsecase>(
    () => DeleteUserUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<GetSingleUserUseCase>(
    () => GetSingleUserUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton<GetCurrentIdUsecase>(
    () => GetCurrentIdUsecase(repository: sl.call()),
  );
  sl.registerLazySingleton<SignInWithUserNameUseCase>(
    () => SignInWithUserNameUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton<IsSignInUseCase>(
    () => IsSignInUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(repository: sl.call()),
  );

  // * REPOSITORY & DATA SOURCES INJECTION

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl.call()),
  );

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(),
  );
}

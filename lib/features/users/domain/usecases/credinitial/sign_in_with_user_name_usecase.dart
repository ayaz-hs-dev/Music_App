import 'package:music_app/features/users/domain/repository/user_repository.dart';

class SignInWithUserNameUseCase {
  final UserRepository repository;

  SignInWithUserNameUseCase({required this.repository});

  Future<void> call(String name) async {
    return repository.signInWithUserName(name);
  }
}

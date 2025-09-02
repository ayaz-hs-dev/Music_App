import 'package:music_app/features/users/domain/repository/user_repository.dart';

class VerifyUserUseCase {
  final UserRepository repository;

  VerifyUserUseCase({required this.repository});

  Future<bool> call(String name) async {
    return repository.verifyUser(name);
  }
}

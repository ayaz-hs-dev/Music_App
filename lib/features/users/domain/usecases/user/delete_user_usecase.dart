import 'package:music_app/features/users/domain/repository/user_repository.dart';

class DeleteUserUsecase {
  final UserRepository repository;

  DeleteUserUsecase({required this.repository});

  Future<void> call(String id) {
    return repository.deleteUser(id);
  }
}

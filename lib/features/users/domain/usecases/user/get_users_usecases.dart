import 'package:music_app/features/users/domain/entities/user_entity.dart';
import 'package:music_app/features/users/domain/repository/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase({required this.repository});

  Future<List<UserEntity>> call() {
    return repository.getUsers();
  }
}

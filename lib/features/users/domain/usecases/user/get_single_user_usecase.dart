import 'package:music_app/features/users/domain/entities/user_entity.dart';
import 'package:music_app/features/users/domain/repository/user_repository.dart';

class GetSingleUserUseCase {
  final UserRepository repository;

  GetSingleUserUseCase({required this.repository});

  Future<UserEntity> call(String id) {
    return repository.getSingleUser(id);
  }
}

import 'package:music_app/features/users/domain/repository/user_repository.dart';

class GetCurrentIdUsecase {
  final UserRepository repository;

  GetCurrentIdUsecase({required this.repository});
  Future<String> call() async {
    return repository.getCurrentID();
  }
}

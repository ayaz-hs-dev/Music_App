import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? name;

  final String? avatar;

  const UserEntity({this.id, this.name, this.avatar});

  @override
  List<Object?> get props => [id, name, avatar];
}

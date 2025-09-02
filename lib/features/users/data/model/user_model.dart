import 'package:music_app/features/users/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({super.id, required super.name, required super.avatar});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"], // MongoDB uses "_id"
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "avatar": avatar};
  }
}

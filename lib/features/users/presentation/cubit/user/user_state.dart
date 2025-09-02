part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();
}

final class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

/// ✅ Success for create/update/delete
class UserSuccess extends UserState {
  final String message;

  const UserSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

///  When a single user is fetched
class UserLoaded extends UserState {
  final UserEntity user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UsersLoaded extends UserState {
  final List<UserEntity> users;

  const UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

///  Error state
class UserError extends UserState {
  final String error;

  const UserError(this.error);

  @override
  List<Object?> get props => [error];
}

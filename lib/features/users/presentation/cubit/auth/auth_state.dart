part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  @override
  List<Object> get props => [];
}

class UnAuthenticated extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

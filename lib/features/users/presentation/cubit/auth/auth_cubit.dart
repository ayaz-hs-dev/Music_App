import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/features/users/domain/usecases/credinitial/get_current_id_usecase.dart';
import 'package:music_app/features/users/domain/usecases/credinitial/is_sign_in_usecase.dart';
import 'package:music_app/features/users/domain/usecases/credinitial/sign_out_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentIdUsecase getCurrentidUseCase;
  final IsSignInUseCase isSignInUseCase;
  final SignOutUseCase signOutUseCase;

  AuthCubit({
    required this.getCurrentidUseCase,
    required this.isSignInUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial());

  Future<void> appStarted() async {
    try {
      bool isSignIn = await isSignInUseCase.call();

      if (isSignIn) {
        emit(Authenticated());
      } else {
        emit(UnAuthenticated());
      }
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    try {
      await signOutUseCase.call();
      emit(UnAuthenticated());
    } catch (_) {
      emit(UnAuthenticated());
    }
  }
}

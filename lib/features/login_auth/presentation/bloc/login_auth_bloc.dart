import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_auth_event.dart';
import 'login_auth_state.dart';

class LoginAuthBloc extends Bloc<LoginAuthEvent, LoginAuthState> {
  LoginAuthBloc() : super(LoginPageIdleState()) {
    on<LoginClicked>(_onLoginClicked);
  }

  _onLoginClicked(LoginClicked event, Emitter<LoginAuthState> emit) {}
  // Stream<AuthState> mapEventToState(AuthEvent event) async* {
  //   switch (event) {
  //     case AuthEvent.login:
  //       yield AuthState(true);
  //       break;
  //     case AuthEvent.logout:
  //       yield AuthState(false);
  //       break;
  //   }
  // }
}

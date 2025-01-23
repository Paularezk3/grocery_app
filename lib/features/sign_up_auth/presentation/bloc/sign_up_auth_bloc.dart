import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_up_auth_event.dart';
import 'sign_up_auth_state.dart';

class SignUpAuthBloc extends Bloc<SignUpAuthEvent, SignUpAuthState> {
  SignUpAuthBloc() : super(SignUpIdleState()) {
    on<SignUpButtonClickedEvent>(_onSignUpButtonClickedEvent);
  }

  _onSignUpButtonClickedEvent(
      SignUpButtonClickedEvent event, Emitter<SignUpAuthState> emitter) {}
  // Stream<SignUpAuthState> mapEventToState(SignUpAuthEvent event) async* {
  //   switch (event) {
  //     case SignUpAuthEvent.login:
  //       yield SignUpAuthState(true);
  //       break;
  //     case SignUpAuthEvent.logout:
  //       yield SignUpAuthState(false);
  //       break;
  //   }
  // }
}

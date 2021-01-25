import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {

  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
            _userSubscription = _authenticationRepository.user.listen(
                  (user) => add(AuthenticationUserChanged(user)),
            );
        }

  final AuthenticationRepository _authenticationRepository;
  // Nos subscribimos ante cualquier cambio de estado del usuario
  StreamSubscription<User> _userSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticationUserChanged) {
      // Comprobamos en que ha cambiado el estado del usuario, y actuamos en consecuencia
      yield _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      unawaited(_authenticationRepository.logOut());
    }else if (event is AuthenticationDeleteAccountRequested) {
      unawaited(_authenticationRepository.deleteAccount());
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  AuthenticationState _mapAuthenticationUserChangedToState(AuthenticationUserChanged event) {
    return event.user != User.empty
        ? AuthenticationState.authenticated(event.user)
        : const AuthenticationState.unauthenticated();
  }
}
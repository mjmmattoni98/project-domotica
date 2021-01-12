part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.hub = Hub.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(Hub hub)
      : this._(status: AuthenticationStatus.authenticated, hub: hub);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final Hub hub;

  @override
  List<Object> get props => [status, hub];
}
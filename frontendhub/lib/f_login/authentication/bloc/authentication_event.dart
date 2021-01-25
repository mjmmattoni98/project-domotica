part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationUserChanged extends AuthenticationEvent {
  const AuthenticationUserChanged(this.hub);

  final Hub hub;

  @override
  List<Object> get props => [hub];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}

class AuthenticationDeleteAccountRequested extends AuthenticationEvent {}
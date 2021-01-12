part of 'dispositivos_bloc.dart';

abstract class DispositivosEvent extends Equatable {
  const DispositivosEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationUserChanged extends DispositivosEvent {
  const AuthenticationUserChanged(this.hub);

  final Hub hub;

  @override
  List<Object> get props => [hub];
}

class AuthenticationLogoutRequested extends DispositivosEvent {}
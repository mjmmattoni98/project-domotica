import 'dart:async';

import 'package:devices_repository/devices_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

part 'dispositivos_event.dart';
part 'dispositivos_state.dart';

class DispositivosBloc
    extends Bloc<DispositivosEvent, DispositivosState> {

  DispositivosBloc({
    @required DeviceRepository deviceRepository,
  })  : assert(deviceRepository != null),
        _deviceRepository = deviceRepository,
        super(const DispositivosState.unknown()) {
    _hubSubscription = _deviceRepository.hub.listen(
          (user) => add(AuthenticationUserChanged(user)),
    );
  }

  final DeviceRepository _deviceRepository;
  StreamSubscription<Hub> _hubSubscription;

  @override
  Stream<DispositivosState> mapEventToState(DispositivosEvent event) async* {
    if (event is AuthenticationUserChanged) {
      yield _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      unawaited(_deviceRepository.logOut());
    }
  }

  @override
  Future<void> close() {
    _hubSubscription?.cancel();
    return super.close();
  }

  DispositivosState _mapAuthenticationUserChangedToState(AuthenticationUserChanged event) {
    return event.hub != Hub.empty
        ? DispositivosState.authenticated(event.hub)
        : const DispositivosState.unauthenticated();
  }
}
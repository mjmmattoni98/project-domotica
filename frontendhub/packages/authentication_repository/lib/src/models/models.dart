import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template hub}
/// Hub model
///
/// [Hub.empty] represents an unauthenticated hub.
/// {@endtemplate}
class Hub extends Equatable {
  /// {@macro hub}
  const Hub({
    @required this.email,
    @required this.uid,
    @required this.consultas,
    @required this.name,
    @required this.estado,
    @required this.photo
  })  : assert(email != null),
        assert(uid != null);

  /// The current hub's email address.
  final String email;

  /// The current hub's id.
  final String uid;

  /// The current hub's name (display name).
  final String name;

  /// The current hub's inquiries.
  final int consultas;

  /// The current hub's state.
  final String estado;

  /// Url for the current hub's photo.
  final String photo;

  /// Empty hub which represents an unauthenticated hub.
  static const empty = Hub(email: '', uid: '', name: null, consultas: -1, estado: null, photo: null);

  @override
  List<Object> get props => [email, uid, consultas, name, estado, photo];
}
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class Hub extends Equatable {
  /// {@macro user}
  const Hub({
    @required this.email,
    @required this.id,
    @required this.consultas,
    @required this.name,
    @required this.estado,
    @required this.photo
  })  : assert(email != null),
        assert(id != null);

  /// The current user's email address.
  final String email;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String name;

  /// The current hub's inquiries.
  final int consultas;

  /// The current hub's state.
  final String estado;

  /// Url for the current user's photo.
  final String photo;

  /// Empty user which represents an unauthenticated user.
  static const empty = Hub(email: '', id: '', name: null, consultas: -1, estado: null, photo: null);

  @override
  List<Object> get props => [email, id, consultas, name, estado, photo];
}
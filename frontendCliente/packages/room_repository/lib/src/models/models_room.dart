import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:room_repository/src/models/models_device.dart';

class Room extends Equatable{

  final String id;
  final String nombre;
  final List<Device> dispositivos;

  const Room({
    @required this.id,
    @required this.nombre,
    @required this.dispositivos
  }) : assert(id != null),
    assert(nombre != null),
    assert(dispositivos != null);

  static const empty = Room(id: '', nombre: '', dispositivos: <Device>[]);

  @override
  // TODO: implement props
  List<Object> get props => [id, nombre, dispositivos];

  /*static Room fromSnapshot(DocumentSnapshot snapshot){
    return Room(
      snapshot.data['id'],
      snapshot.data['nombre'],
      snapshot.data().


    );
  }*/
}
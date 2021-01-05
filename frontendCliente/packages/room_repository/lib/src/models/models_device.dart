import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Device extends Equatable{

  final bool estado;
  final String habitacionAsignada;
  final String id;
  final String tipo;

  const Device({
    @required this.estado,
    @required this.tipo,
    @required this.habitacionAsignada,
    @required this.id
  }) : assert(id != null),
  assert(estado != null),
  assert(tipo != null),
  assert(habitacionAsignada != null);

  static const empty = Device(id: '', tipo: '', habitacionAsignada: "", estado: false);


  @override
  // TODO: implement props
  List<Object> get props => [id, tipo, habitacionAsignada, estado];

}
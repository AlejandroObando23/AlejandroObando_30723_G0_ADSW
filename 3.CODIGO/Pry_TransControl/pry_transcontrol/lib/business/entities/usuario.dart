import 'package:equatable/equatable.dart';

enum RolUsuario { administrador, coordinador, secretaria, transportista }

class Usuario extends Equatable {
  final String id;
  final String nombres;
  final String apellidos;
  final String correo;
  final String telefono;
  final String cedula;
  final RolUsuario rol;
  final DateTime fechaRegistro;
  final bool activo;

  const Usuario({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.telefono,
    required this.cedula,
    required this.rol,
    required this.fechaRegistro,
    this.activo = true,
  });

  String get nombreCompleto => '$nombres $apellidos';

  Usuario copyWith({
    String? id,
    String? nombres,
    String? apellidos,
    String? correo,
    String? telefono,
    String? cedula,
    RolUsuario? rol,
    DateTime? fechaRegistro,
    bool? activo,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
      cedula: cedula ?? this.cedula,
      rol: rol ?? this.rol,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      activo: activo ?? this.activo,
    );
  }

  @override
  List<Object?> get props => [
    id,
    nombres,
    apellidos,
    correo,
    telefono,
    cedula,
    rol,
    fechaRegistro,
    activo,
  ];
}

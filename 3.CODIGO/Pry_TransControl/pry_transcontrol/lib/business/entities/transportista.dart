import 'package:equatable/equatable.dart';
import 'vehiculo.dart';

enum EstadoTransportista { activo, inactivo, suspendido }

class Transportista extends Equatable {
  final String id;
  final String nombres;
  final String apellidos;
  final String cedula;
  final String telefono;
  final String correo;
  final String numeroLicencia;
  final DateTime? fechaVencimientoLicencia;
  final Vehiculo vehiculo;
  final EstadoTransportista estado;
  final DateTime fechaRegistro;
  final String usuarioId;

  const Transportista({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.cedula,
    required this.telefono,
    required this.correo,
    required this.numeroLicencia,
    this.fechaVencimientoLicencia,
    required this.vehiculo,
    this.estado = EstadoTransportista.activo,
    required this.fechaRegistro,
    required this.usuarioId,
  });

  String get nombreCompleto => '$nombres $apellidos';

  bool get licenciaVigente {
    if (fechaVencimientoLicencia == null) return true;
    return fechaVencimientoLicencia!.isAfter(DateTime.now());
  }

  bool get puedeLaborar =>
      estado == EstadoTransportista.activo &&
      licenciaVigente &&
      vehiculo.documentosVigentes;

  Transportista copyWith({
    String? id,
    String? nombres,
    String? apellidos,
    String? cedula,
    String? telefono,
    String? correo,
    String? numeroLicencia,
    DateTime? fechaVencimientoLicencia,
    Vehiculo? vehiculo,
    EstadoTransportista? estado,
    DateTime? fechaRegistro,
    String? usuarioId,
  }) {
    return Transportista(
      id: id ?? this.id,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      cedula: cedula ?? this.cedula,
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
      numeroLicencia: numeroLicencia ?? this.numeroLicencia,
      fechaVencimientoLicencia:
          fechaVencimientoLicencia ?? this.fechaVencimientoLicencia,
      vehiculo: vehiculo ?? this.vehiculo,
      estado: estado ?? this.estado,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    nombres,
    apellidos,
    cedula,
    telefono,
    correo,
    numeroLicencia,
    fechaVencimientoLicencia,
    vehiculo,
    estado,
    fechaRegistro,
    usuarioId,
  ];
}

import 'package:equatable/equatable.dart';

enum TipoDocumento {
  licencia,
  tecnicomecanica,
  seguro,
  certificadoAfiliacion,
  declaracionImpuestos,
  otro,
}

enum EstadoDocumento { pendiente, aprobado, rechazado, vencido }

class Documento extends Equatable {
  final String id;
  final String nombre;
  final TipoDocumento tipo;
  final String propietarioId;
  final EstadoDocumento estado;
  final DateTime fechaCarga;
  final DateTime? fechaVencimiento;
  final String? archivoUrl;
  final String? observaciones;

  const Documento({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.propietarioId,
    this.estado = EstadoDocumento.pendiente,
    required this.fechaCarga,
    this.fechaVencimiento,
    this.archivoUrl,
    this.observaciones,
  });

  bool get esVencido {
    if (fechaVencimiento == null) return false;
    return fechaVencimiento!.isBefore(DateTime.now());
  }

  bool get esValido => estado == EstadoDocumento.aprobado && !esVencido;

  Documento copyWith({
    String? id,
    String? nombre,
    TipoDocumento? tipo,
    String? propietarioId,
    EstadoDocumento? estado,
    DateTime? fechaCarga,
    DateTime? fechaVencimiento,
    String? archivoUrl,
    String? observaciones,
  }) {
    return Documento(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      propietarioId: propietarioId ?? this.propietarioId,
      estado: estado ?? this.estado,
      fechaCarga: fechaCarga ?? this.fechaCarga,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      archivoUrl: archivoUrl ?? this.archivoUrl,
      observaciones: observaciones ?? this.observaciones,
    );
  }

  @override
  List<Object?> get props => [
    id,
    nombre,
    tipo,
    propietarioId,
    estado,
    fechaCarga,
    fechaVencimiento,
    archivoUrl,
    observaciones,
  ];
}

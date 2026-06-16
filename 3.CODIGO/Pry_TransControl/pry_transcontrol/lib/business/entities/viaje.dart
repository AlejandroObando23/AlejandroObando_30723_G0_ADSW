import 'package:equatable/equatable.dart';
import 'ruta.dart';

enum EstadoViaje {
  planificado,
  asignado,
  enTransito,
  completado,
  cancelado,
  reprogramado,
}

enum TipoCarga { alimentos, muebles, electrodomesticos, maquinaria, otro }

class Viaje extends Equatable {
  final String id;
  final String origen;
  final String destino;
  final TipoCarga tipoCarga;
  final double pesoCarga;
  final DateTime fechaSalida;
  final DateTime fechaLlegadaEstimada;
  final EstadoViaje estado;
  final Ruta ruta;
  final String? transportistaId;
  final String coordinadorId;
  final DateTime fechaCreacion;
  final DateTime? fechaAsignacion;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String? motivoCancelacion;
  final String? observaciones;

  const Viaje({
    required this.id,
    required this.origen,
    required this.destino,
    required this.tipoCarga,
    required this.pesoCarga,
    required this.fechaSalida,
    required this.fechaLlegadaEstimada,
    this.estado = EstadoViaje.planificado,
    required this.ruta,
    this.transportistaId,
    required this.coordinadorId,
    required this.fechaCreacion,
    this.fechaAsignacion,
    this.fechaInicio,
    this.fechaFin,
    this.motivoCancelacion,
    this.observaciones,
  });

  bool get esAsignado => transportistaId != null;

  bool get puedeSerCancelado =>
      estado != EstadoViaje.completado && estado != EstadoViaje.cancelado;

  bool get puedeSerReprogramado =>
      estado == EstadoViaje.planificado || estado == EstadoViaje.asignado;

  Viaje copyWith({
    String? id,
    String? origen,
    String? destino,
    TipoCarga? tipoCarga,
    double? pesoCarga,
    DateTime? fechaSalida,
    DateTime? fechaLlegadaEstimada,
    EstadoViaje? estado,
    Ruta? ruta,
    String? transportistaId,
    String? coordinadorId,
    DateTime? fechaCreacion,
    DateTime? fechaAsignacion,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? motivoCancelacion,
    String? observaciones,
  }) {
    return Viaje(
      id: id ?? this.id,
      origen: origen ?? this.origen,
      destino: destino ?? this.destino,
      tipoCarga: tipoCarga ?? this.tipoCarga,
      pesoCarga: pesoCarga ?? this.pesoCarga,
      fechaSalida: fechaSalida ?? this.fechaSalida,
      fechaLlegadaEstimada: fechaLlegadaEstimada ?? this.fechaLlegadaEstimada,
      estado: estado ?? this.estado,
      ruta: ruta ?? this.ruta,
      transportistaId: transportistaId ?? this.transportistaId,
      coordinadorId: coordinadorId ?? this.coordinadorId,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaAsignacion: fechaAsignacion ?? this.fechaAsignacion,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      motivoCancelacion: motivoCancelacion ?? this.motivoCancelacion,
      observaciones: observaciones ?? this.observaciones,
    );
  }

  @override
  List<Object?> get props => [
    id,
    origen,
    destino,
    tipoCarga,
    pesoCarga,
    fechaSalida,
    fechaLlegadaEstimada,
    estado,
    ruta,
    transportistaId,
    coordinadorId,
    fechaCreacion,
    fechaAsignacion,
    fechaInicio,
    fechaFin,
    motivoCancelacion,
    observaciones,
  ];
}

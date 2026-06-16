import 'package:equatable/equatable.dart';

enum TipoNotificacion {
  viajeCreadoViajeReprogramadoViajeCancelado,
  documentoVencido,
  desvioRuta,
  transportistaCreado,
  avisoImportante,
  otro,
}

class Notificacion extends Equatable {
  final String id;
  final String titulo;
  final String mensaje;
  final TipoNotificacion tipo;
  final String? relatedId;
  final String usuarioId;
  final DateTime fechaCreacion;
  final bool leida;
  final String? accion;

  const Notificacion({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    this.relatedId,
    required this.usuarioId,
    required this.fechaCreacion,
    this.leida = false,
    this.accion,
  });

  Notificacion copyWith({
    String? id,
    String? titulo,
    String? mensaje,
    TipoNotificacion? tipo,
    String? relatedId,
    String? usuarioId,
    DateTime? fechaCreacion,
    bool? leida,
    String? accion,
  }) {
    return Notificacion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      mensaje: mensaje ?? this.mensaje,
      tipo: tipo ?? this.tipo,
      relatedId: relatedId ?? this.relatedId,
      usuarioId: usuarioId ?? this.usuarioId,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      leida: leida ?? this.leida,
      accion: accion ?? this.accion,
    );
  }

  @override
  List<Object?> get props => [
    id,
    titulo,
    mensaje,
    tipo,
    relatedId,
    usuarioId,
    fechaCreacion,
    leida,
    accion,
  ];
}

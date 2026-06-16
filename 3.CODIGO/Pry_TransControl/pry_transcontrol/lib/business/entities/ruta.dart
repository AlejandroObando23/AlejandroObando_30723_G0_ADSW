import 'package:equatable/equatable.dart';

class Coordenada extends Equatable {
  final double latitud;
  final double longitud;

  const Coordenada({required this.latitud, required this.longitud});

  @override
  List<Object?> get props => [latitud, longitud];
}

class Ruta extends Equatable {
  final String id;
  final String origen;
  final String destino;
  final Coordenada coordenadaOrigen;
  final Coordenada coordenadaDestino;
  final List<Coordenada> puntosClave;
  final double distanciaKm;
  final int tiempoEstimadoMinutos;
  final bool esSegura;

  const Ruta({
    required this.id,
    required this.origen,
    required this.destino,
    required this.coordenadaOrigen,
    required this.coordenadaDestino,
    this.puntosClave = const [],
    required this.distanciaKm,
    required this.tiempoEstimadoMinutos,
    this.esSegura = true,
  });

  Ruta copyWith({
    String? id,
    String? origen,
    String? destino,
    Coordenada? coordenadaOrigen,
    Coordenada? coordenadaDestino,
    List<Coordenada>? puntosClave,
    double? distanciaKm,
    int? tiempoEstimadoMinutos,
    bool? esSegura,
  }) {
    return Ruta(
      id: id ?? this.id,
      origen: origen ?? this.origen,
      destino: destino ?? this.destino,
      coordenadaOrigen: coordenadaOrigen ?? this.coordenadaOrigen,
      coordenadaDestino: coordenadaDestino ?? this.coordenadaDestino,
      puntosClave: puntosClave ?? this.puntosClave,
      distanciaKm: distanciaKm ?? this.distanciaKm,
      tiempoEstimadoMinutos:
          tiempoEstimadoMinutos ?? this.tiempoEstimadoMinutos,
      esSegura: esSegura ?? this.esSegura,
    );
  }

  @override
  List<Object?> get props => [
    id,
    origen,
    destino,
    coordenadaOrigen,
    coordenadaDestino,
    puntosClave,
    distanciaKm,
    tiempoEstimadoMinutos,
    esSegura,
  ];
}

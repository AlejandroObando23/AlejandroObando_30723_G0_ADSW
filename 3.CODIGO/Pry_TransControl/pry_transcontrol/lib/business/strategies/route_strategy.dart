import '../entities/ruta.dart';

/// Interfaz para la estrategia de cálculo de rutas
abstract class RouteStrategy {
  /// Calcula una ruta basada en la estrategia implementada
  Ruta calcularRuta(
    String origen,
    String destino,
    Coordenada coordenadaOrigen,
    Coordenada coordenadaDestino,
  );
}

/// Estrategia: Ruta más rápida
class RutaMasRapidaStrategy implements RouteStrategy {
  @override
  Ruta calcularRuta(
    String origen,
    String destino,
    Coordenada coordenadaOrigen,
    Coordenada coordenadaDestino,
  ) {
    // Simular cálculo de ruta más rápida
    const distancia = 120.0;
    const tiempoEstimado = 120; // 2 horas

    return Ruta(
      id: 'ruta_${DateTime.now().millisecondsSinceEpoch}',
      origen: origen,
      destino: destino,
      coordenadaOrigen: coordenadaOrigen,
      coordenadaDestino: coordenadaDestino,
      distanciaKm: distancia,
      tiempoEstimadoMinutos: tiempoEstimado,
      esSegura: true,
      puntosClave: [
        Coordenada(latitud: 4.7110, longitud: -74.0721), // Bogotá
        Coordenada(latitud: 5.0267, longitud: -74.0891), // Intermedio
      ],
    );
  }
}

/// Estrategia: Ruta más segura
class RutaMasSeguraStrategy implements RouteStrategy {
  @override
  Ruta calcularRuta(
    String origen,
    String destino,
    Coordenada coordenadaOrigen,
    Coordenada coordenadaDestino,
  ) {
    // Simular cálculo de ruta más segura (puede ser más larga)
    const distancia = 150.0;
    const tiempoEstimado = 180; // 3 horas

    return Ruta(
      id: 'ruta_${DateTime.now().millisecondsSinceEpoch}',
      origen: origen,
      destino: destino,
      coordenadaOrigen: coordenadaOrigen,
      coordenadaDestino: coordenadaDestino,
      distanciaKm: distancia,
      tiempoEstimadoMinutos: tiempoEstimado,
      esSegura: true,
      puntosClave: [
        Coordenada(latitud: 4.7110, longitud: -74.0721), // Bogotá
        Coordenada(latitud: 4.8090, longitud: -74.0151), // Intermedio seguro
        Coordenada(latitud: 5.0267, longitud: -74.0891), // Destino
      ],
    );
  }
}

/// Estrategia: Ruta con menor distancia
class RutaMenorDistanciaStrategy implements RouteStrategy {
  @override
  Ruta calcularRuta(
    String origen,
    String destino,
    Coordenada coordenadaOrigen,
    Coordenada coordenadaDestino,
  ) {
    // Simular cálculo de ruta con menor distancia
    const distancia = 110.0;
    const tiempoEstimado = 140; // 2:20 horas

    return Ruta(
      id: 'ruta_${DateTime.now().millisecondsSinceEpoch}',
      origen: origen,
      destino: destino,
      coordenadaOrigen: coordenadaOrigen,
      coordenadaDestino: coordenadaDestino,
      distanciaKm: distancia,
      tiempoEstimadoMinutos: tiempoEstimado,
      esSegura: false,
      puntosClave: [
        Coordenada(latitud: 4.7110, longitud: -74.0721), // Bogotá
      ],
    );
  }
}

/// Contexto para usar las estrategias
class RutaCalculadora {
  late RouteStrategy _estrategia;

  RutaCalculadora({RouteStrategy estrategia = const _DefaultRouteStrategy()})
    : _estrategia = estrategia;

  void setEstrategia(RouteStrategy estrategia) {
    _estrategia = estrategia;
  }

  Ruta calcular(
    String origen,
    String destino,
    Coordenada coordenadaOrigen,
    Coordenada coordenadaDestino,
  ) {
    return _estrategia.calcularRuta(
      origen,
      destino,
      coordenadaOrigen,
      coordenadaDestino,
    );
  }
}

/// Estrategia por defecto (ruta más rápida)
class _DefaultRouteStrategy implements RouteStrategy {
  const _DefaultRouteStrategy();

  @override
  Ruta calcularRuta(
    String origen,
    String destino,
    Coordenada coordenadaOrigen,
    Coordenada coordenadaDestino,
  ) {
    return RutaMasRapidaStrategy().calcularRuta(
      origen,
      destino,
      coordenadaOrigen,
      coordenadaDestino,
    );
  }
}

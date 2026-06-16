import '../entities/viaje.dart';
import '../entities/ruta.dart';
import '../observers/travel_observer.dart';
import '../strategies/route_strategy.dart';
import '../../data/repositories/viaje_repository.dart';

class CrearViajeUseCase {
  final ViajeRepository repository;
  final ViajeSubject subject;

  CrearViajeUseCase(this.repository, this.subject);

  Future<bool> call(Viaje viaje) async {
    final resultado = await repository.crear(viaje);
    if (resultado) {
      subject.notificarViajeCreadod(
        viajeId: viaje.id,
        origen: viaje.origen,
        destino: viaje.destino,
        fechaSalida: viaje.fechaSalida,
      );
    }
    return resultado;
  }
}

class AsignarTransportistaAViajeUseCase {
  final ViajeRepository repository;
  final ViajeSubject subject;

  AsignarTransportistaAViajeUseCase(this.repository, this.subject);

  Future<bool> call(String viajeId, String transportistaId) async {
    return await repository.asignarTransportista(viajeId, transportistaId);
  }
}

class ReprogramarViajeUseCase {
  final ViajeRepository repository;
  final ViajeSubject subject;

  ReprogramarViajeUseCase(this.repository, this.subject);

  Future<bool> call(String viajeId, DateTime nuevaFecha) async {
    final resultado = await repository.reprogramar(viajeId, nuevaFecha);
    if (resultado) {
      subject.notificarViajeReprogramado(
        viajeId: viajeId,
        nuevaFechaSalida: nuevaFecha,
        razon: 'Reprogramación solicitada',
      );
    }
    return resultado;
  }
}

class CancelarViajeUseCase {
  final ViajeRepository repository;
  final ViajeSubject subject;

  CancelarViajeUseCase(this.repository, this.subject);

  Future<bool> call(String viajeId, String motivo) async {
    final resultado = await repository.cancelar(viajeId, motivo);
    if (resultado) {
      subject.notificarViajeCancelado(viajeId: viajeId, motivo: motivo);
    }
    return resultado;
  }
}

class ObtenerViajesPorCoordinadorUseCase {
  final ViajeRepository repository;

  ObtenerViajesPorCoordinadorUseCase(this.repository);

  Future<List<Viaje>> call(String coordinadorId) async {
    return await repository.obtenerPorCoordinador(coordinadorId);
  }
}

class ObtenerViajesPorTransportistaUseCase {
  final ViajeRepository repository;

  ObtenerViajesPorTransportistaUseCase(this.repository);

  Future<List<Viaje>> call(String transportistaId) async {
    return await repository.obtenerPorTransportista(transportistaId);
  }
}

class ObtenerViajesPorEstadoUseCase {
  final ViajeRepository repository;

  ObtenerViajesPorEstadoUseCase(this.repository);

  Future<List<Viaje>> call(EstadoViaje estado) async {
    return await repository.obtenerPorEstado(estado);
  }
}

class CalcularRutaViajeUseCase {
  final RutaCalculadora calculadora;

  CalcularRutaViajeUseCase({
    RouteStrategy estrategia = const _DefaultRouteStrategy(),
  }) : calculadora = RutaCalculadora(estrategia: estrategia);

  void setEstrategia(RouteStrategy estrategia) {
    calculadora.setEstrategia(estrategia);
  }

  Ruta call(
    String origen,
    String destino,
    Coordenada coordenadaOrigen,
    Coordenada coordenadaDestino,
  ) {
    return calculadora.calcular(
      origen,
      destino,
      coordenadaOrigen,
      coordenadaDestino,
    );
  }
}

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

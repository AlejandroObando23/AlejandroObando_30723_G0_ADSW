import '../entities/notificacion.dart';

/// Observador para eventos importantes del sistema
abstract class TravelObserver {
  void update(String evento, Map<String, dynamic> datos);
}

/// Observador: Coordinador
class CoordinadorObserver implements TravelObserver {
  final String coordinadorId;

  CoordinadorObserver({required this.coordinadorId});

  @override
  void update(String evento, Map<String, dynamic> datos) {
    print(
      'CoordinadorObserver: Evento "$evento" notificado al coordinador $coordinadorId',
    );
    print('Datos: $datos');
  }
}

/// Observador: Secretaria
class SecretariaObserver implements TravelObserver {
  final String secretariaId;

  SecretariaObserver({required this.secretariaId});

  @override
  void update(String evento, Map<String, dynamic> datos) {
    print(
      'SecretariaObserver: Evento "$evento" notificado a la secretaria $secretariaId',
    );
    print('Datos: $datos');
  }
}

/// Observador: Transportista
class TransportistaObserver implements TravelObserver {
  final String transportistaId;

  TransportistaObserver({required this.transportistaId});

  @override
  void update(String evento, Map<String, dynamic> datos) {
    print(
      'TransportistaObserver: Evento "$evento" notificado al transportista $transportistaId',
    );
    print('Datos: $datos');
  }
}

/// Subject: Viaje - Emite eventos observables
class ViajeSubject {
  final List<TravelObserver> _observadores = [];

  /// Registrar un observador
  void registrarObservador(TravelObserver observador) {
    if (!_observadores.contains(observador)) {
      _observadores.add(observador);
    }
  }

  /// Desregistrar un observador
  void desregistrarObservador(TravelObserver observador) {
    _observadores.remove(observador);
  }

  /// Notificar a todos los observadores
  void notifyObservers(String evento, Map<String, dynamic> datos) {
    for (var observador in _observadores) {
      observador.update(evento, datos);
    }
  }

  /// Evento: Viaje creado
  void notificarViajeCreadod({
    required String viajeId,
    required String origen,
    required String destino,
    required DateTime fechaSalida,
  }) {
    notifyObservers('viaje_creado', {
      'viajeId': viajeId,
      'origen': origen,
      'destino': destino,
      'fechaSalida': fechaSalida.toIso8601String(),
    });
  }

  /// Evento: Viaje reprogramado
  void notificarViajeReprogramado({
    required String viajeId,
    required DateTime nuevaFechaSalida,
    required String razon,
  }) {
    notifyObservers('viaje_reprogramado', {
      'viajeId': viajeId,
      'nuevaFechaSalida': nuevaFechaSalida.toIso8601String(),
      'razon': razon,
    });
  }

  /// Evento: Viaje cancelado
  void notificarViajeCancelado({
    required String viajeId,
    required String motivo,
  }) {
    notifyObservers('viaje_cancelado', {'viajeId': viajeId, 'motivo': motivo});
  }

  /// Evento: Documento vencido
  void notificarDocumentoVencido({
    required String documentoId,
    required String propietario,
    required String tipoDocumento,
  }) {
    notifyObservers('documento_vencido', {
      'documentoId': documentoId,
      'propietario': propietario,
      'tipoDocumento': tipoDocumento,
    });
  }

  /// Evento: Desvío de ruta
  void notificarDesvioRuta({
    required String viajeId,
    required String transportistaId,
    required double desvioKm,
  }) {
    notifyObservers('desvio_ruta', {
      'viajeId': viajeId,
      'transportistaId': transportistaId,
      'desvioKm': desvioKm,
    });
  }
}

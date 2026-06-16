import '../../business/entities/viaje.dart';
import '../../business/entities/ruta.dart';
import '../repositories/viaje_repository.dart';

class MockViajeRepository implements ViajeRepository {
  static final MockViajeRepository _instance = MockViajeRepository._internal();

  factory MockViajeRepository() {
    return _instance;
  }

  MockViajeRepository._internal() {
    _inicializarDatos();
  }

  late List<Viaje> _viajes;

  void _inicializarDatos() {
    _viajes = [
      Viaje(
        id: 'VIJ001',
        origen: 'Bogotá',
        destino: 'Medellín',
        tipoCarga: TipoCarga.alimentos,
        pesoCarga: 15.5,
        fechaSalida: DateTime(2026, 6, 15, 6, 0),
        fechaLlegadaEstimada: DateTime(2026, 6, 15, 12, 0),
        estado: EstadoViaje.planificado,
        ruta: Ruta(
          id: 'RUTA001',
          origen: 'Bogotá',
          destino: 'Medellín',
          coordenadaOrigen: const Coordenada(
            latitud: 4.7110,
            longitud: -74.0721,
          ),
          coordenadaDestino: const Coordenada(
            latitud: 6.2442,
            longitud: -75.5812,
          ),
          distanciaKm: 420.0,
          tiempoEstimadoMinutos: 360,
          esSegura: true,
        ),
        coordinadorId: 'USR002',
        fechaCreacion: DateTime(2026, 6, 10),
      ),
      Viaje(
        id: 'VIJ002',
        origen: 'Cali',
        destino: 'Bogotá',
        tipoCarga: TipoCarga.electrodomesticos,
        pesoCarga: 22.0,
        fechaSalida: DateTime(2026, 6, 16, 8, 0),
        fechaLlegadaEstimada: DateTime(2026, 6, 17, 8, 0),
        estado: EstadoViaje.asignado,
        transportistaId: 'TRAN001',
        ruta: Ruta(
          id: 'RUTA002',
          origen: 'Cali',
          destino: 'Bogotá',
          coordenadaOrigen: const Coordenada(
            latitud: 3.4372,
            longitud: -76.5197,
          ),
          coordenadaDestino: const Coordenada(
            latitud: 4.7110,
            longitud: -74.0721,
          ),
          distanciaKm: 510.0,
          tiempoEstimadoMinutos: 480,
          esSegura: true,
        ),
        coordinadorId: 'USR002',
        fechaCreacion: DateTime(2026, 6, 12),
        fechaAsignacion: DateTime(2026, 6, 13),
      ),
      Viaje(
        id: 'VIJ003',
        origen: 'Bucaramanga',
        destino: 'Cartagena',
        tipoCarga: TipoCarga.maquinaria,
        pesoCarga: 28.0,
        fechaSalida: DateTime(2026, 6, 20, 10, 0),
        fechaLlegadaEstimada: DateTime(2026, 6, 21, 16, 0),
        estado: EstadoViaje.enTransito,
        transportistaId: 'TRAN002',
        ruta: Ruta(
          id: 'RUTA003',
          origen: 'Bucaramanga',
          destino: 'Cartagena',
          coordenadaOrigen: const Coordenada(
            latitud: 7.1300,
            longitud: -73.1198,
          ),
          coordenadaDestino: const Coordenada(
            latitud: 10.3888,
            longitud: -75.5136,
          ),
          distanciaKm: 680.0,
          tiempoEstimadoMinutos: 600,
          esSegura: false,
        ),
        coordinadorId: 'USR002',
        fechaCreacion: DateTime(2026, 6, 8),
        fechaAsignacion: DateTime(2026, 6, 10),
        fechaInicio: DateTime(2026, 6, 20, 10, 15),
      ),
    ];
  }

  @override
  Future<Viaje?> buscarPorId(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _viajes.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> crear(Viaje viaje) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_viajes.any((v) => v.id == viaje.id)) {
      return false;
    }
    _viajes.add(viaje);
    return true;
  }

  @override
  Future<bool> actualizar(Viaje viaje) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _viajes.indexWhere((v) => v.id == viaje.id);
    if (index == -1) return false;
    _viajes[index] = viaje;
    return true;
  }

  @override
  Future<bool> asignarTransportista(
    String viajeId,
    String transportistaId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _viajes.indexWhere((v) => v.id == viajeId);
    if (index == -1) return false;

    final viaje = _viajes[index];
    _viajes[index] = viaje.copyWith(
      transportistaId: transportistaId,
      estado: EstadoViaje.asignado,
      fechaAsignacion: DateTime.now(),
    );
    return true;
  }

  @override
  Future<bool> reprogramar(String viajeId, DateTime nuevaFecha) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _viajes.indexWhere((v) => v.id == viajeId);
    if (index == -1) return false;

    final viaje = _viajes[index];
    final duracion = viaje.fechaLlegadaEstimada.difference(viaje.fechaSalida);
    _viajes[index] = viaje.copyWith(
      fechaSalida: nuevaFecha,
      fechaLlegadaEstimada: nuevaFecha.add(duracion),
      estado: EstadoViaje.reprogramado,
    );
    return true;
  }

  @override
  Future<bool> cancelar(String viajeId, String motivo) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _viajes.indexWhere((v) => v.id == viajeId);
    if (index == -1) return false;

    final viaje = _viajes[index];
    _viajes[index] = viaje.copyWith(
      estado: EstadoViaje.cancelado,
      motivoCancelacion: motivo,
    );
    return true;
  }

  @override
  Future<List<Viaje>> obtenerTodos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_viajes);
  }

  @override
  Future<List<Viaje>> obtenerPorEstado(EstadoViaje estado) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _viajes.where((v) => v.estado == estado).toList();
  }

  @override
  Future<List<Viaje>> obtenerPorTransportista(String transportistaId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _viajes.where((v) => v.transportistaId == transportistaId).toList();
  }

  @override
  Future<List<Viaje>> obtenerPorCoordinador(String coordinadorId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _viajes.where((v) => v.coordinadorId == coordinadorId).toList();
  }
}

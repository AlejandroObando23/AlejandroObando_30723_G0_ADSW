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
        origen: 'Quito',
        destino: 'Guayaquil',
        tipoCarga: TipoCarga.alimentos,
        pesoCarga: 15.5,
        fechaSalida: DateTime(2026, 6, 15, 6, 0),
        fechaLlegadaEstimada: DateTime(2026, 6, 15, 12, 0),
        estado: EstadoViaje.planificado,
        ruta: Ruta(
          id: 'RUTA001',
          origen: 'Quito',
          destino: 'Guayaquil',
          coordenadaOrigen: const Coordenada(
            latitud: -0.2295,
            longitud: -78.5243,
          ),
          coordenadaDestino: const Coordenada(
            latitud: -2.1962,
            longitud: -79.8862,
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
        origen: 'Cuenca',
        destino: 'Quito',
        tipoCarga: TipoCarga.electrodomesticos,
        pesoCarga: 22.0,
        fechaSalida: DateTime(2026, 6, 16, 8, 0),
        fechaLlegadaEstimada: DateTime(2026, 6, 17, 8, 0),
        estado: EstadoViaje.asignado,
        transportistaId: 'TRAN001',
        ruta: Ruta(
          id: 'RUTA002',
          origen: 'Cuenca',
          destino: 'Quito',
          coordenadaOrigen: const Coordenada(
            latitud: -2.9001,
            longitud: -79.0059,
          ),
          coordenadaDestino: const Coordenada(
            latitud: -0.2295,
            longitud: -78.5243,
          ),
          distanciaKm: 480.0,
          tiempoEstimadoMinutos: 480,
          esSegura: true,
        ),
        coordinadorId: 'USR002',
        fechaCreacion: DateTime(2026, 6, 12),
        fechaAsignacion: DateTime(2026, 6, 13),
      ),
      Viaje(
        id: 'VIJ003',
        origen: 'Ambato',
        destino: 'Manta',
        tipoCarga: TipoCarga.maquinaria,
        pesoCarga: 28.0,
        fechaSalida: DateTime(2026, 6, 20, 10, 0),
        fechaLlegadaEstimada: DateTime(2026, 6, 21, 16, 0),
        estado: EstadoViaje.enTransito,
        transportistaId: 'TRAN002',
        ruta: Ruta(
          id: 'RUTA003',
          origen: 'Ambato',
          destino: 'Manta',
          coordenadaOrigen: const Coordenada(
            latitud: -1.2491,
            longitud: -78.6168,
          ),
          coordenadaDestino: const Coordenada(
            latitud: -0.9677,
            longitud: -80.7089,
          ),
          distanciaKm: 310.0,
          tiempoEstimadoMinutos: 300,
          esSegura: true,
        ),
        coordinadorId: 'USR002',
        fechaCreacion: DateTime(2026, 6, 8),
        fechaAsignacion: DateTime(2026, 6, 10),
        fechaInicio: DateTime(2026, 6, 20, 10, 15),
      ),
      Viaje(
        id: 'VIJ004',
        origen: 'Guayaquil',
        destino: 'Loja',
        tipoCarga: TipoCarga.muebles,
        pesoCarga: 18.0,
        fechaSalida: DateTime(2026, 6, 22, 7, 0),
        fechaLlegadaEstimada: DateTime(2026, 6, 22, 19, 0),
        estado: EstadoViaje.completado,
        transportistaId: 'TRAN001',
        ruta: Ruta(
          id: 'RUTA004',
          origen: 'Guayaquil',
          destino: 'Loja',
          coordenadaOrigen: const Coordenada(
            latitud: -2.1962,
            longitud: -79.8862,
          ),
          coordenadaDestino: const Coordenada(
            latitud: -3.9931,
            longitud: -79.2042,
          ),
          distanciaKm: 350.0,
          tiempoEstimadoMinutos: 420,
          esSegura: true,
        ),
        coordinadorId: 'USR002',
        fechaCreacion: DateTime(2026, 6, 5),
        fechaAsignacion: DateTime(2026, 6, 6),
        fechaInicio: DateTime(2026, 6, 22, 7, 10),
        fechaFin: DateTime(2026, 6, 22, 18, 50),
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

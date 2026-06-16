import '../../business/entities/transportista.dart';
import '../../business/entities/vehiculo.dart';
import '../repositories/transportista_repository.dart';

class MockTransportistaRepository implements TransportistaRepository {
  static final MockTransportistaRepository _instance =
      MockTransportistaRepository._internal();

  factory MockTransportistaRepository() {
    return _instance;
  }

  MockTransportistaRepository._internal() {
    _inicializarDatos();
  }

  late List<Transportista> _transportistas;

  void _inicializarDatos() {
    _transportistas = [
      Transportista(
        id: 'TRAN001',
        nombres: 'Pedro',
        apellidos: 'Gómez',
        cedula: '1098765432',
        telefono: '3019876543',
        correo: 'pedro.gomez@email.com',
        numeroLicencia: 'LIC001',
        fechaVencimientoLicencia: DateTime(2025, 12, 31),
        vehiculo: Vehiculo(
          id: 'VEH001',
          placa: 'ABC123',
          tipo: TipoVehiculo.camion,
          marca: 'Volvo',
          modelo: 'FH16',
          year: 2020,
          capacidadToneladas: 25.0,
          numeroMotor: 'MOT001',
          numeroChasis: 'CHA001',
          fechaVencimientoTecnicomecanica: DateTime(2025, 6, 30),
          fechaVencimientoSeguro: DateTime(2025, 3, 31),
        ),
        estado: EstadoTransportista.activo,
        fechaRegistro: DateTime(2024, 1, 15),
        usuarioId: 'USR004',
      ),
      Transportista(
        id: 'TRAN002',
        nombres: 'Juan',
        apellidos: 'Rodríguez',
        cedula: '1087654321',
        telefono: '3008765432',
        correo: 'juan.rodriguez@email.com',
        numeroLicencia: 'LIC002',
        fechaVencimientoLicencia: DateTime(2026, 6, 30),
        vehiculo: Vehiculo(
          id: 'VEH002',
          placa: 'DEF456',
          tipo: TipoVehiculo.tractomula,
          marca: 'Scania',
          modelo: 'R440',
          year: 2019,
          capacidadToneladas: 30.0,
          numeroMotor: 'MOT002',
          numeroChasis: 'CHA002',
          fechaVencimientoTecnicomecanica: DateTime(2025, 9, 15),
          fechaVencimientoSeguro: DateTime(2025, 5, 31),
        ),
        estado: EstadoTransportista.activo,
        fechaRegistro: DateTime(2024, 2, 10),
        usuarioId: 'USR004',
      ),
      Transportista(
        id: 'TRAN003',
        nombres: 'Ana',
        apellidos: 'Martínez',
        cedula: '1076543210',
        telefono: '3007654321',
        correo: 'ana.martinez@email.com',
        numeroLicencia: 'LIC003',
        fechaVencimientoLicencia: DateTime(2024, 8, 15),
        vehiculo: Vehiculo(
          id: 'VEH003',
          placa: 'GHI789',
          tipo: TipoVehiculo.camion,
          marca: 'MAN',
          modelo: 'TGX',
          year: 2018,
          capacidadToneladas: 20.0,
          numeroMotor: 'MOT003',
          numeroChasis: 'CHA003',
        ),
        estado: EstadoTransportista.suspendido,
        fechaRegistro: DateTime(2024, 3, 20),
        usuarioId: 'USR004',
      ),
    ];
  }

  @override
  Future<Transportista?> buscarPorId(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _transportistas.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> crear(Transportista transportista) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_transportistas.any((t) => t.id == transportista.id)) {
      return false;
    }
    _transportistas.add(transportista);
    return true;
  }

  @override
  Future<bool> actualizar(Transportista transportista) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _transportistas.indexWhere((t) => t.id == transportista.id);
    if (index == -1) return false;
    _transportistas[index] = transportista;
    return true;
  }

  @override
  Future<bool> eliminar(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _transportistas.indexWhere((t) => t.id == id);
    if (index == -1) return false;
    _transportistas.removeAt(index);
    return true;
  }

  @override
  Future<List<Transportista>> obtenerTodos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_transportistas);
  }

  @override
  Future<List<Transportista>> obtenerActivos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _transportistas
        .where((t) => t.estado == EstadoTransportista.activo)
        .toList();
  }

  @override
  Future<List<Transportista>> buscarPorEstado(
    EstadoTransportista estado,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _transportistas.where((t) => t.estado == estado).toList();
  }
}

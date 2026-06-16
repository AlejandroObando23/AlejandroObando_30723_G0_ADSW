import '../entities/transportista.dart';
import '../../data/repositories/transportista_repository.dart';

class CrearTransportistaUseCase {
  final TransportistaRepository repository;

  CrearTransportistaUseCase(this.repository);

  Future<bool> call(Transportista transportista) async {
    return await repository.crear(transportista);
  }
}

class ObtenerTransportistasPorIdUseCase {
  final TransportistaRepository repository;

  ObtenerTransportistasPorIdUseCase(this.repository);

  Future<Transportista?> call(String id) async {
    return await repository.buscarPorId(id);
  }
}

class ObtenerTransportistasActivosUseCase {
  final TransportistaRepository repository;

  ObtenerTransportistasActivosUseCase(this.repository);

  Future<List<Transportista>> call() async {
    return await repository.obtenerActivos();
  }
}

class ActualizarTransportistaUseCase {
  final TransportistaRepository repository;

  ActualizarTransportistaUseCase(this.repository);

  Future<bool> call(Transportista transportista) async {
    return await repository.actualizar(transportista);
  }
}

class EliminarTransportistaUseCase {
  final TransportistaRepository repository;

  EliminarTransportistaUseCase(this.repository);

  Future<bool> call(String id) async {
    return await repository.eliminar(id);
  }
}

class ObtenerTodosLosTransportistasUseCase {
  final TransportistaRepository repository;

  ObtenerTodosLosTransportistasUseCase(this.repository);

  Future<List<Transportista>> call() async {
    return await repository.obtenerTodos();
  }
}

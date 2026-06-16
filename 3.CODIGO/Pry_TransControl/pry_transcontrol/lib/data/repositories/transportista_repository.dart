import '../../business/entities/transportista.dart';

abstract class TransportistaRepository {
  Future<Transportista?> buscarPorId(String id);
  Future<List<Transportista>> obtenerTodos();
  Future<List<Transportista>> obtenerActivos();
  Future<bool> crear(Transportista transportista);
  Future<bool> actualizar(Transportista transportista);
  Future<bool> eliminar(String id);
  Future<List<Transportista>> buscarPorEstado(EstadoTransportista estado);
}

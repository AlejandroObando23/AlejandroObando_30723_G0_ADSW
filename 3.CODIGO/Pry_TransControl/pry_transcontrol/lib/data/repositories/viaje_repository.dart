import '../../business/entities/viaje.dart';

abstract class ViajeRepository {
  Future<Viaje?> buscarPorId(String id);
  Future<List<Viaje>> obtenerTodos();
  Future<List<Viaje>> obtenerPorEstado(EstadoViaje estado);
  Future<List<Viaje>> obtenerPorTransportista(String transportistaId);
  Future<List<Viaje>> obtenerPorCoordinador(String coordinadorId);
  Future<bool> crear(Viaje viaje);
  Future<bool> actualizar(Viaje viaje);
  Future<bool> asignarTransportista(String viajeId, String transportistaId);
  Future<bool> reprogramar(String viajeId, DateTime nuevaFecha);
  Future<bool> cancelar(String viajeId, String motivo);
}

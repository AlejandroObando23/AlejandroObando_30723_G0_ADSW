import '../../business/entities/documento.dart';

abstract class DocumentoRepository {
  Future<Documento?> buscarPorId(String id);
  Future<List<Documento>> obtenerTodos();
  Future<List<Documento>> obtenerPorPropietario(String propietarioId);
  Future<List<Documento>> obtenerVencidos();
  Future<bool> crear(Documento documento);
  Future<bool> actualizar(Documento documento);
  Future<bool> eliminar(String id);
  Future<List<Documento>> obtenerPorEstado(EstadoDocumento estado);
}

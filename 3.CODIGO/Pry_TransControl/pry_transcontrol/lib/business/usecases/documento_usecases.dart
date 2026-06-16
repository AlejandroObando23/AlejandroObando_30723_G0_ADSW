import '../entities/documento.dart';
import '../../data/repositories/documento_repository.dart';

class CrearDocumentoUseCase {
  final DocumentoRepository repository;

  CrearDocumentoUseCase(this.repository);

  Future<bool> call(Documento documento) async {
    return await repository.crear(documento);
  }
}

class ObtenerDocumentosPorPropietarioUseCase {
  final DocumentoRepository repository;

  ObtenerDocumentosPorPropietarioUseCase(this.repository);

  Future<List<Documento>> call(String propietarioId) async {
    return await repository.obtenerPorPropietario(propietarioId);
  }
}

class ObtenerDocumentosVencidosUseCase {
  final DocumentoRepository repository;

  ObtenerDocumentosVencidosUseCase(this.repository);

  Future<List<Documento>> call() async {
    return await repository.obtenerVencidos();
  }
}

class ActualizarEstadoDocumentoUseCase {
  final DocumentoRepository repository;

  ActualizarEstadoDocumentoUseCase(this.repository);

  Future<bool> call(String documentoId, EstadoDocumento nuevoEstado) async {
    final documento = await repository.buscarPorId(documentoId);
    if (documento == null) return false;

    final documentoActualizado = documento.copyWith(estado: nuevoEstado);
    return await repository.actualizar(documentoActualizado);
  }
}

class ObtenerDocumentosPorEstadoUseCase {
  final DocumentoRepository repository;

  ObtenerDocumentosPorEstadoUseCase(this.repository);

  Future<List<Documento>> call(EstadoDocumento estado) async {
    return await repository.obtenerPorEstado(estado);
  }
}

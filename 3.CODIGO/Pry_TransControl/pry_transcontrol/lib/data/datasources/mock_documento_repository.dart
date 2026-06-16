import '../../business/entities/documento.dart';
import '../repositories/documento_repository.dart';

class MockDocumentoRepository implements DocumentoRepository {
  static final MockDocumentoRepository _instance =
      MockDocumentoRepository._internal();

  factory MockDocumentoRepository() {
    return _instance;
  }

  MockDocumentoRepository._internal() {
    _inicializarDatos();
  }

  late List<Documento> _documentos;

  void _inicializarDatos() {
    _documentos = [
      Documento(
        id: 'DOC001',
        nombre: 'Licencia Conducción',
        tipo: TipoDocumento.licencia,
        propietarioId: 'TRAN001',
        estado: EstadoDocumento.aprobado,
        fechaCarga: DateTime(2024, 1, 15),
        fechaVencimiento: DateTime(2027, 12, 31),
        observaciones: 'Documento válido',
      ),
      Documento(
        id: 'DOC002',
        nombre: 'Certificado Técnico-Mecánico',
        tipo: TipoDocumento.tecnicomecanica,
        propietarioId: 'TRAN001',
        estado: EstadoDocumento.aprobado,
        fechaCarga: DateTime(2024, 2, 20),
        fechaVencimiento: DateTime(2025, 6, 30),
      ),
      Documento(
        id: 'DOC003',
        nombre: 'Póliza de Seguro',
        tipo: TipoDocumento.seguro,
        propietarioId: 'TRAN001',
        estado: EstadoDocumento.pendiente,
        fechaCarga: DateTime(2024, 3, 1),
        fechaVencimiento: DateTime(2025, 3, 31),
        observaciones: 'En proceso de aprobación',
      ),
      Documento(
        id: 'DOC004',
        nombre: 'Licencia Conducción',
        tipo: TipoDocumento.licencia,
        propietarioId: 'TRAN002',
        estado: EstadoDocumento.aprobado,
        fechaCarga: DateTime(2024, 1, 10),
        fechaVencimiento: DateTime(2026, 6, 30),
      ),
      Documento(
        id: 'DOC005',
        nombre: 'Licencia Conducción',
        tipo: TipoDocumento.licencia,
        propietarioId: 'TRAN003',
        estado: EstadoDocumento.vencido,
        fechaCarga: DateTime(2022, 8, 15),
        fechaVencimiento: DateTime(2024, 8, 15),
        observaciones: 'Documento vencido - Solicitar renovación',
      ),
      Documento(
        id: 'DOC006',
        nombre: 'Declaración de Impuestos 2024',
        tipo: TipoDocumento.declaracionImpuestos,
        propietarioId: 'TRAN001',
        estado: EstadoDocumento.aprobado,
        fechaCarga: DateTime(2024, 4, 15),
      ),
    ];
  }

  @override
  Future<Documento?> buscarPorId(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _documentos.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> crear(Documento documento) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_documentos.any((d) => d.id == documento.id)) {
      return false;
    }
    _documentos.add(documento);
    return true;
  }

  @override
  Future<bool> actualizar(Documento documento) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _documentos.indexWhere((d) => d.id == documento.id);
    if (index == -1) return false;
    _documentos[index] = documento;
    return true;
  }

  @override
  Future<bool> eliminar(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _documentos.indexWhere((d) => d.id == id);
    if (index == -1) return false;
    _documentos.removeAt(index);
    return true;
  }

  @override
  Future<List<Documento>> obtenerTodos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_documentos);
  }

  @override
  Future<List<Documento>> obtenerPorPropietario(String propietarioId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _documentos.where((d) => d.propietarioId == propietarioId).toList();
  }

  @override
  Future<List<Documento>> obtenerVencidos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _documentos.where((d) => d.esVencido).toList();
  }

  @override
  Future<List<Documento>> obtenerPorEstado(EstadoDocumento estado) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _documentos.where((d) => d.estado == estado).toList();
  }
}

import '../../business/entities/notificacion.dart';
import '../repositories/notificacion_repository.dart';

class MockNotificacionRepository implements NotificacionRepository {
  static final MockNotificacionRepository _instance =
      MockNotificacionRepository._internal();

  factory MockNotificacionRepository() {
    return _instance;
  }

  MockNotificacionRepository._internal() {
    _inicializarDatos();
  }

  late List<Notificacion> _notificaciones;

  void _inicializarDatos() {
    _notificaciones = [
      Notificacion(
        id: 'NOT001',
        titulo: 'Nuevo Viaje Asignado',
        mensaje: 'Se ha asignado un nuevo viaje a Bogotá - Medellín',
        tipo: TipoNotificacion.viajeCreadoViajeReprogramadoViajeCancelado,
        relatedId: 'VIJ001',
        usuarioId: 'USR002',
        fechaCreacion: DateTime(2026, 6, 12, 10, 30),
        leida: true,
      ),
      Notificacion(
        id: 'NOT002',
        titulo: 'Licencia Próxima a Vencer',
        mensaje: 'La licencia del transportista Ana Martínez vence en 60 días',
        tipo: TipoNotificacion.documentoVencido,
        relatedId: 'TRAN003',
        usuarioId: 'USR002',
        fechaCreacion: DateTime(2026, 6, 14, 9, 0),
        leida: false,
      ),
      Notificacion(
        id: 'NOT003',
        titulo: 'Viaje Reprogramado',
        mensaje: 'El viaje VIJ002 ha sido reprogramado para mañana',
        tipo: TipoNotificacion.viajeCreadoViajeReprogramadoViajeCancelado,
        relatedId: 'VIJ002',
        usuarioId: 'TRAN001',
        fechaCreacion: DateTime(2026, 6, 13, 14, 45),
        leida: false,
      ),
    ];
  }

  @override
  Future<Notificacion?> buscarPorId(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _notificaciones.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> crear(Notificacion notificacion) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_notificaciones.any((n) => n.id == notificacion.id)) {
      return false;
    }
    _notificaciones.add(notificacion);
    return true;
  }

  @override
  Future<bool> eliminar(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _notificaciones.indexWhere((n) => n.id == id);
    if (index == -1) return false;
    _notificaciones.removeAt(index);
    return true;
  }

  @override
  Future<List<Notificacion>> obtenerTodas() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_notificaciones);
  }

  @override
  Future<List<Notificacion>> obtenerPorUsuario(String usuarioId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _notificaciones.where((n) => n.usuarioId == usuarioId).toList();
  }

  @override
  Future<List<Notificacion>> obtenerNoLeidas(String usuarioId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _notificaciones
        .where((n) => n.usuarioId == usuarioId && !n.leida)
        .toList();
  }

  @override
  Future<bool> marcarComoLeida(String notificacionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _notificaciones.indexWhere((n) => n.id == notificacionId);
    if (index == -1) return false;

    final notificacion = _notificaciones[index];
    _notificaciones[index] = notificacion.copyWith(leida: true);
    return true;
  }

  @override
  Future<bool> marcarTodasComoLeidas(String usuarioId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    bool actualizadas = false;
    for (int i = 0; i < _notificaciones.length; i++) {
      if (_notificaciones[i].usuarioId == usuarioId &&
          !_notificaciones[i].leida) {
        _notificaciones[i] = _notificaciones[i].copyWith(leida: true);
        actualizadas = true;
      }
    }
    return actualizadas;
  }
}

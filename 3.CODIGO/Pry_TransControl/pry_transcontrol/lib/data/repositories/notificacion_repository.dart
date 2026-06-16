import '../../business/entities/notificacion.dart';

abstract class NotificacionRepository {
  Future<Notificacion?> buscarPorId(String id);
  Future<List<Notificacion>> obtenerTodas();
  Future<List<Notificacion>> obtenerPorUsuario(String usuarioId);
  Future<List<Notificacion>> obtenerNoLeidas(String usuarioId);
  Future<bool> crear(Notificacion notificacion);
  Future<bool> marcarComoLeida(String notificacionId);
  Future<bool> marcarTodasComoLeidas(String usuarioId);
  Future<bool> eliminar(String id);
}

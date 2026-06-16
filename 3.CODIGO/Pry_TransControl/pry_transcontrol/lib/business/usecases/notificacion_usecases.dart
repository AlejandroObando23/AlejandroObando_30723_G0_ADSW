import '../entities/notificacion.dart';
import '../../data/repositories/notificacion_repository.dart';

class CrearNotificacionUseCase {
  final NotificacionRepository repository;

  CrearNotificacionUseCase(this.repository);

  Future<bool> call(Notificacion notificacion) async {
    return await repository.crear(notificacion);
  }
}

class ObtenerNotificacionesporUsuarioUseCase {
  final NotificacionRepository repository;

  ObtenerNotificacionesporUsuarioUseCase(this.repository);

  Future<List<Notificacion>> call(String usuarioId) async {
    return await repository.obtenerPorUsuario(usuarioId);
  }
}

class ObtenerNotificacionesNoLeidasUseCase {
  final NotificacionRepository repository;

  ObtenerNotificacionesNoLeidasUseCase(this.repository);

  Future<List<Notificacion>> call(String usuarioId) async {
    return await repository.obtenerNoLeidas(usuarioId);
  }
}

class MarcarNotificacionComoLeidaUseCase {
  final NotificacionRepository repository;

  MarcarNotificacionComoLeidaUseCase(this.repository);

  Future<bool> call(String notificacionId) async {
    return await repository.marcarComoLeida(notificacionId);
  }
}

class MarcarTodasNotificacionesComoLeidasUseCase {
  final NotificacionRepository repository;

  MarcarTodasNotificacionesComoLeidasUseCase(this.repository);

  Future<bool> call(String usuarioId) async {
    return await repository.marcarTodasComoLeidas(usuarioId);
  }
}

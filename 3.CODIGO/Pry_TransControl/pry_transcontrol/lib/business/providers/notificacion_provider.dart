import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/notificacion.dart';
import '../services/service_locator.dart';

final notificacionesProvider = FutureProvider<List<Notificacion>>((ref) async {
  return await serviceLocator.notificacionRepository.obtenerTodas();
});

final notificacionesNoLeidasProvider =
    FutureProvider.family<List<Notificacion>, String>((ref, usuarioId) async {
      return await serviceLocator.obtenerNotificacionesNoLeidasUseCase(
        usuarioId,
      );
    });

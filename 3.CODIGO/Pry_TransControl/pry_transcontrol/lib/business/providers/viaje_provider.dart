import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/viaje.dart';
import '../services/service_locator.dart';

final viajesProvider = FutureProvider<List<Viaje>>((ref) async {
  return await serviceLocator.viajeRepository.obtenerTodos();
});

final viajesPlanificadosProvider = FutureProvider<List<Viaje>>((ref) async {
  return await serviceLocator.viajeRepository.obtenerPorEstado(
    EstadoViaje.planificado,
  );
});

final viajesEnTransitoProvider = FutureProvider<List<Viaje>>((ref) async {
  return await serviceLocator.viajeRepository.obtenerPorEstado(
    EstadoViaje.enTransito,
  );
});

final viajeSeleccionadoProvider = StateProvider<Viaje?>((ref) {
  return null;
});

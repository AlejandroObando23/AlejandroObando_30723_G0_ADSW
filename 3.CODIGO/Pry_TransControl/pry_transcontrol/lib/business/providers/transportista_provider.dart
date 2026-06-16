import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/transportista.dart';
import '../services/service_locator.dart';

final transportistasProvider =
    FutureProvider<List<Transportista>>((ref) async {
  return await serviceLocator.obtenerTodosLosTransportistasUseCase();
});

final transportistasActivosProvider =
    FutureProvider<List<Transportista>>((ref) async {
  return await serviceLocator.obtenerTransportistasActivosUseCase();
});

final transportistaSeleccionadoProvider = StateProvider<Transportista?>((ref) {
  return null;
});

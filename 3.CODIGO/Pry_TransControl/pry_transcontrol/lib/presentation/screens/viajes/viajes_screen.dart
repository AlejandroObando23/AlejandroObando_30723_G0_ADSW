import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../business/entities/viaje.dart';
import '../../../business/providers/viaje_provider.dart';

class ViajesScreen extends ConsumerWidget {
  const ViajesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viajesAsync = ref.watch(viajesProvider);
    final viajeSeleccionado = ref.watch(viajeSeleccionadoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Viajes')),
      body: viajesAsync.when(
        data: (viajes) {
          if (viajes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('No hay viajes registrados'),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/crear-viaje');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Crear Viaje'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viajes.length,
            itemBuilder: (context, index) {
              final viaje = viajes[index];
              return _buildViajeCard(context, viaje);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/crear-viaje');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildViajeCard(BuildContext context, Viaje viaje) {
    final estadoColor = _getEstadoColor(viaje.estado);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: estadoColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.local_shipping, color: estadoColor),
        ),
        title: Text('${viaje.origen} → ${viaje.destino}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Carga: ${viaje.tipoCarga.toString().split('.').last}'),
            Text('Salida: ${viaje.fechaSalida.toString().split('.').first}'),
          ],
        ),
        trailing: Chip(
          label: Text(_getEstadoLabel(viaje.estado)),
          backgroundColor: estadoColor.withOpacity(0.2),
          labelStyle: TextStyle(color: estadoColor),
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/viaje-detalle', arguments: viaje);
        },
      ),
    );
  }

  Color _getEstadoColor(EstadoViaje estado) {
    switch (estado) {
      case EstadoViaje.planificado:
        return Colors.blue;
      case EstadoViaje.asignado:
        return Colors.orange;
      case EstadoViaje.enTransito:
        return Colors.purple;
      case EstadoViaje.completado:
        return Colors.green;
      case EstadoViaje.cancelado:
        return Colors.red;
      case EstadoViaje.reprogramado:
        return Colors.amber;
    }
  }

  String _getEstadoLabel(EstadoViaje estado) {
    switch (estado) {
      case EstadoViaje.planificado:
        return 'Planificado';
      case EstadoViaje.asignado:
        return 'Asignado';
      case EstadoViaje.enTransito:
        return 'En Tránsito';
      case EstadoViaje.completado:
        return 'Completado';
      case EstadoViaje.cancelado:
        return 'Cancelado';
      case EstadoViaje.reprogramado:
        return 'Reprogramado';
    }
  }
}

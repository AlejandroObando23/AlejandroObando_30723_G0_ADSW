import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../business/providers/transportista_provider.dart';
import '../../../business/entities/transportista.dart';

class TransportistasScreen extends ConsumerWidget {
  const TransportistasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transportistasAsync = ref.watch(transportistasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transportistas'), elevation: 0),
      body: transportistasAsync.when(
        data: (transportistas) {
          if (transportistas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('No hay transportistas registrados'),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/crear-transportista');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar Transportista'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transportistas.length,
            itemBuilder: (context, index) {
              final transportista = transportistas[index];
              return _buildTransportistaCard(context, transportista);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/crear-transportista');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTransportistaCard(
    BuildContext context,
    Transportista transportista,
  ) {
    final estadoColor = transportista.estado.name == 'activo'
        ? Colors.green
        : transportista.estado.name == 'suspendido'
        ? Colors.red
        : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.person, color: Theme.of(context).primaryColor),
        ),
        title: Text(transportista.nombreCompleto),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cédula: ${transportista.cedula}'),
            Text('Teléfono: ${transportista.telefono}'),
            Text('Vehículo: ${transportista.vehiculo.placa}'),
          ],
        ),
        trailing: Chip(
          label: Text(_getEstadoLabel(transportista.estado)),
          backgroundColor: estadoColor.withOpacity(0.2),
          labelStyle: TextStyle(color: estadoColor),
        ),
        onTap: () {
          Navigator.of(
            context,
          ).pushNamed('/editar-transportista', arguments: transportista);
        },
      ),
    );
  }

  String _getEstadoLabel(EstadoTransportista estado) {
    switch (estado) {
      case EstadoTransportista.activo:
        return 'Activo';
      case EstadoTransportista.inactivo:
        return 'Inactivo';
      case EstadoTransportista.suspendido:
        return 'Suspendido';
    }
  }
}

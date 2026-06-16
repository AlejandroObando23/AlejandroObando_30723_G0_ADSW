import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../business/entities/viaje.dart';

class ViajeDetalleScreen extends ConsumerWidget {
  final Viaje viaje;

  const ViajeDetalleScreen({Key? key, required this.viaje}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Viaje')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información Principal
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${viaje.origen} → ${viaje.destino}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('Estado:', _getEstadoLabel(viaje.estado)),
                      _buildInfoRow(
                        'Tipo de Carga:',
                        viaje.tipoCarga.toString().split('.').last,
                      ),
                      _buildInfoRow('Peso:', '${viaje.pesoCarga} toneladas'),
                      _buildInfoRow(
                        'Salida:',
                        viaje.fechaSalida.toString().split('.').first,
                      ),
                      _buildInfoRow(
                        'Llegada Estimada:',
                        viaje.fechaLlegadaEstimada.toString().split('.').first,
                      ),
                      if (viaje.transportistaId != null)
                        _buildInfoRow('Transportista:', viaje.transportistaId!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Información de Ruta
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información de Ruta',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Distancia:',
                        '${viaje.ruta.distanciaKm} km',
                      ),
                      _buildInfoRow(
                        'Tiempo Estimado:',
                        '${(viaje.ruta.tiempoEstimadoMinutos / 60).toStringAsFixed(1)} horas',
                      ),
                      _buildInfoRow(
                        'Ruta Segura:',
                        viaje.ruta.esSegura ? 'Sí' : 'No',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Acciones
              if (viaje.puedeSerCancelado)
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _showCancelDialog(context);
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancelar Viaje'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),

              if (viaje.puedeSerReprogramado)
                ElevatedButton.icon(
                  onPressed: () {
                    _showReprogramDialog(context);
                  },
                  icon: const Icon(Icons.schedule),
                  label: const Text('Reprogramar Viaje'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    final motivoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Viaje'),
        content: TextField(
          controller: motivoController,
          decoration: const InputDecoration(
            labelText: 'Motivo de cancelación',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Viaje cancelado')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancela Viaje'),
          ),
        ],
      ),
    );
  }

  void _showReprogramDialog(BuildContext context) {
    final fechaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reprogramar Viaje'),
        content: TextField(
          controller: fechaController,
          decoration: const InputDecoration(
            labelText: 'Nueva fecha de salida',
            hintText: 'YYYY-MM-DD HH:MM',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Viaje reprogramado')),
              );
            },
            child: const Text('Reprogramar'),
          ),
        ],
      ),
    );
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

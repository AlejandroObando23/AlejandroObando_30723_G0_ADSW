import 'package:flutter/material.dart';

class MonitoreoScreen extends StatefulWidget {
  const MonitoreoScreen({Key? key}) : super(key: key);

  @override
  State<MonitoreoScreen> createState() => _MonitoreoScreenState();
}

class _MonitoreoScreenState extends State<MonitoreoScreen> {
  // Coordenadas simuladas de un viaje en monitoreo
  final _ubicacionActual = {
    'latitud': 4.8090,
    'longitud': -74.0151,
    'transportista': 'Pedro Gómez',
    'viaje': 'Bogotá → Medellín',
    'estado': 'En Tránsito',
    'velocidad': '85 km/h',
    'distanciaRecorrida': '120 km',
    'distanciaRestante': '300 km',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoreo de Viajes'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Simulación de mapa
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map,
                        size: 64,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Mapa de Monitoreo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ubicación: ${_ubicacionActual['latitud']}, ${_ubicacionActual['longitud']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Información del Viaje
              Text(
                'Información del Viaje',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        'Ruta:',
                        _ubicacionActual['viaje']! as String,
                      ),
                      _buildInfoRow(
                        'Transportista:',
                        _ubicacionActual['transportista']! as String,
                      ),
                      _buildInfoRow(
                        'Estado:',
                        _ubicacionActual['estado']! as String,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Datos en Tiempo Real
              Text(
                'Datos en Tiempo Real',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _buildMetricCard(
                    'Velocidad',
                    _ubicacionActual['velocidad']! as String,
                    Icons.speed,
                    Colors.blue,
                  ),
                  _buildMetricCard(
                    'Distancia Recorrida',
                    _ubicacionActual['distanciaRecorrida']! as String,
                    Icons.directions_car,
                    Colors.green,
                  ),
                  _buildMetricCard(
                    'Distancia Restante',
                    _ubicacionActual['distanciaRestante']! as String,
                    Icons.location_on,
                    Colors.orange,
                  ),
                  _buildMetricCard(
                    'Progreso',
                    '28%',
                    Icons.trending_up,
                    Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Historial de Ubicaciones
              Text(
                'Historial de Ubicaciones',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),

              Card(
                child: Column(
                  children: List.generate(
                    3,
                    (index) => ListTile(
                      leading: Icon(
                        Icons.location_history,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        'Punto ${index + 1}',
                      ),
                      subtitle: Text(
                        '${4.7110 + (index * 0.05)}, ${-74.0721 + (index * 0.1)}',
                      ),
                      trailing: Text(
                        '${10 + index}:00',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
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
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String titulo,
    String valor,
    IconData icono,
    Color color,
  ) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              Text(
                valor,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                titulo,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

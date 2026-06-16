import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../business/providers/notificacion_provider.dart';

class NotificacionesScreen extends ConsumerWidget {
  const NotificacionesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const usuarioId = 'USR002'; // Simulado
    final notificacionesAsync = ref.watch(
      notificacionesNoLeidasProvider(usuarioId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Todas las notificaciones marcadas como leídas',
                  ),
                ),
              );
            },
            child: const Text(
              'Marcar todas como leídas',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: notificacionesAsync.when(
        data: (notificaciones) {
          if (notificaciones.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text('No hay notificaciones'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notificaciones.length,
            itemBuilder: (context, index) {
              final notificacion = notificaciones[index];
              return _buildNotificacionCard(context, notificacion);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildNotificacionCard(BuildContext context, notificacion) {
    final iconData = _getIconoTipo(notificacion.tipo);
    final color = _getColorTipo(notificacion.tipo);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(iconData, color: color),
        ),
        title: Text(
          notificacion.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notificacion.mensaje),
            const SizedBox(height: 4),
            Text(
              notificacion.fechaCreacion.toString().split('.').first,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: !notificacion.leida
            ? Chip(
                label: const Text('Nueva'),
                backgroundColor: color.withOpacity(0.2),
                labelStyle: TextStyle(color: color),
              )
            : null,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(notificacion.titulo),
              content: Text(notificacion.mensaje),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIconoTipo(tipo) {
    return Icons.notifications;
  }

  Color _getColorTipo(tipo) {
    return Colors.blue;
  }
}

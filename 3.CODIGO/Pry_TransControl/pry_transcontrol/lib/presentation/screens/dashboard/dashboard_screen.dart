import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../business/providers/usuario_provider.dart';
import '../../../business/providers/viaje_provider.dart';
import '../../../business/providers/notificacion_provider.dart';
import '../../../business/entities/viaje.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioAutenticadoProvider);
    final viajesAsync = ref.watch(viajesProvider);

    if (usuario == null) {
      return const NoPermissionScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('TransControl'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.of(context).pushNamed('/notificaciones'),
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: const Text('Mi Perfil'),
                onTap: () async {
                  await Future.delayed(const Duration(milliseconds: 200));
                  if (context.mounted) {
                    Navigator.of(context).pushNamed('/mi-perfil');
                  }
                },
              ),
              PopupMenuItem(
                child: const Text('Cerrar Sesión'),
                onTap: () {
                  ref.read(usuarioAutenticadoProvider.notifier).cerrarSesion();
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bienvenida
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Bienvenido, ${usuario.nombres}!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rol: ${_getRolLabel(usuario.rol)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Estadísticas rápidas
              Text(
                'Resumen Rápido',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _buildQuickStats(context, ref),
              const SizedBox(height: 24),

              // Viajes recientes
              Text(
                'Viajes Recientes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              viajesAsync.when(
                data: (viajes) {
                  final viajesRecientes = viajes.take(3).toList();
                  if (viajesRecientes.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('No hay viajes registrados'),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viajesRecientes.length,
                    itemBuilder: (context, index) {
                      final viaje = viajesRecientes[index];
                      return _buildViajeCard(context, viaje);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
              const SizedBox(height: 32),

              // Menú de acciones principales
              Text(
                'Acciones Principales',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _buildMenuAcciones(context, usuario),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, WidgetRef ref) {
    final viajesAsync = ref.watch(viajesProvider);

    return viajesAsync.when(
      data: (viajes) {
        final planificados = viajes
            .where((v) => v.estado == EstadoViaje.planificado)
            .length;
        final enTransito = viajes
            .where((v) => v.estado == EstadoViaje.enTransito)
            .length;
        final completados = viajes
            .where((v) => v.estado == EstadoViaje.completado)
            .length;

        return GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildStatCard(
              context,
              'Planificados',
              planificados.toString(),
              Icons.schedule,
              Colors.blue,
            ),
            _buildStatCard(
              context,
              'En Tránsito',
              enTransito.toString(),
              Icons.directions_car,
              Colors.orange,
            ),
            _buildStatCard(
              context,
              'Completados',
              completados.toString(),
              Icons.check_circle,
              Colors.green,
            ),
          ],
        );
      },
      loading: () =>
          const SizedBox(height: 100, child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String titulo,
    String valor,
    IconData icono,
    Color color,
  ) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              Text(
                valor,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                titulo,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViajeCard(BuildContext context, Viaje viaje) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.local_shipping,
          color: Theme.of(context).primaryColor,
        ),
        title: Text('${viaje.origen} → ${viaje.destino}'),
        subtitle: Text(
          'Estado: ${_getEstadoLabel(viaje.estado)} | ${viaje.tipoCarga.toString().split('.').last}',
        ),
        trailing: Text(
          '${viaje.pesoCarga} ton',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/viaje-detalle', arguments: viaje);
        },
      ),
    );
  }

  Widget _buildMenuAcciones(BuildContext context, usuario) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildAccionCard(
          context,
          'Transportistas',
          Icons.person_outline,
          Colors.blue,
          () => Navigator.of(context).pushNamed('/transportistas'),
        ),
        _buildAccionCard(
          context,
          'Viajes',
          Icons.local_shipping,
          Colors.orange,
          () => Navigator.of(context).pushNamed('/viajes'),
        ),
        _buildAccionCard(
          context,
          'Documentos',
          Icons.description,
          Colors.green,
          () => Navigator.of(context).pushNamed('/documentos'),
        ),
        _buildAccionCard(
          context,
          'Monitoreo',
          Icons.map,
          Colors.purple,
          () => Navigator.of(context).pushNamed('/monitoreo'),
        ),
      ],
    );
  }

  Widget _buildAccionCard(
    BuildContext context,
    String titulo,
    IconData icono,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: Colors.white, size: 48),
              const SizedBox(height: 12),
              Text(
                titulo,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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

  String _getRolLabel(rol) {
    switch (rol) {
      case 'administrador':
        return 'Administrador';
      case 'coordinador':
        return 'Coordinador';
      case 'secretaria':
        return 'Secretaria';
      case 'transportista':
        return 'Transportista';
      default:
        return rol.toString();
    }
  }
}

class NoPermissionScreen extends StatelessWidget {
  const NoPermissionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 64, color: Color(0xFFE53935)),
            const SizedBox(height: 24),
            const Text('No tienes permiso para acceder'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
              child: const Text('Volver al Login'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../business/providers/usuario_provider.dart';
import '../../../business/providers/viaje_provider.dart';
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
      backgroundColor: const Color(0xFFF0F4FF),
      body: CustomScrollView(
        slivers: [
          // ── AppBar con gradiente ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: const Color(0xFF0061A8),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF0061A8), Color(0xFF4285F4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              child: Text(
                                usuario.nombres.isNotEmpty
                                    ? usuario.nombres[0].toUpperCase()
                                    : 'U',
                                style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¡Hola, ${usuario.nombres}! 👋',
                                    style: GoogleFonts.outfit(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _getRolLabel(usuario.rol),
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () => Navigator.of(context).pushNamed('/notificaciones'),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.person_outline, size: 20),
                        SizedBox(width: 8),
                        Text('Mi Perfil'),
                      ],
                    ),
                    onTap: () async {
                      await Future.delayed(const Duration(milliseconds: 200));
                      if (context.mounted) {
                        Navigator.of(context).pushNamed('/mi-perfil');
                      }
                    },
                  ),
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.logout, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Cerrar Sesión',
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    onTap: () {
                      ref
                          .read(usuarioAutenticadoProvider.notifier)
                          .cerrarSesion();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                  ),
                ],
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // ── Estadísticas rápidas ────────────────────────────────
                  _SectionTitle(title: 'Resumen de Operaciones'),
                  const SizedBox(height: 12),
                  _QuickStatsRow(ref: ref),
                  const SizedBox(height: 28),

                  // ── Viajes recientes ────────────────────────────────────
                  _SectionTitle(title: 'Viajes Recientes'),
                  const SizedBox(height: 12),
                  viajesAsync.when(
                    data: (viajes) {
                      final viajesRecientes = viajes.take(4).toList();
                      if (viajesRecientes.isEmpty) {
                        return _EmptyState(
                          icon: Icons.local_shipping_outlined,
                          mensaje: 'No hay viajes registrados',
                        );
                      }
                      return Column(
                        children: viajesRecientes
                            .asMap()
                            .entries
                            .map((e) => _ViajeCard(
                                  viaje: e.value,
                                  index: e.key,
                                  onTap: () => Navigator.of(context)
                                      .pushNamed('/viaje-detalle',
                                          arguments: e.value),
                                ))
                            .toList(),
                      );
                    },
                    loading: () => const Center(
                        child: CircularProgressIndicator()),
                    error: (error, stack) =>
                        Center(child: Text('Error: $error')),
                  ),
                  const SizedBox(height: 28),

                  // ── Acciones principales ────────────────────────────────
                  _SectionTitle(title: 'Acciones Principales'),
                  const SizedBox(height: 12),
                  _MenuAcciones(context: context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

// ── Título de sección ────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A237E), Color(0xFF4285F4)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A237E),
          ),
        ),
      ],
    );
  }
}

// ── Fila de estadísticas ─────────────────────────────────────────────────────
class _QuickStatsRow extends ConsumerWidget {
  final WidgetRef ref;
  const _QuickStatsRow({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    final viajesAsync = widgetRef.watch(viajesProvider);

    return viajesAsync.when(
      data: (viajes) {
        final planificados =
            viajes.where((v) => v.estado == EstadoViaje.planificado).length;
        final enTransito =
            viajes.where((v) => v.estado == EstadoViaje.enTransito).length;
        final completados =
            viajes.where((v) => v.estado == EstadoViaje.completado).length;
        final total = viajes.length;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Total',
                    value: total.toString(),
                    icon: Icons.inventory_2_outlined,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    delay: 0,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    label: 'Planificados',
                    value: planificados.toString(),
                    icon: Icons.schedule_outlined,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    delay: 100,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'En Tránsito',
                    value: enTransito.toString(),
                    icon: Icons.local_shipping_outlined,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE65100), Color(0xFFFF9800)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    delay: 200,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    label: 'Completados',
                    value: completados.toString(),
                    icon: Icons.check_circle_outline,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    delay: 300,
                  ),
                ),
              ],
            ),
          ],
        );
      },
      loading: () => const SizedBox(
          height: 120, child: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final LinearGradient gradient;
  final int delay;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.9), size: 32),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

// ── Tarjeta de viaje ─────────────────────────────────────────────────────────
class _ViajeCard extends StatelessWidget {
  final Viaje viaje;
  final VoidCallback onTap;
  final int index;

  const _ViajeCard({
    required this.viaje,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final estadoInfo = _getEstadoInfo(viaje.estado);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono de camión con fondo de color
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: estadoInfo.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_shipping,
                    color: estadoInfo.color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                // Info del viaje
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${viaje.origen}  →  ${viaje.destino}',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: estadoInfo.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              estadoInfo.label,
                              style: GoogleFonts.roboto(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: estadoInfo.color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getTipoCargaLabel(viaje.tipoCarga),
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Peso
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${viaje.pesoCarga}',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0061A8),
                      ),
                    ),
                    Text(
                      'ton',
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.black26),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 80))
        .fadeIn(duration: 350.ms)
        .slideX(begin: 0.1, end: 0);
  }

  _EstadoInfo _getEstadoInfo(EstadoViaje estado) {
    switch (estado) {
      case EstadoViaje.planificado:
        return _EstadoInfo('Planificado', const Color(0xFF1565C0));
      case EstadoViaje.asignado:
        return _EstadoInfo('Asignado', const Color(0xFF6A1B9A));
      case EstadoViaje.enTransito:
        return _EstadoInfo('En Tránsito', const Color(0xFFE65100));
      case EstadoViaje.completado:
        return _EstadoInfo('Completado', const Color(0xFF2E7D32));
      case EstadoViaje.cancelado:
        return _EstadoInfo('Cancelado', const Color(0xFFC62828));
      case EstadoViaje.reprogramado:
        return _EstadoInfo('Reprogramado', const Color(0xFF827717));
    }
  }

  String _getTipoCargaLabel(TipoCarga tipo) {
    switch (tipo) {
      case TipoCarga.alimentos:
        return '🍎 Alimentos';
      case TipoCarga.muebles:
        return '🛋️ Muebles';
      case TipoCarga.electrodomesticos:
        return '📺 Electrodomésticos';
      case TipoCarga.maquinaria:
        return '⚙️ Maquinaria';
      case TipoCarga.otro:
        return '📦 Otro';
    }
  }
}

class _EstadoInfo {
  final String label;
  final Color color;
  _EstadoInfo(this.label, this.color);
}

// ── Menú de acciones ─────────────────────────────────────────────────────────
class _MenuAcciones extends StatelessWidget {
  final BuildContext context;
  const _MenuAcciones({required this.context});

  @override
  Widget build(BuildContext _) {
    final acciones = [
      _AccionInfo('Transportistas', 'Gestionar conductores',
          Icons.person_outline, const Color(0xFF1565C0), '/transportistas'),
      _AccionInfo('Viajes', 'Ver todos los viajes',
          Icons.local_shipping_outlined, const Color(0xFFE65100), '/viajes'),
      _AccionInfo('Documentos', 'Gestión documental',
          Icons.description_outlined, const Color(0xFF2E7D32), '/documentos'),
      _AccionInfo('Monitoreo', 'Rastreo en tiempo real',
          Icons.map_outlined, const Color(0xFF6A1B9A), '/monitoreo'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: acciones.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.8,
      ),
      itemBuilder: (_, i) {
        final a = acciones[i];
        return _AccionCard(accion: a, index: i);
      },
    );
  }
}

class _AccionInfo {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final Color color;
  final String ruta;
  _AccionInfo(this.titulo, this.subtitulo, this.icono, this.color, this.ruta);
}

class _AccionCard extends StatelessWidget {
  final _AccionInfo accion;
  final int index;
  const _AccionCard({required this.accion, required this.index});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).pushNamed(accion.ruta),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: accion.color.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accion.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(accion.icono, color: accion.color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        accion.titulo,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A237E),
                        ),
                      ),
                      Text(
                        accion.subtitulo,
                        style: GoogleFonts.roboto(
                          fontSize: 11,
                          color: Colors.black45,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black26, size: 18),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 300 + index * 80))
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String mensaje;
  const _EmptyState({required this.icon, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(icon, size: 56, color: Colors.black12),
            const SizedBox(height: 12),
            Text(mensaje,
                style: GoogleFonts.roboto(color: Colors.black38, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// ── Sin permiso ───────────────────────────────────────────────────────────────
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
            Text('No tienes permiso para acceder',
                style: GoogleFonts.roboto(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/login'),
              child: const Text('Volver al Login'),
            ),
          ],
        ),
      ),
    );
  }
}

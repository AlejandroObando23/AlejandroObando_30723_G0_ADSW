import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/theme/transcontrol_theme.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/crear_cuenta_screen.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';
import 'presentation/screens/transportistas/transportistas_screen.dart';
import 'presentation/screens/transportistas/crear_editar_transportista_screen.dart';
import 'presentation/screens/viajes/viajes_screen.dart';
import 'presentation/screens/viajes/viaje_detalle_screen.dart';
import 'presentation/screens/documentos/documentos_screen.dart';
import 'presentation/screens/monitoreo/monitoreo_screen.dart';
import 'presentation/screens/notificaciones/notificaciones_screen.dart';
import 'business/entities/viaje.dart';
import 'business/entities/transportista.dart';
import 'business/providers/usuario_provider.dart';

void main() {
  runApp(const ProviderScope(child: TransControlApp()));
}

class TransControlApp extends ConsumerWidget {
  const TransControlApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProviderByMode);
    final usuarioActual = ref.watch(usuarioAutenticadoProvider);

    return MaterialApp(
      title: 'TransControl',
      debugShowCheckedModeBanner: false,
      theme: TransControlTheme.lightTheme(),
      darkTheme: TransControlTheme.darkTheme(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: usuarioActual != null
          ? const DashboardScreen()
          : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/crear-cuenta': (context) => const CrearCuentaScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/transportistas': (context) => const TransportistasScreen(),
        '/crear-transportista': (context) =>
            const CrearEditarTransportistaScreen(),
        '/editar-transportista': (context) {
          final transportista =
              ModalRoute.of(context)?.settings.arguments as Transportista?;
          return CrearEditarTransportistaScreen(transportista: transportista);
        },
        '/viajes': (context) => const ViajesScreen(),
        '/viaje-detalle': (context) {
          final viaje = ModalRoute.of(context)?.settings.arguments as Viaje?;
          if (viaje == null) {
            return const SizedBox.shrink();
          }
          return ViajeDetalleScreen(viaje: viaje);
        },
        '/documentos': (context) => const DocumentosScreen(),
        '/monitoreo': (context) => const MonitoreoScreen(),
        '/notificaciones': (context) => const NotificacionesScreen(),
        '/mi-perfil': (context) => const MiPerfilScreen(),
        '/recuperar-password': (context) => const RecuperarPasswordScreen(),
        '/crear-viaje': (context) => const CrearViajeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/editar-transportista') {
          final args = settings.arguments as Transportista;
          return MaterialPageRoute(
            builder: (context) =>
                CrearEditarTransportistaScreen(transportista: args),
          );
        }
        return null;
      },
    );
  }
}

// Pantallas placeholder para completar funcionalidades
class MiPerfilScreen extends StatelessWidget {
  const MiPerfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('Pantalla de Perfil'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}

class RecuperarPasswordScreen extends StatelessWidget {
  const RecuperarPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Contraseña')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_reset, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('Pantalla de Recuperación de Contraseña'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}

class CrearViajeScreen extends StatefulWidget {
  const CrearViajeScreen({Key? key}) : super(key: key);

  @override
  State<CrearViajeScreen> createState() => _CrearViajeScreenState();
}

class _CrearViajeScreenState extends State<CrearViajeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _origenController = TextEditingController();
  final _destinoController = TextEditingController();
  final _pesoController = TextEditingController();
  DateTime? _fechaSalida;
  DateTime? _fechaLlegada;
  String _tipoCarga = 'alimentos';

  @override
  void dispose() {
    _origenController.dispose();
    _destinoController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  void _handleCrear() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Viaje creado exitosamente')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Viaje')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nuevo Viaje',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _origenController,
                  decoration: InputDecoration(
                    labelText: 'Origen',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _destinoController,
                  decoration: InputDecoration(
                    labelText: 'Destino',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _tipoCarga,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _tipoCarga = newValue);
                    }
                  },
                  items:
                      [
                            'alimentos',
                            'muebles',
                            'electrodomesticos',
                            'maquinaria',
                            'otro',
                          ]
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value[0].toUpperCase() + value.substring(1),
                              ),
                            ),
                          )
                          .toList(),
                  decoration: InputDecoration(
                    labelText: 'Tipo de Carga',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pesoController,
                  decoration: InputDecoration(
                    labelText: 'Peso (toneladas)',
                    prefixIcon: const Icon(Icons.balance),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Cancelar'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _handleCrear,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Crear Viaje'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

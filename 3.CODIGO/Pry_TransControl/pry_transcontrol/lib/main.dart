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
import 'business/services/service_locator.dart';

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

class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({Key? key}) : super(key: key);

  @override
  State<RecuperarPasswordScreen> createState() => _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    setState(() => _loading = true);

    try {
      final usuario = await serviceLocator.usuarioRepository.buscarPorCorreo(email);
      await Future.delayed(const Duration(milliseconds: 600));
      if (usuario != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Se ha enviado un correo con instrucciones a $email')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No existe una cuenta asociada a ese correo')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al procesar la solicitud')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Correo requerido';
    final email = value.trim();
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    if (!emailRegex.hasMatch(email)) return 'Correo inválido';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Contraseña')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Icon(Icons.lock_reset, size: 72, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Recuperar Contraseña',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Ingresa el correo asociado a tu cuenta. Si existe, recibirás instrucciones para restablecer la contraseña.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: _validateEmail,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Enviar instrucciones'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _loading ? null : () => Navigator.of(context).pop(),
                child: const Text('Volver al inicio de sesión'),
              ),
            ],
          ),
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/usuario.dart';
import '../services/service_locator.dart';

final usuarioAutenticadoProvider =
    StateNotifierProvider<UsuarioNotifier, Usuario?>((ref) {
      return UsuarioNotifier();
    });

class UsuarioNotifier extends StateNotifier<Usuario?> {
  UsuarioNotifier() : super(null);

  Future<bool> autenticar(String correo, String password) async {
    final usuario = await serviceLocator.autenticarUsuarioUseCase(
      correo,
      password,
    );
    if (usuario != null) {
      state = usuario;
      return true;
    }
    return false;
  }

  Future<bool> registrarse(Usuario usuario) async {
    final resultado = await serviceLocator.crearCuentaUseCase(usuario);
    if (resultado) {
      state = usuario;
      return true;
    }
    return false;
  }

  void cerrarSesion() {
    state = null;
  }

  Future<void> obtenerUsuario(String id) async {
    state = await serviceLocator.obtenerUsuarioPorIdUseCase(id);
  }
}

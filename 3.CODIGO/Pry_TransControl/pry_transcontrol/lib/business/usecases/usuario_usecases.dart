import '../entities/usuario.dart';
import '../../data/repositories/usuario_repository.dart';

class AutenticarUsuarioUseCase {
  final UsuarioRepository repository;

  AutenticarUsuarioUseCase(this.repository);

  Future<Usuario?> call(String correo, String password) async {
    return await repository.autenticar(correo, password);
  }
}

class CrearCuentaUseCase {
  final UsuarioRepository repository;

  CrearCuentaUseCase(this.repository);

  Future<bool> call(Usuario usuario) async {
    return await repository.crearUsuario(usuario);
  }
}

class ObtenerUsuarioPorIdUseCase {
  final UsuarioRepository repository;

  ObtenerUsuarioPorIdUseCase(this.repository);

  Future<Usuario?> call(String id) async {
    return await repository.buscarPorId(id);
  }
}

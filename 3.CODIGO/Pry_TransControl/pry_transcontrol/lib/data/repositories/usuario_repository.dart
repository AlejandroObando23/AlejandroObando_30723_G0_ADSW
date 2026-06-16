import '../../business/entities/usuario.dart';

abstract class UsuarioRepository {
  Future<Usuario?> buscarPorId(String id);
  Future<Usuario?> buscarPorCorreo(String correo);
  Future<List<Usuario>> obtenerTodos();
  Future<bool> crearUsuario(Usuario usuario);
  Future<bool> actualizarUsuario(Usuario usuario);
  Future<bool> eliminarUsuario(String id);
  Future<Usuario?> autenticar(String correo, String password);
}

import '../../business/entities/usuario.dart';
import '../repositories/usuario_repository.dart';

class MockUsuarioRepository implements UsuarioRepository {
  static final MockUsuarioRepository _instance = MockUsuarioRepository._internal();

  factory MockUsuarioRepository() {
    return _instance;
  }

  MockUsuarioRepository._internal() {
    _inicializarDatos();
  }

  late List<Usuario> _usuarios;

  void _inicializarDatos() {
    _usuarios = [
      Usuario(
        id: 'USR001',
        nombres: 'Juan',
        apellidos: 'Pérez',
        correo: 'juan@transcontrol.com',
        telefono: '3001234567',
        cedula: '1234567890',
        rol: RolUsuario.administrador,
        fechaRegistro: DateTime(2024, 1, 15),
      ),
      Usuario(
        id: 'USR002',
        nombres: 'María',
        apellidos: 'García',
        correo: 'maria@transcontrol.com',
        telefono: '3007654321',
        cedula: '9876543210',
        rol: RolUsuario.coordinador,
        fechaRegistro: DateTime(2024, 2, 20),
      ),
      Usuario(
        id: 'USR003',
        nombres: 'Carlos',
        apellidos: 'López',
        correo: 'carlos@transcontrol.com',
        telefono: '3005551234',
        cedula: '5555555555',
        rol: RolUsuario.secretaria,
        fechaRegistro: DateTime(2024, 3, 10),
      ),
      Usuario(
        id: 'USR004',
        nombres: 'Pedro',
        apellidos: 'Martínez',
        correo: 'pedro@transcontrol.com',
        telefono: '3004445678',
        cedula: '4444444444',
        rol: RolUsuario.transportista,
        fechaRegistro: DateTime(2024, 4, 5),
      ),
    ];
  }

  @override
  Future<Usuario?> autenticar(String correo, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _usuarios.firstWhere((usuario) => usuario.correo == correo);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Usuario?> buscarPorCorreo(String correo) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _usuarios.firstWhere((usuario) => usuario.correo == correo);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Usuario?> buscarPorId(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _usuarios.firstWhere((usuario) => usuario.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> crearUsuario(Usuario usuario) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_usuarios.any((u) => u.id == usuario.id || u.correo == usuario.correo)) {
      return false;
    }
    _usuarios.add(usuario);
    return true;
  }

  @override
  Future<bool> actualizarUsuario(Usuario usuario) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _usuarios.indexWhere((u) => u.id == usuario.id);
    if (index == -1) return false;
    _usuarios[index] = usuario;
    return true;
  }

  @override
  Future<bool> eliminarUsuario(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _usuarios.indexWhere((u) => u.id == id);
    if (index == -1) return false;
    _usuarios.removeAt(index);
    return true;
  }

  @override
  Future<List<Usuario>> obtenerTodos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_usuarios);
  }
}

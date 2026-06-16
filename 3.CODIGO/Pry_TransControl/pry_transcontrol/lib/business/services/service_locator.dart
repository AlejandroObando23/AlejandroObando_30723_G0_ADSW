import '../../data/datasources/mock_usuario_repository.dart';
import '../../data/datasources/mock_transportista_repository.dart';
import '../../data/datasources/mock_viaje_repository.dart';
import '../../data/datasources/notificacion_repository_impl.dart';
import '../../data/datasources/mock_documento_repository.dart';
import '../../data/datasources/notificacion_repository_impl.dart';
import '../../data/repositories/usuario_repository.dart';
import '../../data/repositories/transportista_repository.dart';
import '../../data/repositories/viaje_repository.dart';
import '../../data/repositories/documento_repository.dart';
import '../../data/repositories/notificacion_repository.dart';
import '../../data/datasources/mock_viaje_repository.dart';
import '../usecases/usuario_usecases.dart';
import '../usecases/transportista_usecases.dart';
import '../usecases/viaje_usecases.dart';
import '../usecases/documento_usecases.dart';
import '../usecases/notificacion_usecases.dart';
import '../observers/travel_observer.dart';

/// Servicio de inyección de dependencias singleton
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal() {
    _registerDependencies();
  }

  late UsuarioRepository usuarioRepository;
  late TransportistaRepository transportistaRepository;
  late ViajeRepository viajeRepository;
  late DocumentoRepository documentoRepository;
  late NotificacionRepository notificacionRepository;
  late ViajeSubject viajeSubject;

  // Use Cases
  late AutenticarUsuarioUseCase autenticarUsuarioUseCase;
  late CrearCuentaUseCase crearCuentaUseCase;
  late ObtenerUsuarioPorIdUseCase obtenerUsuarioPorIdUseCase;

  late CrearTransportistaUseCase crearTransportistaUseCase;
  late ObtenerTransportistasActivosUseCase obtenerTransportistasActivosUseCase;
  late ActualizarTransportistaUseCase actualizarTransportistaUseCase;
  late EliminarTransportistaUseCase eliminarTransportistaUseCase;
  late ObtenerTodosLosTransportistasUseCase obtenerTodosLosTransportistasUseCase;

  late CrearViajeUseCase crearViajeUseCase;
  late AsignarTransportistaAViajeUseCase asignarTransportistaAViajeUseCase;
  late ReprogramarViajeUseCase reprogramarViajeUseCase;
  late CancelarViajeUseCase cancelarViajeUseCase;
  late ObtenerViajesPorCoordinadorUseCase obtenerViajesPorCoordinadorUseCase;
  late ObtenerViajesPorTransportistaUseCase obtenerViajesPorTransportistaUseCase;
  late CalcularRutaViajeUseCase calcularRutaViajeUseCase;

  late CrearDocumentoUseCase crearDocumentoUseCase;
  late ObtenerDocumentosPorPropietarioUseCase obtenerDocumentosPorPropietarioUseCase;
  late ObtenerDocumentosVencidosUseCase obtenerDocumentosVencidosUseCase;
  late ActualizarEstadoDocumentoUseCase actualizarEstadoDocumentoUseCase;

  late CrearNotificacionUseCase crearNotificacionUseCase;
  late ObtenerNotificacionesporUsuarioUseCase obtenerNotificacionesporUsuarioUseCase;
  late ObtenerNotificacionesNoLeidasUseCase obtenerNotificacionesNoLeidasUseCase;
  late MarcarNotificacionComoLeidaUseCase marcarNotificacionComoLeidaUseCase;

  void _registerDependencies() {
    // Repositories
    usuarioRepository = MockUsuarioRepository();
    transportistaRepository = MockTransportistaRepository();
    viajeRepository = MockViajeRepository();
    documentoRepository = MockDocumentoRepository() as DocumentoRepository;
    notificacionRepository = MockNotificacionRepository();
    viajeSubject = ViajeSubject();

    // Use Cases - Usuario
    autenticarUsuarioUseCase = AutenticarUsuarioUseCase(usuarioRepository);
    crearCuentaUseCase = CrearCuentaUseCase(usuarioRepository);
    obtenerUsuarioPorIdUseCase = ObtenerUsuarioPorIdUseCase(usuarioRepository);

    // Use Cases - Transportista
    crearTransportistaUseCase = CrearTransportistaUseCase(transportistaRepository);
    obtenerTransportistasActivosUseCase =
        ObtenerTransportistasActivosUseCase(transportistaRepository);
    actualizarTransportistaUseCase =
        ActualizarTransportistaUseCase(transportistaRepository);
    eliminarTransportistaUseCase = EliminarTransportistaUseCase(transportistaRepository);
    obtenerTodosLosTransportistasUseCase =
        ObtenerTodosLosTransportistasUseCase(transportistaRepository);

    // Use Cases - Viaje
    crearViajeUseCase = CrearViajeUseCase(viajeRepository, viajeSubject);
    asignarTransportistaAViajeUseCase =
        AsignarTransportistaAViajeUseCase(viajeRepository, viajeSubject);
    reprogramarViajeUseCase = ReprogramarViajeUseCase(viajeRepository, viajeSubject);
    cancelarViajeUseCase = CancelarViajeUseCase(viajeRepository, viajeSubject);
    obtenerViajesPorCoordinadorUseCase =
        ObtenerViajesPorCoordinadorUseCase(viajeRepository);
    obtenerViajesPorTransportistaUseCase =
        ObtenerViajesPorTransportistaUseCase(viajeRepository);
    calcularRutaViajeUseCase = CalcularRutaViajeUseCase();

    // Use Cases - Documento
    crearDocumentoUseCase = CrearDocumentoUseCase(documentoRepository);
    obtenerDocumentosPorPropietarioUseCase =
        ObtenerDocumentosPorPropietarioUseCase(documentoRepository);
    obtenerDocumentosVencidosUseCase =
        ObtenerDocumentosVencidosUseCase(documentoRepository);
    actualizarEstadoDocumentoUseCase =
        ActualizarEstadoDocumentoUseCase(documentoRepository);

    // Use Cases - Notificación
    crearNotificacionUseCase = CrearNotificacionUseCase(notificacionRepository);
    obtenerNotificacionesporUsuarioUseCase =
        ObtenerNotificacionesporUsuarioUseCase(notificacionRepository);
    obtenerNotificacionesNoLeidasUseCase =
        ObtenerNotificacionesNoLeidasUseCase(notificacionRepository);
    marcarNotificacionComoLeidaUseCase =
        MarcarNotificacionComoLeidaUseCase(notificacionRepository);

    // Registrar observadores
    viajeSubject.registrarObservador(
      CoordinadorObserver(coordinadorId: 'USR002'),
    );
    viajeSubject.registrarObservador(
      SecretariaObserver(secretariaId: 'USR003'),
    );
    viajeSubject.registrarObservador(
      TransportistaObserver(transportistaId: 'TRAN001'),
    );
  }

  // Getters para observadores
  ViajeSubject getViajeSubject() => viajeSubject;
}

// Instancia global del ServiceLocator
final serviceLocator = ServiceLocator();

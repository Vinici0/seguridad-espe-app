import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_maps_adv/models/institucionmodel.dart';
import 'package:flutter_maps_adv/models/ubicacion.dart';
import 'package:flutter_maps_adv/models/usuario.dart';
import 'package:flutter_maps_adv/resources/repository/auth_repository.dart';
import 'package:flutter_maps_adv/resources/services/socket_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiUserRepository apiAuthRepository = ApiUserRepository();
  final SocketService socketService = SocketService();

  final List<Institucione> instituciones = [];

  bool isLoggedInTrue = false;
  Usuario usuario = Usuario(
      online: false,
      nombre: '',
      email: '',
      isPublicacionPendiente: false,
      telefono: '',
      tokenApp: '',
      ubicacion: [],
      uid: '',
      isActivo: false,
      isNotificacionesPendiente: false,
      salas: [],
      isOpenRoom: false,
      isSalasPendiente: false,
      createdAt: '',
      updatedAt: '',
      telefonos: [],
      google: false);

  AuthBloc() : super(const AuthState(ubicaciones: [])) {
    on<AuthConectEvent>(_onAuthConnectEvent);
    on<AuthDisconnectEvent>(_onAuthDisconnectEvent);
    on<AuthInitEvent>(_onAuthInitEvent);
    on<AuthLoginEvent>(_onAuthLoginEvent);
    on<AuthLogoutEvent>(_onAuthLogoutEvent);
    on<AuthRegisterEvent>(_onAuthRegisterEvent);
    on<AuthAddUbicacionEvent>(_onAuthAddUbicacionEvent);
    on<AuthDeleteUbicacionEvent>(_onAuthDeleteUbicacionEvent);
    on<AuthAddTelefonoEvent>(_onAuthAddTelefonoEvent);
    on<AuthDeleteTeleFamilyEvent>(_onAuthDeleteTeleFamilyEvent);
    on<AuthAddTelefonFamilyEvent>(_aonAddTelefonoFamilyEvent);
    on<AuthNotificacionEvent>(_onAuthNotificacionEvent);
    on<AuthUpdateUsuarioImageNewUserEvent>(_onAuthUpdateUsuarioImageEvent);
    on<UpdateUsuarioNewTelefonoOrNombreEvent>(_onUpdateUsuarioImageEvent);
    on<MarcarPublicacionPendienteFalse>(_onMarcarPublicacionPendienteFalse);
    on<MarcarSalasPendienteFalse>(_onMarcarSalasPendienteFalse);
    on<MarcarSalasPendienteTrue>(_onMarcarSalasPendienteTrue);

    on<EventListInstituciones>(_onEventListInstituciones);
    on<MarcarNotificacionesPendienteFalse>(
        _onMarcarNotificacionesPendienteFalse);
    on<IsSalasPendiente>(_onIsSalasPendiente);
  }

  // void _cargarUnidadesEducativas() async {
  //   final instituciones =
  //       await apiAuthRepository.obtenerTodasLasInstituciones();
  //   for (final institucion in instituciones) {
  //     this.instituciones.add(institucion);
  //   }
  // }

  _onEventListInstituciones(
      EventListInstituciones event, Emitter<AuthState> emit) async {}

  void _onAuthRegisterEvent(AuthRegisterEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(
      usuario: apiAuthRepository.usuario,
    ));
  }

  void _onAuthLoginEvent(AuthLoginEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(usuario: apiAuthRepository.usuario));
  }

  void _onAuthInitEvent(AuthInitEvent event, Emitter<AuthState> emit) {
    final Usuario usuario = apiAuthRepository.usuario == null
        ? Usuario(
            online: false,
            nombre: '',
            email: '',
            isPublicacionPendiente: false,
            telefono: '',
            tokenApp: '',
            ubicacion: [],
            uid: '',
            isActivo: false,
            isNotificacionesPendiente: false,
            salas: [],
            isOpenRoom: false,
            isSalasPendiente: false,
            createdAt: '',
            updatedAt: '',
            telefonos: [],
            google: false)
        : apiAuthRepository.usuario!;

    final List<Ubicacion> ubicaciones = apiAuthRepository.ubicaciones;
    try {
      emit(state.copyWith(usuario: usuario, ubicaciones: ubicaciones));
    } catch (e) {
      print(e);
    }
  }

  void _onAuthLogoutEvent(
      AuthLogoutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(usuario: null));
  }

  _onAuthConnectEvent(AuthConectEvent event, Emitter<AuthState> emit) {
    socketService.connect();
  }

  void _onAuthDisconnectEvent(
      AuthDisconnectEvent event, Emitter<AuthState> emit) {
    socketService.disconnect();
  }

  void _onAuthAddUbicacionEvent(
      AuthAddUbicacionEvent event, Emitter<AuthState> emit) {
    if (state.ubicaciones
        .any((ubicacion) => ubicacion.uid == event.ubicacion.uid)) return;

    emit(state.copyWith(ubicaciones: [event.ubicacion, ...state.ubicaciones]));
  }

  void _onAuthDeleteUbicacionEvent(
      AuthDeleteUbicacionEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(
        ubicaciones: state.ubicaciones
            .where((ubicacion) => ubicacion.uid != event.uid)
            .toList()));
  }

  void _onMarcarPublicacionPendienteFalse(
      MarcarPublicacionPendienteFalse event, Emitter<AuthState> emit) async {
    final usuario = state.usuario!.copyWith(
      isNotificacionesPendiente: event.isPublicacionPendiente,
      isPublicacionPendiente: event.isPublicacionPendiente,
    );
    emit(state.copyWith(usuario: usuario));
    await apiAuthRepository.marcarPublicacionPendienteFalse();
  }

  void _onMarcarSalasPendienteFalse(
      MarcarSalasPendienteFalse event, Emitter<AuthState> emit) async {
    final usuario = state.usuario!.copyWith(isSalasPendiente: false);
    emit(state.copyWith(usuario: usuario));

    await apiAuthRepository.marcarSalaPendienteFalse();
  }

  void _onAuthAddTelefonoEvent(
      AuthAddTelefonoEvent event, Emitter<AuthState> emit) {
    final usuario = state.usuario!.copyWith(
      telefono: event.telefono,
    );

    emit(state.copyWith(usuario: usuario));
  }

  void _onIsSalasPendiente(
      IsSalasPendiente event, Emitter<AuthState> emit) async {
    final usuario = state.usuario!.copyWith(
      isSalasPendiente: event.isSalasPendiente,
    );

    emit(state.copyWith(usuario: usuario));
  }

  void _onMarcarSalasPendienteTrue(
      MarcarSalasPendienteTrue event, Emitter<AuthState> emit) async {
    final usuario = state.usuario!.copyWith(isSalasPendiente: true);

    emit(state.copyWith(usuario: usuario));
  }

  void _aonAddTelefonoFamilyEvent(
      AuthAddTelefonFamilyEvent event, Emitter<AuthState> emit) {
    final telefono = event.telefono.trim();

    final telefonos =
        state.usuario!.telefonos.where((t) => t.isNotEmpty).toList();

    if (telefono.isNotEmpty && !telefonos.contains(telefono)) {
      telefonos.add(telefono);

      final usuario = state.usuario!.copyWith(
        telefonos: telefonos,
      );

      emit(state.copyWith(usuario: usuario));
    }
  }

  void _onAuthDeleteTeleFamilyEvent(
    AuthDeleteTeleFamilyEvent event,
    Emitter<AuthState> emit,
  ) async {
    final newTelefonos = state.usuario!.telefonos..remove(event.telefono);

    final usuario = state.usuario!.copyWith(
      telefonos: newTelefonos,
    );

    emit(state.copyWith(usuario: usuario));
  }

  void _onMarcarNotificacionesPendienteFalse(
      MarcarNotificacionesPendienteFalse event, Emitter<AuthState> emit) async {
    final usuario = state.usuario!.copyWith(isNotificacionesPendiente: false);

    emit(state.copyWith(usuario: usuario));

    await apiAuthRepository.marcarNotificacionesPendienteFalse();
  }

  void _onAuthUpdateUsuarioImageEvent(
      AuthUpdateUsuarioImageNewUserEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(usuario: event.usuario));
  }

  bool hasTelefonos() {
    return state.usuario!.telefonos.isNotEmpty;
  }

  bool hasTelefonosFamily(String telefono) {
    return state.usuario!.telefonos.contains(telefono);
  }

  void _onAuthNotificacionEvent(
      AuthNotificacionEvent event, Emitter<AuthState> emit) async {}

  void _onUpdateUsuarioImageEvent(UpdateUsuarioNewTelefonoOrNombreEvent event,
      Emitter<AuthState> emit) async {
    final usuario = state.usuario!.copyWith(
      nombre: event.nombre,
      telefono: event.telefono,
    );

    emit(state.copyWith(usuario: usuario));
  }

  init() async {
    final isLoggedIn = await apiAuthRepository.isLoggedIn();

    add(const AuthInitEvent());

    isLoggedInTrue = isLoggedIn;

    add(const AuthConectEvent());

    return isLoggedIn;
  }

  Usuario? getUsuario() {
    if (state.usuario == null) {
      return null;
    }
    return state.usuario;
  }

  login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return false;
    }

    final login = await apiAuthRepository.login(email, password);
    if (login) {
      add(AuthLoginEvent(email: email, password: password));
      add(const AuthConectEvent());
      return true;
    }

    return false;
  }

  //obtenerTodasLasInstituciones
  Future<List<Institucione>> obtenerTodasLasInstituciones() async {
    try {
      final institucionesR =
          await apiAuthRepository.obtenerTodasLasInstituciones();
      for (final institucion in institucionesR) {
        instituciones.add(institucion);
      }
      return institucionesR;
    } catch (e) {
      return [];
    }
  }

  Future<bool> signInWithGoogle() async {
    final usuario = await apiAuthRepository.signInWithGoogle();
    if (usuario != null) {
      add(AuthLoginEvent(email: usuario.email, password: "@@@"));
      add(const AuthConectEvent());
      isLoggedInTrue = true;
      return true;
    }
    return false;
  }

  register(String nombre, String email, String password,
      String unidadEducativa) async {
    final register = await apiAuthRepository.register(
        nombre, email, password, unidadEducativa);
    isLoggedInTrue = register;
    add(AuthRegisterEvent(nombre: nombre, email: email, password: password));
    add(const AuthConectEvent());
    return register;
  }

  updateUsuarioImage(String imagen) async {
    final usuario =
        await apiAuthRepository.updateUsuarioImage(state.usuario!.uid, imagen);
    if (usuario != null) {
      add(AuthUpdateUsuarioImageNewUserEvent(usuario));
    }
  }

  logout() async {
    isLoggedInTrue = false;
    await apiAuthRepository.eliminarTokenApp();
    await apiAuthRepository.logout();
    socketService.disconnect();
  }

  updateUsuario(String nombre, String telefono) async {
    await apiAuthRepository.updateUsuario(nombre, telefono);
    if (usuario != null) {
      add(UpdateUsuarioNewTelefonoOrNombreEvent(nombre, telefono));
    }
  }

  addTelefono(String telefono) async {
    await apiAuthRepository.addTelefono(telefono);
    add(AuthAddTelefonoEvent(telefono));
  }

  addTelefonoFamily(String telefono) async {
    await apiAuthRepository.addTelefonos(telefono);
    add(AuthAddTelefonFamilyEvent(telefono));
  }

  deleteTelefonoFamily(String telefono) async {
    await apiAuthRepository.deleteTelefono(telefono);
    add(AuthDeleteTeleFamilyEvent(telefono));
  }

  deleteTelefono(String telefono) async {
    await apiAuthRepository.deleteTelefono(telefono);
    add(AuthDeleteTeleFamilyEvent(telefono));
  }

  notificacion(double lat, double lng) async {
    await apiAuthRepository.notificacion(lat, lng);
    add(AuthNotificacionEvent(lat, lng));
  }

  actualizarIsOpenRoom(bool isOpenRoom) async {
    await apiAuthRepository.actualizarIsOpenRoom(isOpenRoom);
  }

  cambiarContrasena(
      String email, String contrasenaActual, String nuevaContrasena) async {
    return await apiAuthRepository.cambiarContrasena(
        email, contrasenaActual, nuevaContrasena);
  }

  recoverPassword(String email) async {
    return await apiAuthRepository.recoverPassword(email);
  }

  // obtenerTodasLasInstituciones
}

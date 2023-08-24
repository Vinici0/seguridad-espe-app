import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_maps_adv/models/notification.dart';
import 'package:flutter_maps_adv/resources/services/noification.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _notificationService = NotificationService();

  NotificationBloc() : super(const NotificationState()) {
    on<LoadNotificationEvent>((event, emit) async {
      emit(
          state.copyWith(notificaciones: event.notificaciones, loading: false));
      print('notificaciones22222222222');
    });

    on<MarcarNotificacionComoLeidaEvent>((event, emit) async {
      final updatedNotificaciones = state.notificaciones.map((notificacion) {
        if (notificacion.uid == event.id) {
          return notificacion.copyWith(isLeida: true);
        } else {
          return notificacion;
        }
      }).toList(); // Cast the List<dynamic> to List<Notificacione>

      // await loadNotification();
      emit(state.copyWith(
          notificaciones: updatedNotificaciones.cast<Notificacione>()));

      await _notificationService.marcarNotificacionComoLeida(event.id);
    });

    on<DeleteAllNotificationsEvent>((event, emit) async {
      await _notificationService.deleteAllNotifications();
      emit(state.copyWith(notificaciones: []));
    });

    on<CurrentTextReportEvent>((event, emit) async {
      emit(state.copyWith(currentText: event.currentText));
    });

    on<DeleteNotificationByIdEvent>((event, emit) async {
      final updatedNotificaciones = state.notificaciones
          .where((notificacion) => notificacion.uid != event.id)
          .toList();

      emit(state.copyWith(notificaciones: updatedNotificaciones));

      await _notificationService.deleteNotificationById(event.id);
    });

    on<LoadingNotificationEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
    });
  }

  loadNotification() async {
    add(const LoadingNotificationEvent());
    final List<Notificacione> notificaciones =
        await _notificationService.getNotificaciones();
    add(LoadNotificationEvent(notificaciones));
  }
}

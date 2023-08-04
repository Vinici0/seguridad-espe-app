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
      emit(state.copyWith(loading: true));

      emit(
          state.copyWith(notificaciones: event.notificaciones, loading: false));
    });
  }

  loadNotification() async {
    final notificaciones = await _notificationService.getNotificaciones();
    add(LoadNotificationEvent(notificaciones));
  }
}

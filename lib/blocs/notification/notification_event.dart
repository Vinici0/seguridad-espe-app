part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotificationEvent extends NotificationEvent {
  final List<Notificacione> notificaciones;

  const LoadNotificationEvent(this.notificaciones);

  @override
  List<Object> get props => [notificaciones];
}

class UpdateNotificationEvent extends NotificationEvent {
  final bool isActive;

  const UpdateNotificationEvent(this.isActive);

  @override
  List<Object> get props => [isActive];
}

// marcarNotificacionComoLeida
class MarcarNotificacionComoLeidaEvent extends NotificationEvent {
  final String id;

  const MarcarNotificacionComoLeidaEvent(this.id);

  @override
  List<Object> get props => [id];
}

class CurrentTextReportEvent extends NotificationEvent {
  final String currentText;

  const CurrentTextReportEvent(this.currentText);

  @override
  List<Object> get props => [currentText];
}

class DeleteAllNotificationsEvent extends NotificationEvent {
  const DeleteAllNotificationsEvent();

  @override
  List<Object> get props => [];
}

//deleteNotificationById
class DeleteNotificationByIdEvent extends NotificationEvent {
  final String id;

  const DeleteNotificationByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class LoadingNotificationEvent extends NotificationEvent {
  const LoadingNotificationEvent();

  @override
  List<Object> get props => [];
}

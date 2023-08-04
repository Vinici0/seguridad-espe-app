part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final bool isActive;
  final List<Notificacione> notificaciones;
  final bool loading;

  const NotificationState(
      {this.isActive = false,
      this.notificaciones = const [],
      this.loading = false});

  //copyWith
  NotificationState copyWith({
    bool? isActive,
    List<Notificacione>? notificaciones,
    bool? loading,
  }) {
    return NotificationState(
      isActive: isActive ?? this.isActive,
      notificaciones: notificaciones ?? this.notificaciones,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object> get props => [
        isActive,
        notificaciones,
        loading,
      ];
}

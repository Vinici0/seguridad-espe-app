part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final bool isActive;
  final List<Notificacione> notificaciones;
  final bool loading;
  final String currentText;

  const NotificationState(
      {this.isActive = false,
      this.notificaciones = const [],
      this.currentText = '',
      this.loading = false});

  //copyWith
  NotificationState copyWith({
    bool? isActive,
    List<Notificacione>? notificaciones,
    bool? loading,
    String? currentText,
  }) {
    return NotificationState(
      isActive: isActive ?? this.isActive,
      notificaciones: notificaciones ?? this.notificaciones,
      loading: loading ?? this.loading,
      currentText: currentText ?? this.currentText,
    );
  }

  @override
  List<Object> get props => [
        isActive,
        notificaciones,
        loading,
        currentText,
      ];
}

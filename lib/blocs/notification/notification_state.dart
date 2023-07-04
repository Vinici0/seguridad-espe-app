part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final bool isActive;

  NotificationState({required this.isActive});

  //copyWith
  NotificationState copyWith({
    bool? isActive,
  }) {
    return NotificationState(
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object> get props => [
        isActive,
      ];
}

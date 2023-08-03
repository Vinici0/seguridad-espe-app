part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnActivateManualMarkerEvent extends SearchEvent {}

class OnDeactivateManualMarkerEvent extends SearchEvent {}

class OnNewUbicacionFoundEvent extends SearchEvent {
  final List<Ubicacion> ubicacion;
  const OnNewUbicacionFoundEvent(this.ubicacion);
}

class AddToHistoryEvent extends SearchEvent {
  final Ubicacion history;
  const AddToHistoryEvent(this.history);

  @override
  List<Object> get props => [history];
}

class OnSelectUbicacionEvent extends SearchEvent {
  final Ubicacion selectedUbicacion;
  const OnSelectUbicacionEvent(this.selectedUbicacion);

  @override
  List<Object> get props => [selectedUbicacion];
}

class AddUbicacionByUserEvent extends SearchEvent {
  final String id;
  const AddUbicacionByUserEvent(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteUbicacionByUserEvent extends SearchEvent {
  final String id;
  const DeleteUbicacionByUserEvent(this.id);

  @override
  List<Object> get props => [id];
}

class IsActiveNotification extends SearchEvent {
  final bool isActive;

  const IsActiveNotification(this.isActive);
  @override
  List<Object> get props => [
        isActive,
      ];
}

class IsTogglePolylineEvent extends SearchEvent {
  const IsTogglePolylineEvent();
  @override
  List<Object> get props => [];
}

class ToggloUpdateTypeMapEvent extends SearchEvent {
  const ToggloUpdateTypeMapEvent();
  @override
  List<Object> get props => [];
}

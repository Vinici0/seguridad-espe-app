part of 'members_bloc.dart';

abstract class MembersEvent extends Equatable {
  const MembersEvent();

  @override
  List<Object> get props => [];
}

class MembersInitEvent extends MembersEvent {}

//loader
class MembersLoadingEvent extends MembersEvent {}

class MembersLoadedEvent extends MembersEvent {
  final List<Usuario> usuariosAll;

  const MembersLoadedEvent(this.usuariosAll);

  @override
  List<Object> get props => [usuariosAll];
}

//deleteMember
class DeleteMemberEvent extends MembersEvent {
  final String uid;

  const DeleteMemberEvent(this.uid);

  @override
  List<Object> get props => [uid];
}

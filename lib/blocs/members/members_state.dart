part of 'members_bloc.dart';

class MembersState extends Equatable {
  final List<Usuario> usuariosAll;
  final bool isLoading;
  final bool isError;
  final List<ChatMessage> messages;
  final List<MensajesSala> mensajesSalas;
  const MembersState({
    this.usuariosAll = const [],
    this.messages = const [],
    this.mensajesSalas = const [],
    this.isLoading = false,
    this.isError = false,
  });

  MembersState copyWith({
    List<Usuario>? usuariosAll,
    List<ChatMessage>? messages,
    List<MensajesSala>? mensajesSalas,
    bool? isLoading,
    bool? isError,
  }) {
    return MembersState(
      usuariosAll: usuariosAll ?? this.usuariosAll,
      messages: messages ?? this.messages,
      mensajesSalas: mensajesSalas ?? this.mensajesSalas,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object> get props =>
      [usuariosAll, isLoading, isError, messages, mensajesSalas];
}

part of 'members_bloc.dart';

class MembersState extends Equatable {
  final List<Usuario> usuariosAll;
  final bool isLoading;
  final bool isError;

  const MembersState({
    this.usuariosAll = const [],
    this.isLoading = false,
    this.isError = false,
  });

  MembersState copyWith({
    List<Usuario>? usuariosAll,
    bool? isLoading,
    bool? isError,
  }) {
    return MembersState(
      usuariosAll: usuariosAll ?? this.usuariosAll,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object> get props => [usuariosAll, isLoading, isError];
}

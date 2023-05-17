part of 'sala_bloc.dart';

abstract class SalaState extends Equatable {
  const SalaState();
  
  @override
  List<Object> get props => [];
}

class SalaInitial extends SalaState {}

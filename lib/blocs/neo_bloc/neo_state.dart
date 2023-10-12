part of 'neo_bloc.dart';

abstract class NeoState extends Equatable{
  const NeoState();

  @override
  List<Object?> get props => [];
}

class NeoInitial extends NeoState{}

class NeoLoading extends NeoState{}

class NeoLoaded extends NeoState{
  final NeoModel neoModel;
  const NeoLoaded(this.neoModel);
}

class NeoError extends NeoState{
  final String? message;
  const NeoError(this.message);
}
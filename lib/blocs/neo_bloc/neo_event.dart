part of 'neo_bloc.dart';


abstract class NeoEvent extends Equatable{
  const NeoEvent();

  @override
  List<Object> get props => [];
}

class GetNeoData extends NeoEvent{
  final String startDate;
  final String endDate;
  const GetNeoData(this.startDate, this.endDate);

  @override
  List<Object> get props => [startDate, endDate];
}
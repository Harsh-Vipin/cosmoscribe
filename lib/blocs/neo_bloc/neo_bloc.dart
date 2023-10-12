import 'dart:developer';

import 'package:cosmoscribe/models/neo_model.dart';
import 'package:cosmoscribe/repositories/api_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

part 'neo_event.dart';
part 'neo_state.dart';

class NeoBloc extends Bloc<NeoEvent,NeoState>{
  NeoBloc():super(NeoInitial()){
    final ApiRepository _apiRepository = ApiRepository();

    on<GetNeoData>((event,emit) async{
      try{
        emit(NeoLoading());
        final data = await _apiRepository.fetchNeoData(event.startDate,event.endDate);
        if(data.error != null){
          emit(const NeoError("An error occurred while fetching data"));
        }else {
          emit(NeoLoaded(data));
        }

      } on NetworkError{
        emit(const NeoError("Failed to fetch data. Is your device online?"));
      }
    });
  }
}
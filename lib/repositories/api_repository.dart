
import 'package:cosmoscribe/services/api_service.dart';

import '../models/neo_model.dart';

class ApiRepository{
  final _provider = ApiProvider();

  Future<NeoModel> fetchNeoData(String startDate,String endDate){
    return _provider.fetchNeoData(startDate, endDate);
  }
}


class NetworkError extends Error{}

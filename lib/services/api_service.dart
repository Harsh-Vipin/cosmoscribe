import 'package:cosmoscribe/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/neo_model.dart';

class ApiProvider {
  final Dio _dio = Dio();
  final String baseUrl = Constants.baseUrl;

  Future<NeoModel> fetchNeoData(
      String formattedStartDate, String formattedEndDate) async {
    try {
      Response response = await _dio.get(
          '${baseUrl}neo/rest/v1/feed?start_date=$formattedStartDate&end_date=$formattedEndDate&api_key=${Constants.apiKey}');
      return NeoModel.fromJson(response.data);
    } catch (error, stacktrace) {
      if (kDebugMode) {
        print("Exception occurred: $error stackTrace: $stacktrace");
      }
      return NeoModel.withError("Failed to load Neo data");
    }
    throw Exception('Failed to load Neo data');
  }
}

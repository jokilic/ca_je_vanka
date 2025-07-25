import 'dart:async';

import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

import '../constants/enums.dart';
import '../models/response_weather.dart';
import '../util/isolates.dart';
import 'logger_service.dart';

class APIService {
  ///
  /// CONSTRUCTOR
  ///

  final LoggerService logger;
  final Dio dio;

  APIService({
    required this.logger,
    required this.dio,
  });

  ///
  /// `/weather`
  ///

  Future<({ResponseWeather? weather, String? error})> getWeather({
    required String language,
    required LatLng coordinates,
    required String countryCode,
    required String timezone,
    required String tokenValue,
    required List<DataSet> dataSets,
  }) async {
    try {
      final response = await dio.get(
        '/weather/$language/${coordinates.latitude}/${coordinates.longitude}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $tokenValue',
          },
        ),
        queryParameters: {
          'countryCode': countryCode,
          'dataSets': dataSets.map((dataSet) => dataSet.name).join(','),
          'timezone': timezone,
        },
      );

      /// Handle status codes
      switch (response.statusCode) {
        /// `OK` - The request is successful. The weather alert is in the response
        case 200:
          final data = response.data;
          final parsedResponse = await computeWeather(data);
          return (weather: parsedResponse, error: null);

        /// `Bad Request` - The server is unable to process the request due to an invalid parameter value
        case 400:
          const error = '`Bad Request` - The server is unable to process the request due to an invalid parameter value';
          logger.e('APIService -> getWeather() -> $error');
          return (weather: null, error: error);

        /// `Unauthorized` - The request isn’t authorized or doesn’t include the correct authentication information
        case 401:
          const error = "`Unauthorized` - The request isn't authorized or doesn't include the correct authentication information";
          logger.e('APIService -> getWeather() -> $error');
          return (weather: null, error: error);

        /// This shouldn't happen since it's not mentioned in the documentation
        default:
          const error = "This shouldn't happen since it's not mentioned in the documentation";
          logger.e('APIService -> getWeather() -> $error');
          return (weather: null, error: error);
      }
    } catch (e) {
      logger.e('APIService -> getWeather() -> $e');
      return (weather: null, error: '$e');
    }
  }
}

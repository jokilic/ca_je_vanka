import 'package:flutter/material.dart';

import '../../../models/location/location.dart';
import '../../../models/response_weather.dart';
import '../../../util/state.dart';
import 'weather_success.dart';

class WeatherContent extends StatelessWidget {
  final Location location;
  final CJVnkState<ResponseWeather> weatherState;

  const WeatherContent({
    required this.location,
    required this.weatherState,
  });

  @override
  Widget build(BuildContext context) => switch (weatherState) {
    Initial<ResponseWeather>() => Container(
      height: 100,
      width: 100,
      color: Colors.blue,
    ),
    Loading<ResponseWeather>() => Container(
      height: 100,
      width: 100,
      color: Colors.yellowAccent,
    ),
    Empty<ResponseWeather>() => Container(
      height: 100,
      width: 100,
      color: Colors.grey,
    ),
    Error<ResponseWeather>() => Container(
      height: 100,
      width: 100,
      color: Colors.red,
    ),
    Success<ResponseWeather>() => WeatherSuccess(
      location: location,
      weather: (weatherState as Success).data,
    ),
  };
}

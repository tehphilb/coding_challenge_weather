import 'package:coding_challenge_weather/models/forecast_model.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';

class WeeklyForecastRepo {
  final WeatherModel data;

  WeeklyForecastRepo({required this.data});

  Map<String, List<Forecast>> getGroupedForecasts() {
    Map<String, List<Forecast>> groupedForecasts = {};
    DateTime today = DateTime.now();
    DateTime justToday = DateTime(today.year, today.month, today.day);

    for (var forecast in data.forecast) {
      DateTime forecastDate = DateTime.parse(forecast.date.toString());
      DateTime justForecastDate =
          DateTime(forecastDate.year, forecastDate.month, forecastDate.day);

      // Skip the forecast if the date is today
      if (justToday.isAtSameMomentAs(justForecastDate)) {
        continue;
      }

      String formattedDate = forecast.dayName;

      if (!groupedForecasts.containsKey(formattedDate)) {
        groupedForecasts[formattedDate] = [];
      }

      groupedForecasts[formattedDate]!.add(forecast);
    }

    return groupedForecasts;
  }

  Map<String, WeatherData> prepareChartData() {
    Map<String, WeatherData> chartData = {};

    var groupedForecasts = getGroupedForecasts();

    for (var entry in groupedForecasts.entries) {
      String dayName = entry.key;
      List<double> temperatures = [];
      List<String> icons = [];
      List<String> times = [];
      List<double> windSpeeds = [];

      for (var forecast in entry.value) {
        temperatures.add(forecast.temperature.toDouble());
        icons.add(forecast.icon);
        times.add(forecast.formattedTime);
        windSpeeds.add(forecast.windSpeed.toDouble());
      }

      chartData[dayName] = WeatherData(
        temperatures: temperatures,
        icons: icons,
        times: times,
        windSpeeds: windSpeeds,
      );
    }

    return chartData;
  }
}

class WeatherData {
  List<double> temperatures;
  List<String> icons;
  List<String> times;
  List<double> windSpeeds;

  WeatherData({
    required this.temperatures,
    required this.icons,
    required this.times,
    required this.windSpeeds,
  });
}

import 'package:intl/intl.dart';

class Forecast {
  final DateTime date;
  final String formattedDate;
  final String formattedTime;
  final String dayName;
  final int temperature;
  final int minTemp;
  final int maxTemp;
  final String icon;
  final String description;

  Forecast({
    required this.date,
    required this.formattedDate,
    required this.formattedTime,
    required this.dayName,
    required this.temperature,
    required this.minTemp,
    required this.maxTemp,
    required this.icon,
    required this.description,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final dateTime = DateTime.parse(json['dt_txt']);
    final formattedDate = DateFormat('dd. MMM').format(dateTime);
    final formattedTime = DateFormat('HH:mm').format(dateTime);
    final dayName = DateFormat('EEEE').format(dateTime);
    final temperature = (json['main']['temp'].toDouble()).round();
    final minTemp = (json['main']['temp_min'].toDouble()).round();
    final maxTemp = (json['main']['temp_max'].toDouble()).round();
    final description = json['weather'][0]['description'];

    return Forecast(
      date: dateTime,
      formattedDate: formattedDate,
      formattedTime: formattedTime,
      dayName: dayName,
      temperature: temperature,
      minTemp: minTemp,
      maxTemp: maxTemp,
      icon: json['weather'][0]['icon'],
      description: description,
    );
  }

  @override
  String toString() {
    return 'Forecast(date: $date, formattedDate: $formattedDate, formattedTime: $formattedTime, dayName: $dayName, temperature: $temperature, minTemp: $minTemp, maxTemp: $maxTemp, icon: $icon, description: $description)';
  }
}

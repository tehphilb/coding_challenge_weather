import 'package:intl/intl.dart';

class Forecast {
  final DateTime date;
  final String formattedDate;
  final String formattedTime;
  final String dayName;
  final int temperature;
  final String icon;
  final String description;

  Forecast({
    required this.date,
    required this.formattedDate,
    required this.formattedTime,
    required this.dayName,
    required this.temperature,
    required this.icon,
    required this.description,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final dateTime = DateTime.parse(json['dt_txt']);
    final formattedDate = DateFormat('dd MMM').format(dateTime);
    final formattedTime = DateFormat('HH:mm').format(dateTime);
    final dayName = DateFormat('EEEE').format(dateTime);
    final temperature = (json['main']['temp'].toDouble()).round();
    final description = json['weather'][0]['description'];

    return Forecast(
      date: dateTime,
      formattedDate: formattedDate,
      formattedTime: formattedTime,
      dayName: dayName,
      temperature: temperature,
      icon: json['weather'][0]['icon'],
      description: description,
    );
  }
}

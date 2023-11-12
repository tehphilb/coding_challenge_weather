import 'package:intl/intl.dart';

class Forecast {
  final String formattedDate;
  final String formattedTime;
  final int temperature;
  final String icon;

  Forecast({
    required this.formattedDate,
    required this.formattedTime,
    required this.temperature,
    required this.icon,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final dateTime = DateTime.parse(json['dt_txt']);
    final formattedDate = DateFormat('dd MMM').format(dateTime);
    final formattedTime = DateFormat('HH:mm').format(dateTime);

    final temperature = (json['main']['temp'].toDouble()).round();

    return Forecast(
      formattedDate: formattedDate,
      formattedTime: formattedTime,
      temperature: temperature,
      icon: json['weather'][0]['icon'],
    );
  }
}

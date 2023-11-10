// Future<String> fetchWeatherForecast(
//     double lat, double lon, String apiKey) async {
//   final url = Uri.parse(
//       'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey');

//   try {
//     final response = Uri.https(url);

//     if (response.status == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       return response.body;
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to load weather forecast');
//     }
//   } catch (e) {
//     // Handle any errors that occur during the request
//     throw Exception('Failed to load weather forecast: $e');
//   }
// }

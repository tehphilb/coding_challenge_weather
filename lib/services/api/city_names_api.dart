import 'dart:convert';
import 'package:coding_challenge_weather/env/env.dart';
import 'package:coding_challenge_weather/models/city_names_model.dart';
import 'package:http/http.dart' as http;


class CityNamesApi {
  Future<List<CityName>> fetchCityNames(String value) async {
    final queryParameters = {
      'city': value,
    };
    final url =
        Uri.https('api.api-ninjas.com', '/v1/geocoding', queryParameters);

    try {
      final response = await http.get(
        url,
        headers: {
          'X-Api-Key': Env.geoApiKey,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        return json.map((e) => CityName.fromJson(e)).toList();
      } else {
        throw Exception(
            'Failed to load city names. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Caught error: $e'); //TODO: handle error
      rethrow; // Use rethrow to preserve stack trace
    }
  }
}

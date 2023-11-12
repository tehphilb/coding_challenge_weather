import 'dart:convert';
import 'package:coding_challenge_weather/models/city_names_model.dart';
import 'package:http/http.dart' as http;

import 'package:coding_challenge_weather/api_keys.dart';

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
          'X-Api-Key': geoApiKey,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(response.body);
        return json.map((e) => CityName.fromJson(e)).toList();
      } else {
        //print('Request failed with status: ${response.statusCode}.');
        throw Exception(
            'Failed to load city names. Status code: ${response.statusCode}');
      }
    } catch (e) {
      //print('Caught error: $e');
      rethrow; // Use rethrow to preserve stack trace
    }
  }
}

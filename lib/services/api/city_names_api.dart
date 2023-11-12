import 'dart:convert';
import 'package:coding_challenge_weather/models/city_names_model.dart';
import 'package:http/http.dart' as http;

import 'package:coding_challenge_weather/api_keys.dart';

// class CityNamesApi {
//   Future<List<CityNames>> fetchCityNames(String value) async {
//     final url =
//         Uri.parse('https://api.api-ninjas.com/v1/geocoding?city=$value');

//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           'X-Api-Key': geoApiKey,
//         },
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> json = jsonDecode(response.body);
//         return json.map((e) => CityNames.fromJson(e)).toList();
//       } else {
//         throw Exception('Failed to city names');
//       }
//     } catch (e) {
//       throw Exception('Failed to city names: $e');
//     }
//   }
// }


class CityNamesApi {
  Future<List<CityNames>> fetchCityNames(String value) async {
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
        return json.map((e) => CityNames.fromJson(e)).toList();
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to load city names. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Caught error: $e');
      rethrow; // Use rethrow to preserve stack trace
    }
  }
}


import 'package:coding_challenge_weather/env/env.dart';
import 'package:coding_challenge_weather/models/weather_model.dart';
import 'package:dart_openai/dart_openai.dart';

Future<String> runOpenAI(data) async {
  OpenAI.apiKey = Env.openAiKey;

  if (data is WeatherModel) {
    print("Single instance: ${data.toString()}");
  } else if (data is List<WeatherModel>) {
    print("List of instances. Count: ${data.length}");
    for (var weather in data) {
      print(weather.toString());
    }
  } else {
    print("Data is of an unexpected type");
  }

  return 'test';
}

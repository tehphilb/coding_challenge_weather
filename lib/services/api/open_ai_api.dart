import 'package:coding_challenge_weather/env/env.dart';
import 'package:dart_openai/dart_openai.dart';

Future<String> runOpenAI(data) async {
  OpenAI.apiKey = Env.openAiKey;

  // Creates the Edit
  OpenAICompletionModel completion = await OpenAI.instance.completion.create(
    model: "text-davinci-002",
    prompt:
        'Here are some weather data feels like temp.: ${data.feelsLikeTemp}°C, current temp.: ${data.currentTemp}°C, minimal temp.: ${data.minTemp}°, maximal temp.: ${data.maxTemp}°C, description: ${data.description}, wind: ${data.windSpeed}m/s. Summarize the input with a humorous twist to 80 tokens at maximum but not more than 40 words.',
    temperature: 0.8,
    maxTokens: 100,
    n: 2,
  );

  return completion.choices.first.text.trim();
  
  
}

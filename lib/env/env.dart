import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'KEY1')
  static const String weatherApiKey = _Env.weatherApiKey;
  @EnviedField(varName: 'KEY2')
  static const String geoApiKey = _Env.geoApiKey;
  @EnviedField(varName: 'KEY3')
  static const String openAiKey = _Env.openAiKey;
}



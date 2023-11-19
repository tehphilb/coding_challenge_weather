class WeatherIconMapper {
  static String getIconPath(String openWeatherMapIconCode) {
    switch (openWeatherMapIconCode) {
      case '01d':
        return 'assets/icons/svg-static/clear-day.svg';
      case '01n':
        return 'assets/icons/svg-static/clear-night.svg';
      case '02d':
        return 'assets/icons/svg-static/few-clouds-day.svg';
      case '02n':
        return 'assets/icons/svg-static/few-clouds-night.svg';
      case '03d':
        return 'assets/icons/svg-static/scattered-clouds.svg';
      case '03n':
        return 'assets/icons/svg-static/scattered-clouds.svg';
      case '04d':
        return 'assets/icons/svg-static/broken-clouds.svg';
      case '04n':
        return 'assets/icons/svg-static/broken-clouds.svg';
      case '09d':
        return 'assets/icons/svg-static/shower-rain.svg';
      case '09n':
        return 'assets/icons/svg-static/shower-rain.svg';
      case '10d':
        return 'assets/icons/svg-static/rain-day.svg';
      case '10n':
        return 'assets/icons/svg-static/rain-night.svg';
      case '11d':
        return 'assets/icons/svg-static/thunderstorms-day.svg';
      case '11n':
        return 'assets/icons/svg-static/thunderstorms-night.svg';
      case '13d':
        return 'assets/icons/svg-static/snow.svg';
      case '13n':
        return 'assets/icons/svg-static/snow.svg';
      case '50d':
        return 'assets/icons/svg-static/mist.svg';
      case '50n':
        return 'assets/icons/svg/mist.svg';
      default:
        return 'assets/icons/svg/not-available.svg';
    }
  }
}

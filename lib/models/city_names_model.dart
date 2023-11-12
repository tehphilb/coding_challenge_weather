class CityName {
  final String name;
  final double latitude;
  final double longitude;
  final String country;
  final String? state;

  CityName({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
    this.state,
  });

  factory CityName.fromJson(Map<String, dynamic> json) {
    return CityName(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      country: json['country'],
      state: json['state'] ?? json['name'],
    );
  }
}

class CityNames {
  final String name;
  final double latitude;
  final double longitude;
  final String country;
  final String? state;

  CityNames({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
    this.state,
  });

  factory CityNames.fromJson(Map<String, dynamic> json) {
    return CityNames(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      country: json['country'],
      state: json['state'],
    );
  }
}

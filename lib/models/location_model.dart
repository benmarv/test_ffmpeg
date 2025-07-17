class Location {
  double latitude;
  double longitude;
  String address;

  Location({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  /// Convert Location object to a Map
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  /// Create a Location object from a Map
  factory Location.fromJson(Map<String, dynamic> map) {
    return Location(
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
    );
  }

  factory Location.fromString(String jsonString) {
    // Remove curly braces and split by comma
    final parts =
        jsonString.replaceFirst('{', '').replaceFirst('}', '').split(', ');

    // Extract values
    final latitude = double.parse(parts[0].split(':')[1]);
    final longitude = double.parse(parts[1].split(':')[1]);

    // Join remaining parts back together for address
    final addressParts = parts.sublist(2);
    final address = addressParts.join(', ');

    return Location(
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
  }
}

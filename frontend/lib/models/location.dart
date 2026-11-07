class Location {
  final (num, num) coordinates;
  final String? address;
  final String? placeName;

  const Location({
    required this.coordinates,
    required this.address,
    required this.placeName,
  });

  Map<String, dynamic> encode() {
    return {
      "coordinates": [coordinates.$1, coordinates.$2],
      "address": address,
      "placeName": placeName,
    };
  }
}

import "package:frontend/exceptions.dart";
import "package:frontend/models/location.dart";

class Entry {
  final String body;
  final DateTime datetime;
  final List<String> tags;
  final List<String> images;
  final Location? location;

  const Entry({
    required this.body,
    required this.datetime,
    required this.tags,
    required this.images,
    required this.location,
  });

  Entry copyWith({
    String? body,
    DateTime? datetime,
    List<String>? tags,
    List<String>? images,
    Location? location,
  }) {
    return Entry(
      body: body ?? this.body,
      datetime: datetime ?? this.datetime,
      tags: tags ?? this.tags,
      images: images ?? this.images,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> encode() {
    return {
      "body": body,
      "datetime": datetime.toString(),
      "tags": tags,
      "images": tags,
      "location": location?.encode(),
    };
  }
}

Entry parseEntryObject(dynamic obj) {
  if (obj is! Map) throw ResponseNotMapException(obj);
  final body = obj["body"];
  final datetime = DateTime.parse(obj["datetime"]);
  final tags = List<String>.from(obj["tags"]);
  final images = List<String>.from(obj["images"]);
  var location = obj["location"];
  if (body is! String) throw ResponseValueInvalidException<String>(body);
  if (location is! Map && location != null) {
    throw ResponseValueInvalidException<Map>(location);
  }

  dynamic coordinates;
  dynamic address;
  dynamic placeName;
  bool hasLocation = false;

  if (location is Map) {
    coordinates = List<num>.from(location["coordinates"]);
    address = location["address"];
    placeName = location["placeName"];

    if (coordinates is! List<num>) {
      throw ResponseValueInvalidException<List<num>>(coordinates);
    }
    if (address is! String && address != null) {
      throw ResponseValueInvalidException<String>(address);
    }
    if (placeName is! String && placeName != null) {
      throw ResponseValueInvalidException<String>(placeName);
    }
    if (coordinates.length != 2) throw Error();
    coordinates = (coordinates[0], coordinates[1]);
    hasLocation = true;
  }

  location = hasLocation
      ? Location(
          coordinates: coordinates,
          address: address,
          placeName: placeName,
        )
      : null;

  return Entry(
    body: body,
    datetime: datetime,
    images: images,
    tags: tags,
    location: location,
  );
}

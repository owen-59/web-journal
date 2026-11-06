import "dart:ffi";

import "package:frontend/exceptions.dart";
import "package:zard/zard.dart";

class Location {
  final (num, num) coordinates;
  final String? address;
  final String? placeName;

  const Location({
    required this.coordinates, 
    required this.address, 
    required this.placeName
  });
}

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
}

final locationSchema = z.map({
  "coordinates": z.list(z.num()).min(2).max(2),
  "address": z.string().optional(),
  "placeName": z.string().optional(),
});

final entrySchema = z.map({
  "body": z.string(),
  "datetime": z.date(),
  "tags": z.list(z.string()),
  "images": z.list(z.string()),
  "location": locationSchema,
});

final entryType = z.inferType<Entry>(
  fromMap: (m) => Entry(
    body: m["body"],
    datetime: m["datetime"],
    tags: m["tags"],
    images: m["images"],
    location: m["location"],
  ),
  mapSchema: entrySchema,
);

Entry parseEntryObject(dynamic obj) {
  if (obj is! Map) throw ResponseNotMapException(obj);
  final body = obj["body"] ;
  final datetime = obj["datetime"];
  final tags = obj["tags"];
  final images = obj["images"];
  final location = obj["location"];
  if (body is! String) throw ResponseValueInvalidException<String>(body);
  if (datetime is! DateTime) throw ResponseValueInvalidException<DateTime>(datetime);
  if (tags is! List<String>) throw ResponseValueInvalidException<List<String>>(tags);
  if (images is! String) throw ResponseValueInvalidException<List<String>>(images);
  if (location is! Map && location != null) {
    throw ResponseValueInvalidException<Map>(location);
  }

  dynamic coordinates;
  dynamic address;
  dynamic placeName;
  bool hasLocation = false;

  if (location is Map) {
    coordinates = location["coordinates"];
    address = location["address"];
    placeName = location["placeName"];

    if (coordinates is! List<num>) throw ResponseValueInvalidException<List<num>>(coordinates);
    if (address is! String && address != null) throw ResponseValueInvalidException<String>(address);
    if (placeName is! String && placeName != null) throw ResponseValueInvalidException<String>(placeName);
    hasLocation = true;
  }

  final location = hasLocation : Location(
    coordinates: ,
    address: address,
  );


  return entryType.parse(obj);
  // final entry = entrySchema.parse(obj);
  // return Entry(
  //   body: entry["body"],
  //   datetime: entry["datetime"],
  //   tags: entry["tags"],
  //   images: entry["images"],
  //   location: entry["location"],
  // );
}

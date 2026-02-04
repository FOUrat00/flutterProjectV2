import 'package:latlong2/latlong.dart';

class Property {
  final String id;
  final String title;
  final List<String> images;
  final double price;
  final int bedrooms;
  final String location;
  final LatLng locationCoords;
  final double rating;
  final String description;
  final String propertyType;
  final int bathrooms;
  final double area;

  Property({
    required this.id,
    required this.title,
    required this.images,
    required this.price,
    required this.bedrooms,
    required this.location,
    required this.locationCoords,
    required this.rating,
    required this.description,
    required this.propertyType,
    required this.bathrooms,
    required this.area,
  });
}

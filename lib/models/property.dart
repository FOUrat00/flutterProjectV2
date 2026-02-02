import 'package:latlong2/latlong.dart';

/// ========================================
/// PROPERTY MODEL
/// Student Housing Data Model
/// ========================================

class Property {
  final String id;
  final String title;
  final List<String> images;
  final double price;
  final int bedrooms;
  final String location;
  final LatLng locationCoords; // Geo-coordinates for map
  final double rating;
  final String description;
  final String propertyType;
  final int bathrooms;
  final double area; // in square meters

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


// PropertyData moved to lib/data/json_data.dart


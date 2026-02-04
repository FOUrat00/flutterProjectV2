import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants/app_theme.dart';
import '../models/property.dart';
import '../pages/property_details_page.dart';

class PropertyMap extends StatelessWidget {
  final List<Property> properties;

  const PropertyMap({
    Key? key,
    required this.properties,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: const LatLng(43.7262, 12.6366),
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.urbino.housing',
        ),
        MarkerLayer(
          markers: properties.map((property) {
            return Marker(
              point: property.locationCoords,
              width: 80,
              height: 40,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PropertyDetailsPage(property: property),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: UrbinoColors.darkBlue,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [UrbinoShadows.medium],
                    border: Border.all(
                      color: UrbinoColors.white,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '€${property.price.toInt()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

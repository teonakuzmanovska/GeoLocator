import 'dart:convert';

import 'package:coordinate_viewer/env/env.dart';
import 'package:coordinate_viewer/models/geocoding_model.dart';
import 'package:http/http.dart' as http;


// should implement when map API is functional
class GeocodingService {
  final List<GeocodingModel> objects;
  Map<String, String> pickupCoordinates = {};
  Map<String, String> shippingCoordinates = {};

  GeocodingService({required this.objects});

  Future<void> getCoordinates() async {
    final String apiKey = Env.googleApiKey; // Replace with your Google Maps Geocoding API key

    for (final object in objects) {
      final id = object.id;
      final pickupAddress = object.pickupAddress;
      final shippingAddress = object.shippingAddress;

// response from get request for pickup address coordinates
      final pickupResponse = await http.get(Uri.https(
        'maps.googleapis.com',
        '/maps/api/geocode/json',
        {'address': pickupAddress, 'key': apiKey},
      ));

      if (pickupResponse.statusCode == 200) {
        final pickupJsonResult = jsonDecode(pickupResponse.body);
        final pickupResults = pickupJsonResult['results'];

        if (pickupResults.isNotEmpty) {
          final pickupLocation = pickupResults[0]['geometry']['location'];
          final pickupLatitude = pickupLocation['lat'];
          final pickupLongitude = pickupLocation['lng'];
          pickupCoordinates[id] =
              'Latitude: $pickupLatitude, Longitude: $pickupLongitude';
        } else {
          pickupCoordinates[id] = 'Coordinates not found';
        }
      } else {
        pickupCoordinates[id] = 'Error retrieving coordinates';
      }

// response from get request for shipping address coordinates

      final shippingResponse = await http.get(Uri.https(
        'maps.googleapis.com',
        '/maps/api/geocode/json',
        {'address': shippingAddress, 'key': apiKey},
      ));

      if (shippingResponse.statusCode == 200) {
        final shippingJsonResult = jsonDecode(shippingResponse.body);
        final shippingResults = shippingJsonResult['results'];

        if (shippingResults.isNotEmpty) {
          final shippingLocation = shippingResults[0]['geometry']['location'];
          final shippingLatitude = shippingLocation['lat'];
          final shippingLongitude = shippingLocation['lng'];
          shippingCoordinates[id] =
              'Latitude: $shippingLatitude, Longitude: $shippingLongitude';
        } else {
          shippingCoordinates[id] = 'Coordinates not found';
        }
      } else {
        shippingCoordinates[id] = 'Error retrieving coordinates';
      }
    }
  }
}

import 'package:coordinate_viewer/models/geocoding_model.dart';
import 'package:coordinate_viewer/services/geocoding_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GeocodingService addressService;

  @override
  void initState() {
    super.initState();
    // object instances in List of object models
    final List<GeocodingModel> objects = [
      GeocodingModel(
        id: '1',
        pickupAddress: '123 Main Street',
        shippingAddress: 'Ilindenska',
      ),
      GeocodingModel(
        id: '2',
        pickupAddress: 'Partizanska',
        shippingAddress: '123 Main Street',
      ),
      // Add more objects as needed
    ];

// instance of AddressService class
    addressService = GeocodingService(objects: objects);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Coordinates'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Get Coordinates'),
              onPressed: () async {
                // calling getCoordinates method from AddressService class
                await addressService.getCoordinates();
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: addressService.objects.length,
                itemBuilder: (context, index) {
                  // acccessing values from object keys
                  final object = addressService.objects[index];
                  final id = object.id;
                  final pickupAddress = object.pickupAddress;
                  final shippingAddress = object.shippingAddress;
                  final pickupCoordinate =
                      addressService.pickupCoordinates[id] ?? '';
                  final shippingCoordinate =
                      addressService.shippingCoordinates[id] ?? '';
                  // rendering the values from object keys on screen
                  return ListTile(
                    title: Text('ID: $id'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pickup Address: $pickupAddress'),
                        Text('Pickup Coordinate: $pickupCoordinate'),
                        Text('Shipping Address: $shippingAddress'),
                        Text('Shipping Coordinate: $shippingCoordinate'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

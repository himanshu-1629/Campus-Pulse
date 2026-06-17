import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherLocationScreen extends StatelessWidget {
  final String teacherName;
  final double latitude;
  final double longitude;

  const TeacherLocationScreen({
    super.key,
    required this.teacherName,
    required this.latitude,
    required this.longitude,
  });

  Future<void> openDirections() async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=walking';

    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teacherName),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  latitude,
                  longitude,
                ),
                zoom: 18,
              ),
              markers: {
                Marker(
                  markerId:
                      const MarkerId('teacher'),
                  position: LatLng(
                    latitude,
                    longitude,
                  ),
                  infoWindow: InfoWindow(
                    title: teacherName,
                  ),
                  icon: BitmapDescriptor
                      .defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue,
                  ),
                ),
              },
            ),
          ),

         Container(
  padding: const EdgeInsets.fromLTRB(
    20,
    12,
    20,
    60,
  ),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 10,
      ),
    ],
  ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    openDirections,
                icon: const Icon(
                  Icons.directions,
                ),
                label: const Text(
                  'Get Directions',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_db_service.dart';
import '../services/location_service.dart';
import '../services/friend_service.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final String userId;

  final double? zoneLatitude;
  final double? zoneLongitude;
  final double? zoneRadius;
  final String? zoneName;

  const MapScreen({
    super.key,
    required this.userId,
    this.zoneLatitude,
    this.zoneLongitude,
    this.zoneRadius,
    this.zoneName,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final locationService = LocationService();
final locationDbService = LocationDbService();
final friendService = FriendService();
Future<void> openDirections(
  double latitude,
  double longitude,
) async {
  final url =
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=walking';

  await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  );
}
List<Map<String, dynamic>> friends = [];
  Position? position;
  Timer? refreshTimer;
Set<Marker> markers = {};
Set<Circle> circles = {};
@override
void initState() {
  super.initState();

  loadFriendsAndLocation();

  refreshTimer = Timer.periodic(
    const Duration(seconds: 5),
    (_) {
      loadFriendsAndLocation();
    },
  );
}
@override
void dispose() {
  refreshTimer?.cancel();
  super.dispose();
}
Future<void> loadFriendsAndLocation() async {
  friends = await friendService.getFriends(
    widget.userId,
  );

  await loadLocation();
}
Future<void> loadLocation() async {
  
  final currentLocation =
      await locationService.getCurrentLocation();

  if (currentLocation != null) {
    await locationDbService.updateLocation(
      userId: widget.userId,
      latitude: currentLocation.latitude,
      longitude: currentLocation.longitude,
    );
  }

  final locations =
      await locationDbService.getAllLocations();

  Set<Marker> loadedMarkers = {};

  for (final location in locations) {

  if (location['user_id'] == widget.userId) {
    continue;
  }
  final userInfo =
    await locationDbService.getUserInfo(
  location['user_id'],
);


  if (widget.zoneLatitude != null &&
    widget.zoneLongitude != null &&
    widget.zoneRadius != null) {

  final distance =
      Geolocator.distanceBetween(
    widget.zoneLatitude!,
    widget.zoneLongitude!,
    location['latitude'],
    location['longitude'],
  );

  if (distance > widget.zoneRadius!) {
    continue;
  }
}
    bool isFriend = friends.any(
  (friend) => friend['id'] == location['user_id'],
);

String markerTitle;

if (isFriend) {
  markerTitle =
    '${friends.firstWhere(
      (friend) =>
          friend['id'] ==
          location['user_id'],
    )['name']} (Friend)';
} else if (userInfo['role'] == 'Teacher') {
if (userInfo['teacher_status'] ==
    'Available') {

  markerTitle =
      '${userInfo['name']} (Teacher)';

} else {

  markerTitle = 'Teacher';

}
}else {
  markerTitle = 'Student';
}double markerColor;

if (isFriend) {
  markerColor =
      BitmapDescriptor.hueGreen;
} else if (userInfo['role'] == 'Teacher') {
  markerColor =
      BitmapDescriptor.hueBlue;
} else {
  markerColor =
      BitmapDescriptor.hueRed;
}

   loadedMarkers.add(
  Marker(
    markerId: MarkerId(
      location['user_id'],
    ),
    position: LatLng(
      location['latitude'],
      location['longitude'],
    ),
   icon: BitmapDescriptor.defaultMarkerWithHue(
  markerColor,
),
    onTap: () {
if (widget.zoneLatitude != null) {
    return;
  }
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
   backgroundColor: Colors.transparent,
      builder: (_) {
      return Container(
  margin: const EdgeInsets.only(
    left: 12,
    right: 12,
    bottom: 25,
  ),
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(28),
  ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Container(
  width: 50,
  height: 5,
  decoration: BoxDecoration(
    color: Colors.grey.shade400,
    borderRadius: BorderRadius.circular(20),
  ),
),

const SizedBox(height: 15),
if (isFriend)
  Column(
    children: [
      Text(
        friends.firstWhere(
          (friend) =>
              friend['id'] ==
              location['user_id'],
        )['name'],
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const Text(
        'Friend',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    ],
  )
else if (userInfo['role'] == 'Teacher')
  Column(
    children: [
      Text(
        userInfo['teacher_status'] ==
                'Available'
            ? userInfo['name']
            : 'Teacher',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      if (userInfo['teacher_status'] ==
          'Available')
        const Text(
          'Teacher',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
    ],
  )
else
  const Text(
    'Student',
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

              const SizedBox(
                height: 15,
              ),
if (isFriend ||
    (userInfo['role'] == 'Teacher' &&
     userInfo['teacher_status'] ==
         'Available'))
              ElevatedButton.icon(
                onPressed: () {
                  openDirections(
                    location['latitude'],
                    location['longitude'],
                  );
                },
                icon: const Icon(
                  Icons.directions,
                ),
                label: const Text(
                  'Get Directions',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ),
);
  }

  Set<Circle> loadedCircles = {};

if (widget.zoneLatitude != null &&
    widget.zoneLongitude != null &&
    widget.zoneRadius != null) {
  loadedCircles.add(
    Circle(
      circleId: const CircleId(
        'zone',
      ),
      center: LatLng(
        widget.zoneLatitude!,
        widget.zoneLongitude!,
      ),
      radius: widget.zoneRadius!,
      strokeWidth: 3,
      fillColor:
          Colors.blue.withOpacity(0.15),
    ),
  );
}

if (!mounted) return;

setState(() {
  position = currentLocation;
  markers = loadedMarkers;
  circles = loadedCircles;
});
}

  @override
  Widget build(BuildContext context) {
    if (position == null) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text(
            'Loading map and location...',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}

    return Scaffold(
      appBar: AppBar(
  title: Text(
    widget.zoneName ??
        'Campus Pulse Map',
  ),
  actions: [
    IconButton(
      icon: const Icon(
        Icons.refresh,
      ),
      onPressed: () async {
        await loadFriendsAndLocation();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          const SnackBar(
            content: Text(
              'Map refreshed',
            ),
            duration:
                Duration(seconds: 1),
          ),
        );
      },
    ),
  ],
),
      body: GoogleMap(
        circles: circles,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: markers,
        initialCameraPosition: CameraPosition(
  target: LatLng(
    widget.zoneLatitude ??
        position!.latitude,
    widget.zoneLongitude ??
        position!.longitude,
  ),
  zoom: 17.5,
),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import 'map_screen.dart';
import 'friends_screen.dart';
import 'crowd_list_screen.dart';
import 'dart:async';
import '../services/location_db_service.dart';
import '../services/teacher_service.dart';
import 'login_screen.dart';
import 'teacher_finder_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomeScreen extends StatefulWidget {
  final String userId;
  final String name;
  final String role;

  const HomeScreen({
    super.key,
    required this.userId,
    required this.name,
    required this.role,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final locationService = LocationService();

  Position? position;
Timer? locationTimer;

final locationDbService =
    LocationDbService();
    final teacherService =
    TeacherService();

String teacherStatus =
    'Not Available';
  @override
  void initState() {
  super.initState();

  loadTeacherStatus();

  locationTimer = Timer.periodic(
    const Duration(seconds: 15),
    (_) {
      updateLocationInBackground();
    },
  );
}
  @override
void dispose() {
  locationTimer?.cancel();
  super.dispose();
}
Future<void> loadTeacherStatus() async {
  if (widget.role != 'Teacher') return;

  final status =
      await teacherService
          .getTeacherStatus(
    widget.userId,
  );

  setState(() {
    teacherStatus = status;
  });
}
Future<void> updateLocationInBackground() async {
  final permission =
    await Geolocator.checkPermission();

if (permission ==
        LocationPermission.denied ||
    permission ==
        LocationPermission.deniedForever) {
  return;
}
  final currentLocation =
      await locationService.getCurrentLocation();

  if (currentLocation == null) return;

  await locationDbService.updateLocation(
    userId: widget.userId,
    latitude: currentLocation.latitude,
    longitude: currentLocation.longitude,
  );
}
  Future<void> loadLocation() async {
    final currentLocation =
        await locationService.getCurrentLocation();

    setState(() {
      position = currentLocation;
    });
  }
Widget dashboardCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return Card(
  color: Colors.white,
  elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    child: ListTile(
      leading: Icon(
        icon,
        size: 35,
        color: Colors.blue,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.arrow_forward_ios,
      ),
      onTap: onTap,
    ),
  );
}
Future<bool> openFeature() async {
  final permission =
      await Geolocator.checkPermission();

  if (permission ==
          LocationPermission.denied ||
      permission ==
          LocationPermission.deniedForever) {

    final shouldContinue =
        await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              '📍 Location Required',
            ),
            content: const Text(
              'Campus Pulse requires location access for Maps, Teacher Finder, Friends and Crowd Analytics.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    false,
                  );
                },
                child:
                    const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    true,
                  );
                },
                child: const Text(
                  'Continue',
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldContinue) {
      return false;
    }

    final newPermission =
        await Geolocator
            .requestPermission();

    if (newPermission ==
            LocationPermission.denied ||
        newPermission ==
            LocationPermission.deniedForever) {
      return false;
    }
  }

  return true;
}
  @override
  Widget build(BuildContext context) {
   return Scaffold(
  backgroundColor: Colors.transparent,
      appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  foregroundColor: Colors.white,
 title: Row(
  children: [
    const Icon(
      Icons.hub,
      color: Colors.white,
      size: 30,
    ),
    const SizedBox(width: 10),
    const Text(
      'Campus Pulse',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    ),
  ],
),
  actions: [
    IconButton(
      icon: const Icon(
    Icons.logout_rounded,
    size: 28,
  ),
       onPressed: () async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
      (route) => false,
    );
  },
    ),
  ],
),
    body: Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0F172A),
        Color(0xFF1E3A8A),
        Color(0xFF2563EB),
      ],
    ),
  ),
  child: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    Card(
  color: Colors.white,
  elevation: 8,
  shape: RoundedRectangleBorder(
    borderRadius:
        BorderRadius.circular(20),
  ),
  child: Padding(
    padding:
        const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome ${widget.name} 👋',
          style:
              const TextStyle(
            fontSize: 24,
            fontWeight:
                FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.role,
          style:
              const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.green,
            ),
            SizedBox(width: 5),
            Text(
              'Live Tracking Active',
            ),
          ],
        ),
      ],
    ),
  ),
),

const SizedBox(height: 20),
if (widget.role == 'Teacher')
  Card(
  color: Colors.white,
  elevation: 6,
  child: Padding(
      padding:
          const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Teacher Status',
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: teacherStatus,
            isExpanded: true,
            items: const [
              DropdownMenuItem(
                value: 'Available',
                child:
                    Text('🟢 Available'),
              ),
              DropdownMenuItem(
                value: 'In Class',
                child:
                    Text('📚 In Class'),
              ),
              DropdownMenuItem(
                value: 'In Meeting',
                child:
                    Text('🟡 In Meeting'),
              ),
              DropdownMenuItem(
                value: 'Lunch Break',
                child:
                    Text('🍽️ Lunch Break'),
              ),
              DropdownMenuItem(
                value: 'In Office',
                child:
                    Text('🏢 In Office'),
              ),
              DropdownMenuItem(
                value:
                    'Not Available',
                child: Text(
                  '🔴 Not Available',
                ),
              ),
            ],
            onChanged: (
              value,
            ) async {
              if (value == null) {
                return;
              }

              await teacherService
                  .updateTeacherStatus(
                userId:
                    widget.userId,
                status: value,
              );

              setState(() {
                teacherStatus = value;
              });
            },
          ),
        ],
      ),
    ),
  ),


      const SizedBox(height: 30),
dashboardCard(
  icon: Icons.map,
  title: 'Map View',
  subtitle: 'Live campus tracking',
onTap: () async {

  if (!await openFeature()) {
    return;
  }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(
          userId: widget.userId,
        ),
      ),
    );
  },
),

      const SizedBox(height: 15),

   dashboardCard(
  icon: Icons.groups,
  title: 'Crowd Density',
  subtitle:
      'Monitor campus crowd levels',
  onTap: () async {

  if (!await openFeature()) {
    return;
  }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CrowdListScreen(
          userId:
              widget.userId,
        ),
      ),
    );
  },
),

      const SizedBox(height: 15),

     dashboardCard(
  icon: Icons.person_search,
  title: 'Teacher Finder',
  subtitle:
      'Locate available faculty',
  onTap: () async {

  if (!await openFeature()) {
    return;
  }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const TeacherFinderScreen(),
      ),
    );
  },
),

      const SizedBox(height: 15),

  dashboardCard(
  icon: Icons.people,
  title: 'Friends',
  subtitle:
      'Manage friends & requests',
  onTap: () async {

  if (!await openFeature()) {
    return;
  }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            FriendsScreen(
          userId:
              widget.userId,
        ),
      ),
    );
  },
),
const SizedBox(height: 20),
Card(
  color: Colors.white,
  elevation: 6,
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Text(
      '📍 Upcoming: Automatic Campus Geofencing - Users outside campus will be automatically hidden from crowd analytics and live maps.',
      style: const TextStyle(
        fontSize: 13,
      ),
    ),
  ),
),
    ],
  ),
),
),
),
);
}
}
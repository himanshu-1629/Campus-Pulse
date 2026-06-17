import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'map_screen.dart';
import '../services/zone_service.dart';
import '../services/location_db_service.dart';
import 'dart:async';
class CrowdListScreen extends StatefulWidget {
  final String userId;

  const CrowdListScreen({
    super.key,
    required this.userId,
  });
  @override
  State<CrowdListScreen> createState() =>
      _CrowdListScreenState();
}

class _CrowdListScreenState
    extends State<CrowdListScreen> {
  final zoneService = ZoneService();
  final locationDbService =
      LocationDbService();

  List<Map<String, dynamic>> zones = [];
Timer? refreshTimer;
  @override
  @override
void initState() {
  super.initState();

  loadZones();

  refreshTimer = Timer.periodic(
    const Duration(seconds: 15),
    (_) {
      loadZones();
    },
  );
}
@override
void dispose() {
  refreshTimer?.cancel();
  super.dispose();
}

  Future<void> loadZones() async {
    final zoneData =
        await zoneService.getZones();

    final locations =
        await locationDbService
            .getAllLocations();

    for (final zone in zoneData) {
      int count = 0;

      for (final location in locations) {
        final distance =
            Geolocator.distanceBetween(
          zone['latitude'],
          zone['longitude'],
          location['latitude'],
          location['longitude'],
        );

        if (distance <= zone['radius']) {
          count++;
        }
      }

      zone['student_count'] = count;
    }
zoneData.sort(
  (a, b) => (b['student_count'] as int)
      .compareTo(
    a['student_count'] as int,
  ),
);
    setState(() {
      zones = zoneData;
    });
  }

  String getCrowdStatus(int count) {
    if (count < 8) {
      return '🟢 Low Crowd';
    }

    if (count < 15) {
      return '🟡 Medium Crowd';
    }

    return '🔴 High Crowd';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crowd Density',
        ),
      ),
      body: zones.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: zones.length,
              itemBuilder: (
                context,
                index,
              ) {
                final zone =
                    zones[index];

                final count =
                    zone['student_count'] ?? 0;

                return Card(
                  margin:
                      const EdgeInsets.all(
                    10,
                  ),
                  child: ListTile(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(
          userId: widget.userId,
          zoneLatitude: zone['latitude'],
          zoneLongitude: zone['longitude'],
          zoneRadius:
              (zone['radius'] as num)
                  .toDouble(),
          zoneName: zone['name'],
        ),
      ),
    );
  },
  title: Text(
    zone['name'],
  ),
  subtitle: Text(
    '$count Active Users\n${getCrowdStatus(count)}',
  ),
  trailing: const Icon(
    Icons.arrow_forward_ios,
  ),
),
                );
              },
            ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:deepind/util/getLocation.dart';

class MapPage extends StatefulWidget {
  final Map<String, String> schoolAddresses;
  final Function(Function(String))? onSearchSchool;
  
  const MapPage({super.key, required this.schoolAddresses, this.onSearchSchool});

  @override
  // ignore: library_private_types_in_public_api
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? currentLocation;
  Map<String, LatLng> schoolLocations = {};
  bool isLoading = true;
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _initializeMap();
    if (widget.onSearchSchool != null) {
      widget.onSearchSchool!(moveToAddress);
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 비활성화되어 있을 때 처리
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 권한이 거부되었을 때 처리
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 권한이 영구적으로 거부되었을 때 처리
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    currentLocation = LatLng(position.latitude, position.longitude);
  }

  Future<void> _initializeMap() async {
    try {
      await _getCurrentLocation();
      await _getSchoolLocations();
    } catch (e) {
      print('지도 초기화 중 오류 발생: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getSchoolLocations() async {
    for (var entry in widget.schoolAddresses.entries) {
      try {
        Map<String, double?> loc = await getCoordinatesFromAddress(entry.value);
        schoolLocations[entry.key] = LatLng(loc['latitude']!, loc['longitude']!);
      } catch (e) {
        print('${entry.key}의 위치를 가져오는 데 실패했습니다: $e');
      }
    }
  }

  void moveToAddress(String schoolName) {
    if (schoolLocations.containsKey(schoolName)) {
      mapController.move(schoolLocations[schoolName]!, 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          if (currentLocation != null)
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                  pinchZoomThreshold: 0.5,
                ),
                initialCenter: currentLocation!,
                initialZoom: 15.0,
                maxZoom: 17.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: schoolLocations.entries.map((entry) => 
                    Marker(
                      point: entry.value,
                      width: 80,
                      height: 80,
                      child: GestureDetector(
                        onTap: () => _showMarkerInfo(context, entry.key, entry.value),
                        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                      ),
                    )
                  ).toList(),
                ),
              ],
            ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  backgroundColor: const Color(0xFFF3F4F6),
                  child: const Icon(Icons.add),
                  onPressed: () {
                    final zoom = mapController.camera.zoom + 0.5;
                    mapController.move(mapController.camera.center, zoom);
                  },
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  backgroundColor: const Color(0xFFF3F4F6),
                  child: const Icon(Icons.remove),
                  onPressed: () {
                    final zoom = mapController.camera.zoom - 0.5;
                    mapController.move(mapController.camera.center, zoom);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMarkerInfo(BuildContext context, String schoolName, LatLng location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF3F4F6),
          title: Text(schoolName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('주소: ${widget.schoolAddresses[schoolName]}'),
              const SizedBox(height: 8),
              Text('위도: ${location.latitude.toStringAsFixed(6)}'),
              Text('경도: ${location.longitude.toStringAsFixed(6)}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gujarat Bus Route Map',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final MapController mapController;
  LatLng? currentLocation;
  bool isLoadingLocation = false;

  // Bus stop locations in Gujarat
  final List<LatLng> busStops = [
    LatLng(22.5645, 72.9289), // Anand
    LatLng(22.6939, 72.8614), // Nadiad
    LatLng(22.3072, 73.1812), // Vadodara
  ];

  final List<String> busStopNames = [
    'Anand Bus Stop',
    'Nadiad Bus Stop',
    'Vadodara Bus Stop',
  ];

  @override
  void initState() {
    super.initState();
    mapController = MapController();

    // Add a small delay to ensure the map is built before fitting bounds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fitMapToBounds();
    });
  }

  void _fitMapToBounds() {
    if (busStops.isNotEmpty) {
      double minLat = busStops
          .map((p) => p.latitude)
          .reduce((a, b) => a < b ? a : b);
      double maxLat = busStops
          .map((p) => p.latitude)
          .reduce((a, b) => a > b ? a : b);
      double minLng = busStops
          .map((p) => p.longitude)
          .reduce((a, b) => a < b ? a : b);
      double maxLng = busStops
          .map((p) => p.longitude)
          .reduce((a, b) => a > b ? a : b);

      LatLngBounds bounds = LatLngBounds(
        LatLng(minLat, minLng),
        LatLng(maxLat, maxLng),
      );

      mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50.0)),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationError(
          'Location services are disabled. Please enable them in settings.',
        );
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationError('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationError(
          'Location permissions are permanently denied. Please enable them in settings.',
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });

      // Move camera to current location
      mapController.move(currentLocation!, 15.0);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Current location found!'),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _showLocationError('Failed to get location: ${e.toString()}');
    } finally {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  void _showLocationError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 4),
        ),
      );
    }
    setState(() {
      isLoadingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gujarat Bus Route Map',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out_map, color: Colors.white),
            onPressed: _fitMapToBounds,
            tooltip: 'Fit to route',
          ),
          IconButton(
            icon: isLoadingLocation
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.my_location, color: Colors.white),
            onPressed: isLoadingLocation ? null : _getCurrentLocation,
            tooltip: 'Get current location',
          ),
        ],
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: LatLng(22.5645, 72.9289), // Center on Anand initially
          initialZoom: 10.0,
          minZoom: 5.0,
          maxZoom: 18.0,
        ),
        children: [
          // OpenStreetMap tile layer
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.open_street_map',
            maxZoom: 18,
          ),

          // Polyline connecting bus stops
          PolylineLayer(
            polylines: [
              Polyline(
                points: busStops,
                strokeWidth: 4.0,
                color: Colors.red,
                pattern: StrokePattern.dashed(segments: [20, 20]),
              ),
            ],
          ),

          // Bus stop markers
          MarkerLayer(
            markers: [
              // Bus stop markers
              ...busStops.asMap().entries.map((entry) {
                int index = entry.key;
                LatLng point = entry.value;
                String name = busStopNames[index];

                return Marker(
                  width: 60.0,
                  height: 60.0,
                  point: point,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(name),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.blue.shade700,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.directions_bus,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                );
              }),

              // Current location marker
              if (currentLocation != null)
                Marker(
                  width: 60.0,
                  height: 60.0,
                  point: currentLocation!,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Your Current Location'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.green.shade700,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      // Floating action button to show route info
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showRouteInfo();
        },
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.info_outline),
        label: const Text('Route Info'),
      ),
    );
  }

  void _showRouteInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Gujarat Bus Route',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bus Stops:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...busStopNames.asMap().entries.map((entry) {
                int index = entry.key;
                String name = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(name)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              const Text(
                '• Tap markers for bus stop names\n'
                '• Red dashed line shows the route\n'
                '• Use the zoom button to fit the route\n'
                '• Tap location button to show your position',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.blue.shade700),
              ),
            ),
          ],
        );
      },
    );
  }
}

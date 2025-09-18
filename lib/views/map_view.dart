import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location_model.dart';

class MapView extends StatefulWidget {
  final List<LocationModel> locations;

  const MapView({Key? key, required this.locations}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _createMarkersAndPolylines();
  }

  void _createMarkersAndPolylines() {
    // Create markers
    for (int i = 0; i < widget.locations.length; i++) {
      final location = widget.locations[i];
      _markers.add(
        Marker(
          markerId: MarkerId(location.id),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: location.name,
            snippet: location.description,
          ),
        ),
      );
    }

    // Create solid polyline connecting all locations
    if (widget.locations.length > 1) {
      List<LatLng> polylineCoordinates = widget.locations
          .map((loc) => LatLng(loc.latitude, loc.longitude))
          .toList();

      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 5, // thicker solid line
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.locations.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Map View'),
        ),
        body: Center(
          child: Text('No locations to display on map'),
        ),
      );
    }

    // Calculate center point and zoom level
    double minLat = widget.locations.first.latitude;
    double maxLat = widget.locations.first.latitude;
    double minLng = widget.locations.first.longitude;
    double maxLng = widget.locations.first.longitude;

    for (var location in widget.locations) {
      minLat = minLat < location.latitude ? minLat : location.latitude;
      maxLat = maxLat > location.latitude ? maxLat : location.latitude;
      minLng = minLng < location.longitude ? minLng : location.longitude;
      maxLng = maxLng > location.longitude ? maxLng : location.longitude;
    }

    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;

    return Scaffold(
      appBar: AppBar(
        title: Text('Map View (${widget.locations.length} locations)'),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: _fitAllMarkers,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(centerLat, centerLng),
          zoom: 10,
        ),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          _fitAllMarkers();
        },
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    height: 300,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Favorite Locations',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.locations.length,
                            itemBuilder: (context, index) {
                              final location = widget.locations[index];
                              return ListTile(
                                leading:
                                    Icon(Icons.location_on, color: Colors.blue),
                                title: Text(location.name),
                                subtitle: Text(location.description),
                                onTap: () {
                                  Navigator.pop(context);
                                  _goToLocation(location);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: Icon(Icons.list),
              label: Text('Locations'),
            ),
          ],
        ),
      ),
    );
  }

  void _fitAllMarkers() {
    if (_controller != null && widget.locations.isNotEmpty) {
      if (widget.locations.length == 1) {
        _controller!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                widget.locations.first.latitude,
                widget.locations.first.longitude,
              ),
              zoom: 15,
            ),
          ),
        );
      } else {
        double minLat = widget.locations.first.latitude;
        double maxLat = widget.locations.first.latitude;
        double minLng = widget.locations.first.longitude;
        double maxLng = widget.locations.first.longitude;

        for (var location in widget.locations) {
          minLat = minLat < location.latitude ? minLat : location.latitude;
          maxLat = maxLat > location.latitude ? maxLat : location.latitude;
          minLng = minLng < location.longitude ? minLng : location.longitude;
          maxLng = maxLng > location.longitude ? maxLng : location.longitude;
        }

        _controller!.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(minLat, minLng),
              northeast: LatLng(maxLat, maxLng),
            ),
            100.0,
          ),
        );
      }
    }
  }

  void _goToLocation(LocationModel location) {
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 15,
        ),
      ),
    );
  }
}

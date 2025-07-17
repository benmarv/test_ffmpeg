import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindDistanceByGoogleMap extends StatefulWidget {
  const FindDistanceByGoogleMap(
      {super.key, required this.lat, required this.long});
  final double lat;
  final double long;

  @override
  State<FindDistanceByGoogleMap> createState() =>
      _FindDistanceByGoogleMapState();
}

class _FindDistanceByGoogleMapState extends State<FindDistanceByGoogleMap> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  // final Set<Polyline> _polylines = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    setState(() {
      _markers.add(marker);
    });
  }

  // void _addPolyLine(List<LatLng> polylineCoordinates) {
  //   PolylineId id = const PolylineId("poly");
  //   Polyline polyline =
  //       Polyline(polylineId: id, points: polylineCoordinates, width: 8);
  //   setState(() {
  //     _polylines.add(polyline);
  //   });
  // }

  // void _getPolyline() async {
  //   List<LatLng> polylineCoordinates = [];
  //   PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
  //     "AIzaSyAynawpUDP4PSEw4fd70ilOEeoK7HYyNjE",
  //     PointLatLng(6.5212402, 3.3679965), // Origin
  //     PointLatLng(6.849660, 3.648190), // Destination
  //     travelMode: TravelMode.driving,
  //   );

  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   } else {
  //     print(result.errorMessage);
  //   }
  //   _addPolyLine(polylineCoordinates);
  // }

  @override
  void initState() {
    _addMarker(
        LatLng(widget.lat, widget.long), '56', BitmapDescriptor.defaultMarker);

    // _getPolyline();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.lat, widget.long),
        zoom: 10,
      ),
      markers: _markers,
      // polylines: _polylines,
      myLocationEnabled: true,
      compassEnabled: true,
      tiltGesturesEnabled: true,
      zoomGesturesEnabled: true,
    );
  }
}

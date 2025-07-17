import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:link_on/models/location_model.dart';
import 'package:link_on/models/posts.dart';
import 'package:url_launcher/url_launcher.dart'; // Make sure this import is correct

class LocationPost extends StatefulWidget {
  final Posts? posts;
  final Widget? widget;

  LocationPost({super.key, this.posts, this.widget});

  @override
  State<LocationPost> createState() => _LocationPostState();
}

class _LocationPostState extends State<LocationPost> {
  LatLng? _location;
  String? _address;

  Future<void> _convertLocation(String? locationString) async {
    if (widget.posts!.postLocation != null) {
      print("locationString $locationString");
      final loca = Location.fromString(locationString!);
      print("converted string : ${loca.address.trim().split(": ").last}");
      _address = loca.address.trim().split(": ").last;
      _location = LatLng(loca.latitude, loca.longitude);
      // final convertedData = convertStringToMap(locationString!);
      print("converted string : ${_address}");
      print("converted string : ${_location}");
    } else {
      print("No Data found");
    }
  }

  Map<String, dynamic>? convertStringToMap(String locationString) {
    // Remove curly braces and trim whitespace
    final inputString =
        locationString.replaceAll("{", "").replaceAll("}", "").trim();

    // Use regex to split key-value pairs while preserving commas in the address
    RegExp regex = RegExp(r"(\w+):\s*([^,]+(?:, [^,]+)*)");
    Iterable<Match> matches = regex.allMatches(inputString);

    // Create a map to store the result
    Map<String, dynamic> result = {};

    for (Match match in matches) {
      String key = match.group(1)!.trim();
      String value = match.group(2)!.trim();

      // Convert latitude and longitude to double
      if (key == "latitude" || key == "longitude") {
        result[key] = double.parse(value);
      } else {
        // Keep address as a string
        result[key] = value;
      }
    }

    print(result);
    return result;
  }

  @override
  void initState() {
    super.initState();
    _convertLocation(widget.posts?.postText); // Handle potential null
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            widget.widget!,
            widget.posts?.postText == null ||
                    _location == null // Check for null
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Use const for efficiency
                : Expanded(
                    child: GoogleMap(
                      mapType: MapType.satellite,
                      initialCameraPosition: CameraPosition(
                        target: _location!, // Use the parsed LatLng
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId:
                              const MarkerId("currentLocation"), // Use const
                          position: _location!, // Use the parsed LatLng
                          infoWindow:
                              const InfoWindow(title: "Location"), // Use const
                        ),
                      },
                      onMapCreated: (GoogleMapController controller) {
                        // _mapController = controller; // If you need it later
                      },
                      onTap: (value) async {
                        String googleMapsUrl =
                            "https://www.google.com/maps/search/?api=1&query=${_location!.latitude},${_location!.longitude}";

                        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
                          await launchUrl(Uri.parse(googleMapsUrl),
                              mode: LaunchMode.externalApplication);
                        } else {
                          throw "Could not open the map.";
                        }
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

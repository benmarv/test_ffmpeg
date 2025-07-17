import 'package:flutter/material.dart';
import 'package:link_on/models/location_model.dart';
import 'package:link_on/screens/create_post/create_post.page.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  final List<Location> locationList = [
    Location(
        latitude: 33.573358,
        longitude: 71.449465,
        address: "Ishtiaq New Housing Program Kohat Pakistan"),
    Location(
        latitude: 31.490260,
        longitude: 74.395501,
        address: "Ishtiaq New Housing Program Lahore Pakistan"),
    Location(
        latitude: 30.150683,
        longitude: 71.421787,
        address: "Shershah Town Multan Pakistan"),
  ];
  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Location"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(width: 30),
            Text("Search location", style: TextStyle(fontSize: 20)),
            SizedBox(width: 20),
            TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(),
                )),
            SizedBox(width: 10),
            ListView.builder(
                shrinkWrap: true,
                itemCount: locationList.length,
                itemBuilder: (builder, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreatePostPage(
                                    location: locationList[index],
                                  )));
                    },
                    child: ListTile(
                      title: Text(locationList[index].address),
                      subtitle: Row(
                        children: [
                          Text(locationList[index].latitude.toString()),
                          SizedBox(width: 10),
                          Text(locationList[index].longitude.toString()),
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

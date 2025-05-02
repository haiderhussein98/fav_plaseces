import 'package:favirote_plaseces/moudel/place.dart';
import 'package:favirote_plaseces/place_screen/placedetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Myplace extends StatelessWidget {
  const Myplace({
    super.key,
    required this.mycons,
  });
  final List<Place> mycons;

  @override
  Widget build(BuildContext context) {
    return mycons.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: mycons.length,
            itemBuilder: (ctx, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  subtitle: Text('adress'),
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundImage: FileImage(mycons[i].image),
                  ),
                  title: Text(
                    mycons[i].name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (ctx) => DraggableScrollableSheet(
                            expand: true,
                            initialChildSize: 0.9, // يبدأ من نصف الشاشة
                            minChildSize: 0.3, // الحد الأدنى للحجم
                            maxChildSize: 0.9, // يمكن تكبيره إلى 90% من الشاشة
                            builder: (context, scrollController) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: FlutterMap(
                                        options: MapOptions(
                                          initialCenter: LatLng(
                                              mycons[i].location.latitude,
                                              mycons[i].location.longitude),
                                          initialZoom: 14,
                                        ),
                                        children: [
                                          TileLayer(
                                            urlTemplate:
                                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                            userAgentPackageName:
                                                'com.example.app',
                                          ),
                                          MarkerLayer(
                                            markers: [
                                              Marker(
                                                point: LatLng(
                                                    mycons[i].location.latitude,
                                                    mycons[i]
                                                        .location
                                                        .longitude),
                                                child: Icon(Icons.location_on,
                                                    color: Colors.red,
                                                    size: 40),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                      icon: Icon(Icons
                          .open_in_browser)), // here i want display the place locaton who is i select it in inputlocation.dart //
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => Placedetails(
                          place: Place(
                              name: mycons[i].name,
                              image: mycons[i].image,
                              location: mycons[i].location),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          )
        : Center(
            child: Text(
              'no data ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
  }
}

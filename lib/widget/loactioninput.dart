import 'package:favirote_plaseces/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:favirote_plaseces/moudel/place.dart';
import 'package:favirote_plaseces/widget/MapScreen.dart';

class Loactioninput extends StatefulWidget {
  const Loactioninput({super.key, required this.mylocation});

  final void Function(PlaceLocation location) mylocation;

  @override
  State<Loactioninput> createState() {
    return _Locationinput();
  }
}

class _Locationinput extends State<Loactioninput> {
  PlaceLocation? pickedlocation;
  bool isgettinglocation = false;
  var lat;
  var lon;
  void getlocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isgettinglocation = true;
    });
    locationData = await location.getLocation();
    lat = locationData.latitude;
    lon = locationData.longitude;

    if (lat == null || lon == null) {
      return;
    }

    setState(() {
      pickedlocation = PlaceLocation(latitude: lat, longitude: lon);
      isgettinglocation = false;
    });

    widget.mylocation(pickedlocation!);
  }

  Future<List> getLocationAddress(double latitude, double longitude) async {
    List<geo.Placemark> placemark =
        await geo.placemarkFromCoordinates(latitude, longitude);
    return placemark;
  }

  Future<void> _savePlace(double latitude, double longitude) async {
    final addressData = await getLocationAddress(latitude, longitude);
    final String street = addressData[0].street;
    final String postalcode = addressData[0].postalCode;
    final String locality = addressData[0].locality;
    final String country = addressData[0].country;
    final String address = '$street, $postalcode, $locality, $country';

    setState(() {
      pickedlocation = PlaceLocation(latitude: latitude, longitude: longitude);
      isgettinglocation = false;
    });

    widget.mylocation(pickedlocation!);
  }

  Future<void> _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => const MapScreen(
          isSelecting: true,
        ),
      ),
    );

    if (pickedLocation == null) {
      return;
    }

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text('no place chosen !',
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: colorScheme.onBackground));

    if (isgettinglocation) {
      content = CircularProgressIndicator();
    }

    if (pickedlocation != null) {
      content = Stack(
        children: [
          FlutterMap(
            options:
                MapOptions(initialCenter: LatLng(lat, lon), initialZoom: 16),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: [
                Marker(
                    point: LatLng(lat, lon),
                    child: Builder(
                        builder: (context) => const Icon(
                              Icons.location_on,
                              size: 25,
                              color: Colors.redAccent,
                            )))
              ])
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: content),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () {
                setState(() {
                  getlocation();
                });
              },
              label: Text('your location'),
              icon: Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectOnMap();
                });
              },
              label: Text('select from map '),
              icon: Icon(Icons.map),
            ),
          ],
        )
      ],
    );
  }
}

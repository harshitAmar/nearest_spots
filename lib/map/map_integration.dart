import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import 'package:programmics/login/login.dart';
import 'package:programmics/map/model/nearbymodels.dart';

class MapIntegration extends StatefulWidget {
  final String name;
  final String email;
  const MapIntegration({Key? key, required this.name, required this.email})
      : super(key: key);

  @override
  State<MapIntegration> createState() => _MapIntegrationState();
}

class _MapIntegrationState extends State<MapIntegration> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> marker = {};
  CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(lat, lon),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  bool good = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              )),
        ],
        title: Text(
          widget.email,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
      ),
      body: FutureBuilder(
          future: checkGps(),
          builder: (context, snap) {
            if (good) {
              return GoogleMap(
                markers: marker,
                myLocationButtonEnabled: true,
                mapType: MapType.hybrid,
                myLocationEnabled: true,
                initialCameraPosition: _kLake,
                onMapCreated: (GoogleMapController controller) async {
                  // await controller.
                  _controller.complete(controller);
                },
              );
            }
            return const SpinKitCircle(
              color: Colors.black,
              size: 80.0,
            );
          }),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );
  }

  loc.Location location = loc.Location();
  Future<void> checkGps() async {
    if (!await location.serviceEnabled()) {
      await location.requestService();
    }
    await _determinePosition();
    setState(() {
      good = true;
    });
  }

  bool serviceEnabled = false;
  LocationPermission? permission;
  Future<void> _determinePosition() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location services are disabled.');
    }

    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    } catch (e) {
      log(e.toString());
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Fluttertoast.showToast(msg: "App won't run without location permissions");
      showDialog(
          context: context,
          builder: ((context) {
            return const AlertDialog();
          }));
    }

    var position = await Geolocator.getCurrentPosition();
    setState(() {
      lat = position.latitude;
      lon = position.longitude;
      _kLake = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(lat, lon),
          tilt: 59.440717697143555,
          zoom: 19.151926040649414);
    });
    await getSchoolsAndHospitals();

    // var address = await placemarkFromCoordinates(lat, lon);
    // locationModel.value.city = address.first.locality;
    // locationModel.value.country = address.first.country;
    // locationModel.value.iso = address.first.isoCountryCode;
    // locationModel.value.region=address.first.s

    // List l = CountryCodePicker().countryList;

    // locationModel.value.countryCode =
    //     l.firstWhere((element) => element['code'] == "AU")['dial_code'];

    // locationModel.refresh();
  }

  Future<NearbyPlaces> getPlace(String keyword) async {
    // await _controller.

    String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat.toDouble()},${lon.toDouble()}&radius=5000.0&types=$keyword&key=AIzaSyB3irHF2DnzHrZBwPdTNslYN1XqezpkXUM";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return NearbyPlaces.fromJson(jsonDecode(response.body));
    }

    // .then((value) => NearbyPlaces.fromJson(jsonDecode(value.body)));
    return NearbyPlaces();
  }

  Future<void> getSchoolsAndHospitals() async {
    NearbyPlaces schools = await getPlace("school");
    BitmapDescriptor? hospitalIcon;
    BitmapDescriptor? schoolIcon;
    await getBytesFromAsset('assets/svg/clinic.png', 64).then((onValue) {
      hospitalIcon = BitmapDescriptor.fromBytes(onValue);
    });
    await getBytesFromAsset('assets/svg/schhols.png', 64).then((onValue) {
      schoolIcon = BitmapDescriptor.fromBytes(onValue);
    });
    for (var element in schools.results!) {
      marker.add(Marker(
          markerId: MarkerId(element.name!),
          position: LatLng(
            element.geometry!.location!.lat!,
            element.geometry!.location!.lng!,
          ),
          icon: schoolIcon ?? BitmapDescriptor.defaultMarker));
    }
    NearbyPlaces hospitals = await getPlace("hospital");
    for (var element in hospitals.results!) {
      marker.add(Marker(
          markerId: MarkerId(element.name!),
          position: LatLng(
            element.geometry!.location!.lat!,
            element.geometry!.location!.lng!,
          ),
          icon: hospitalIcon ?? BitmapDescriptor.defaultMarker));
    }
    // print(schools.toJson().toString());
    // print(hospitals.toJson().toString());
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}

double lat = 0.0;
double lon = 0.0;

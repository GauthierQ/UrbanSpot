import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:urban_spot/terrain/models/terrain.dart';

class Map extends StatefulWidget {
  double lat;

  Map(this.lat, this.lng);

  double lng;

  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();

  List<Terrain> terrains = [];
  List<Marker> desMarkers = [];

  @override
  void initState() {
    DatabaseReference reference = FirebaseDatabase.instance.reference();
    reference.child('Terrain').once().then((DataSnapshot snapshot) {
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      terrains.clear();
      for (var key in keys) {
        var terrain = Terrain(
            data[key]['id'],
            data[key]["nom"],
            data[key]["description"],
            data[key]["adresse"],
            data[key]["cp"],
            data[key]["ville"],
            data[key]["etat"],
            data[key]["img"],
            data[key]["latitude"],
            data[key]["longitude"]);
        terrains.add(terrain);
      }

      for (var i = 0; i < terrains.length; i++) {
        var marker = Marker(
          markerId: MarkerId('Marker ${terrains[i].id}.'),
          //position: (terrains[i].lat == null ?  LatLng(40.00, 40.00) :  LatLng(terrains[i].lat, terrains[i].lng)),
          position: LatLng(terrains[i].lat, terrains[i].lng),
          infoWindow: InfoWindow(title: terrains[i].nom),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        desMarkers.add(marker);
      }

      setState(() {
        print('lenght terrains: ${terrains.length}');
        print('lenght marker : ${desMarkers.length}');
      });
    });

    super.initState();
  }

  double zoomVal = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 125, 0, 1),
        toolbarHeight: 0,
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Container(
                child: Row(
                  children: [
                    _zoomminusfunction(),
                    _zoomplusfunction(),
                  ],
                ),
              )
            ],
          ),
          _buildContainer(),
        ],
      ),
    );
  }

  Widget _zoomminusfunction() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
          icon: const Icon(
            FontAwesomeIcons.searchMinus,
            color: Color.fromRGBO(50, 75, 175, 1),
            size: 26,
          ),
          onPressed: () {
            zoomVal--;
            _minus(zoomVal);
          }),
    );
  }

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: const Icon(FontAwesomeIcons.searchPlus,
              size: 26, color: Color.fromRGBO(50, 75, 175, 1)),
          onPressed: () {
            zoomVal++;
            _plus(zoomVal);
          }),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(48.117266, -1.6777926), zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(48.117266, -1.6777926), zoom: zoomVal)));
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: terrains.length,
          itemBuilder: (context, index) {
            return Container(
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _boxes(terrains[index].img, terrains[index].lat,
                        terrains[index].lng, terrains[index].nom, index),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _boxes(String _image, double lat, double long, String restaurantName,
      int index) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.2,
        child: FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Colors.black87,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  terrains.length == 0
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24.0),
                                bottomLeft: Radius.circular(24.0)),
                            child: Image.network(
                              _image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer1(restaurantName, index),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget myDetailsContainer1(String restaurantName, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            terrains[index].nom,
            style: TextStyle(
                color: Color.fromRGBO(50, 75, 175, 1),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "${terrains[index].cp} ${terrains[index].ville}",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
        )),
        Container(
            child: Text(
          terrains[index].adresse,
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
          future: _determinePosition(),
          builder: (BuildContext context, AsyncSnapshot<Position> position) {
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition:
                  CameraPosition(target: LatLng(48.11, -1.67), zoom: 12),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: Set<Marker>.of(desMarkers),
            );
          }),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    print(currentPosition);

    if (currentPosition == null) {
      return Position(longitude: 10, accuracy: 0, altitude: 10, heading: 5, latitude: 10, speed: 10, speedAccuracy: 10, timestamp: DateTime.now() , floor: 1, isMocked: true );
    } else {
      return currentPosition;
    }
  }
}

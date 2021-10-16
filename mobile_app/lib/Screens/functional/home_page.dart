import 'dart:collection';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'helpers/Post.dart';
import 'line_chart_page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:scdf_ibm/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng SOURCE_LOCATION = LatLng(1.3542, 103.6884);
const LatLng DEST_LOCATION = LatLng(1.3459, 103.6890);
const double PIN_VISIBLE_POSITION = 50;
const double PIN_INVISIBLE_POSITION = -200;

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  LatLng currentLocation;
  LatLng destinationLocation;
  double topInfoPosition = PIN_INVISIBLE_POSITION;
  List markerList = [SOURCE_LOCATION, DEST_LOCATION];
  String locationDetails = "locationDetails";
  String timeDetails = "timeDetails";
  List<Post> _posts = [];
  List testPosts = [];

  void _asyncMethod() async {
    final databaseReference =
        FirebaseDatabase.instance.reference().child("Data");
    databaseReference.once().then((DataSnapshot dataSnapshot) {
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;

      for (var key in keys) {
        Post post = new Post(values[key]['lat'], values[key]['long'],
            values[key]['location'], values[key]['time']);
        var tempPost = [
          values[key]['lat'],
          values[key]['long'],
          values[key]['location'],
          values[key]['time']
        ];
        // _posts.add(post);
        this.testPosts.add(tempPost);
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //set up initial locations
    this.setInitialLocation();
    //set up marker icons
    this.setSourceAndDestinationMarkerIcons();
    print("initState");
    _asyncMethod();
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(1.3542, 103.6884),
    zoom: 14,
  );

  void setInitialLocation() {
    currentLocation =
        LatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude);

    destinationLocation =
        LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
  }

  GoogleMapController _googleMapController;
  Set<Marker> _markers = Set<Marker>();
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  void setSourceAndDestinationMarkerIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0, size: Size(5.0, 10.0)),
        'assets/images/monkey.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0), 'assets/images/monkey.png');
  }

  // void returnPosts() async {
  //   databaseReference.once().then((DataSnapshot snapshot) {
  //     // firebaseResults = snapshot.value;
  //     for (var index in snapshot.value.keys) {
  //       databaseReference.child('${index}').once().then((result) {
  //         LinkedHashMap value = result.value;
  //         print(value.toString());
  //         var tempList = [];
  //         for (var val in value.values) {
  //           tempList.add(val);
  //         }
  //         print("tempList is ${tempList}");
  //         // var tempPost =
  //         //     Post(tempList[2], tempList[3], tempList[0], tempList[1]);
  //         this.testPosts.add(tempList);
  //         print("testPosts ${this.testPosts}");
  //       });
  //     }
  //   });
  // }

  void showPinsOnMap() {
    setState(() {
      // returnPosts();
      print("length");
      print(this.testPosts.length);
      for (var val in this.testPosts) {
        print(val);
      }
      List tempList = [];
      for (var val in this.testPosts) {
        tempList.add([val[0], val[1], val[2], val[3]]);
      }
      tempList.forEach((element) {
        print("testing");
        print(element);
        // var tempLatLng = LatLng(element[0], element[1]);
        var lat = element[0].toString();
        var long = element[1].toString();
        _markers.add(Marker(
            markerId: MarkerId("element" + element.toString()),
            position: LatLng(double.parse(lat), double.parse(long)),
            icon: sourceIcon,
            onTap: () => setState(() {
                  this.locationDetails = element[2];
                  this.timeDetails = element[3];
                  this.topInfoPosition = PIN_VISIBLE_POSITION;
                })));
      });
    });
    // setState(() {
    //   _markers.add(Marker(
    //     markerId: MarkerId('sourcePin'),
    //     position: currentLocation,
    //     icon: sourceIcon,
    //   ));
    //
    //   _markers.add(Marker(
    //     markerId: MarkerId('destinationPin'),
    //     position: destinationLocation,
    //     icon: destinationIcon,
    //   ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
            child: FutureBuilder(
                future:
                    FirebaseDatabase.instance.reference().child("data").once(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      return Stack(
                        children: [
                          Positioned(
                              child: GoogleMap(
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: false,
                            initialCameraPosition: _initialCameraPosition,
                            onMapCreated: (controller) {
                              _googleMapController = controller;
                              showPinsOnMap();
                            },
                            markers: _markers,
                            onTap: (LatLng) {
                              //tapping on the map will dismiss the top info
                              setState(() {
                                print("dismissing map");
                                this.topInfoPosition = -220;
                              });
                            },
                          )),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            top: this.topInfoPosition,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 20, right: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: Offset.zero)
                                  ]),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          locationDetails,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          timeDetails,
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.location_pin,
                                      color: Colors.red, size: 40)
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return new CircularProgressIndicator();
                    }
                  } else {
                    return  CircularProgressIndicator();
                  }
                })),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () => _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition)),
          child: const Icon(
            Icons.center_focus_strong,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Me'),
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      );
}

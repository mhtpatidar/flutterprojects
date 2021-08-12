import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherappp/WeatherScreen.dart';

import 'LoginScreen.dart';
import 'ViewHistory.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late SharedPreferences sharedPreferences;
  String mobile= " ";
  String _resultAddress= "";

  List<Marker> mymarker = [];

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late GoogleMapController _controller;
  Location _location = Location();

  late double globleLat,globleLng;
  late String city ;


  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
      getUserLocation();
  }


getUserLocation() async {//call this async method from whereever you need

  LocationData myLocation;
  String error;
  Location location = new Location();
  try {
    myLocation = await location.getLocation();
  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      error = 'please grant permission';
      print(error);
    }
    if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
      error = 'permission denied- please enable it from app settings';
      print(error);
    }
    myLocation = await location.getLocation();
  }
  var currentLocation = myLocation;

  CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(myLocation.latitude!, myLocation.longitude!),zoom: 15));
  final coordinates = new Coordinates(
      myLocation.latitude, myLocation.longitude);
  var addresses = await Geocoder.local.findAddressesFromCoordinates(
      coordinates);
  var first = addresses.first;
  print(" default  Address"+first.addressLine!+" "+myLocation.latitude.toString()+myLocation.longitude.toString());
  LatLng n = new LatLng(myLocation.latitude!,myLocation.longitude!);

  globleLat = myLocation.latitude!;
  globleLng = myLocation.longitude!;
  city = first.adminArea.toString();


  setState(() {
    mymarker = [];
    mymarker.add(
        Marker(
          markerId: MarkerId(n.toString()),
          position: n,
        )
    );
  });
  setState(() {
    _resultAddress = first.addressLine as String;
  });

  return first;
 }

getTabUserLocation(double latitude, double longitude) async {

    LocationData myLocation;
    String error;

    CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude!, longitude!),zoom: 15));
    final coordinates = new Coordinates(latitude, longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    print("Tapped Address"+first.addressLine!+" "+latitude.toString()+longitude.toString());

    globleLat = latitude!;
    globleLng = longitude!;
    city = first.adminArea.toString();


    setState(() {
      _resultAddress = first.addressLine!+" Lat:"+latitude.toString()+" Lng:"+longitude.toString() as String;
    });
   // print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    return first;
  }

  @override
  void initState() {
    // TODO: implement initState
    initView();
  }

  initView() async {
    sharedPreferences = await SharedPreferences.getInstance();
    mobile = sharedPreferences.getString("mobilenumber").toString();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child:  ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            createDrawerHeader(),
            createDrawerBodyItem(
                icon: Icons.home,text: 'Home'),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewHisory()),
                );
              },
              child: createDrawerBodyItem(
                  icon: Icons.history,text: 'History'),
            ),

            GestureDetector(
              onTap: (){
                sharedPreferences.setString("isLogin","0");
                sharedPreferences.setString("mobilenumber","");
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()));
              },
              child: createDrawerBodyItem(
                  icon: Icons.power_settings_new,text: 'Logout'),
            ),

          ],
        ),
      ),
      body: Container(
        
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Card (
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.white,
              elevation: 10,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    (_resultAddress!=null && _resultAddress !="")?
                    Text("Current Address: "+ _resultAddress): Text("No Address"),
                    SizedBox(height: 10,),
                      RaisedButton(
                        color: Colors.blue,
                        child: Text('Featch Weather'),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WeatherScreen(globleLat,globleLng,city)),
                          );
                        },
                      ),

                  ],
                ),

              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                elevation: 10,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: _initialcameraposition),
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  markers: Set.from(mymarker),
                  onTap: _handleTap,
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
 _handleTap(LatLng tappedPoint){
    setState(() {
      mymarker = [];
      mymarker.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
        )
      );
    });
    getTabUserLocation(tappedPoint.latitude,tappedPoint.longitude);
 }

  Widget createDrawerHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text("Welcome ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500)),
            Text(mobile,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300))
          ],
        ));
  }

  Widget createDrawerBodyItem(
      {IconData? icon, required String text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}


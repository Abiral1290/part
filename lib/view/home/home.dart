import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sbcb_driver_flutter/core/model/vehicle_request.dart';
import 'package:sbcb_driver_flutter/core/notifiers/providers/auth_state.dart';
import 'package:sbcb_driver_flutter/core/notifiers/providers/location_state.dart';
import 'package:sbcb_driver_flutter/core/notifiers/providers/map_state.dart';
import 'package:sbcb_driver_flutter/utils/constants.dart';
import 'package:sbcb_driver_flutter/utils/preferences.dart';
import 'package:sbcb_driver_flutter/utils/utilities.dart';
import 'package:sbcb_driver_flutter/view/ad/search_page.dart';
import 'package:sbcb_driver_flutter/view/settings/settings.dart';
import 'package:sbcb_driver_flutter/view/status_page.dart';
import 'package:sbcb_driver_flutter/view/widgets/common_widgets.dart';
import 'package:sbcb_driver_flutter/view/about/about.dart';
import 'package:sbcb_driver_flutter/core/services/global_config.dart'
    as globals;

class HomePage extends StatefulWidget {
  final LocationState locationState;

  HomePage({this.locationState});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Position selfPosition;

  // bool status = false;
  bool isDisplayed = false; // if dialog is displayed or not
  int _earningToday = 0;

  @override
  void initState() {
    super.initState();
    Preference.getTodaysEarning().then((e) {
      setState(() {
        _earningToday = e;
      });
    });
    getSelfLocation();
    // create user icon for map
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.5,
        size: Size(1000, 1000),
      ),
      "assets/user.png",
    ).then((onValue) {
      Constants.userIcon = onValue;
    });
  }

  List<MapTypeItem> mapTypeList = <MapTypeItem>[
    MapTypeItem(
      name: "Normal",
      icon: Icon(
        Icons.map,
        color: Colors.amber,
      ),
    ),
    MapTypeItem(
      name: "Hybrid",
      icon: Icon(
        Icons.scanner_outlined,
        color: Colors.amber,
      ),
    ),
    MapTypeItem(
      name: "Terrain",
      icon: Icon(
        Icons.monochrome_photos,
        color: Colors.amber,
      ),
    ),
    MapTypeItem(
      name: "Satellite",
      icon: Icon(
        Icons.satellite,
        color: Colors.amber,
      ),
    ),
  ];

  acceptRejectRequest(
      String requestId, String clientId, String action, MapState mapState) {
    acceptRejectRequestModel(requestId, clientId, action).then((value) {
      widget.locationState.setVehicleRequest(value);
      setState(() {
        isDisplayed = false;
        if (value.isAccepted) {
          globals.isReadyForTrip = false;
          mapState.setActiveTrip(true);
          // add marker for user(client) location
          mapState.createMarker(
              LatLng(
                double.parse(widget.locationState.vehicleRequest.latitude),
                double.parse(widget.locationState.vehicleRequest.longitude),
              ),
              true);

          // add marker for destination location
          mapState.createMarker(
              LatLng(
                double.parse(widget.locationState.vehicleRequest.destLatitude),
                double.parse(widget.locationState.vehicleRequest.destLongitude),
              ),
              false);

          // send request to add route
          mapState.sendRequest(
            LatLng(
              double.parse(widget.locationState.vehicleRequest.latitude),
              double.parse(widget.locationState.vehicleRequest.longitude),
            ),
            LatLng(
              double.parse(widget.locationState.vehicleRequest.destLatitude),
              double.parse(widget.locationState.vehicleRequest.destLongitude),
            ),
          );
        }
      });
    });
  }

  checkNewVehicleRequest(BuildContext context, MapState mapProvider) {
    // var mapProvider = Provider.of<MapState>(context, listen: false);
    print("👩🏼‍🦰 Inside show dialog of vehicle request");
    // requested dialog
    if (widget.locationState.isRequested &&
        !isDisplayed &&
        globals.isReadyForTrip) {
      setState(() {
        isDisplayed = true;
      });

      showDialog(
          context: context,
          builder: (context) {
            return WillPopScope(
              onWillPop: () {
                return;
              },
              child: AlertDialog(
                title: Text("Taxi Requested"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Start: " +
                        widget.locationState.vehicleRequest.start.toString()),
                    Text("Destination: " +
                        widget.locationState.vehicleRequest.end.toString()),
                    Text("Remarks : " +
                        widget.locationState.vehicleRequest.remarks.toString()),
                    Text("Distance : " +
                        widget.locationState.vehicleRequest.distance
                            .toString() +
                        ' km'),
                    Text("Amount : Rs " +
                        widget.locationState.vehicleRequest.amount.toString()),
                  ],
                ),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      acceptRejectRequest(
                        widget.locationState.vehicleRequest.requestId
                            .toString(),
                        widget.locationState.vehicleRequest.clientId.toString(),
                        "accepted",
                        mapProvider,
                      );
                    },
                    child: Text("Accept"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      acceptRejectRequest(
                        widget.locationState.vehicleRequest.requestId
                            .toString(),
                        widget.locationState.vehicleRequest.clientId.toString(),
                        "rejected",
                        mapProvider,
                      );
                    },
                    child: Text("Reject"),
                  ),
                ],
              ),
            );
          });
    }
  }

  getSelfLocation() async {
    var isLocationTurnedOn =
        await GeolocatorPlatform.instance.isLocationServiceEnabled();

    if (!isLocationTurnedOn) {
      Utilities.showPlatformSpecificAlert(
          title: "Waring",
          body:
              "Your location services are disabled. \nPlease turn on your location services.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    var mapStateProvider = Provider.of<MapState>(context, listen: false);

    var size = MediaQuery.of(context).size;

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => checkNewVehicleRequest(context, mapStateProvider));

    void choiceAction(String choice) {
      if (choice == 'Settings') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SettingsPage(),
          ),
        );
      } else if (choice == 'About') {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AboutPage()),
        );
      } else if (choice == 'Logout') {
        print('SignOut');
        authState.signOut();
      }
    }

    Image buildVehicleIcon() {
      if (authState.driver.vehicleType == VehicleType.bike) {
        return globals.isReadyForTrip
            ? Image.asset("assets/bike/bike.png")
            : Image.asset("assets/bike/bike_closed.png");
      } else {
        return globals.isReadyForTrip
            ? Image.asset("assets/taxi/opened_taxi.png")
            : Image.asset("assets/taxi/closed_taxi.png");
      }
    }

    // widget to change the map type by toggle button
    Widget mapTypesToggleButton(MapState mapState) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: PopupMenuButton<MapTypeItem>(
                icon: Icon(
                  Icons.map,
                  color: Colors.amber,
                ),
                onSelected: (MapTypeItem value) {
                  if (value.name == "Normal") {
                    mapState.changeMapType(MapType.normal);
                  } else if (value.name == "Hybrid") {
                    mapState.changeMapType(MapType.hybrid);
                  } else if (value.name == "Terrain") {
                    mapState.changeMapType(MapType.terrain);
                  } else if (value.name == "Satellite") {
                    mapState.changeMapType(MapType.satellite);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return mapTypeList.map((MapTypeItem mapTypeItem) {
                    return PopupMenuItem<MapTypeItem>(
                      value: mapTypeItem,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          mapTypeItem.icon,
                          Text(
                            mapTypeItem.name,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                }),
          ),
        ),
      );
    }

    Widget viewLoader(MapState mapState, Size size) {
      if (widget.locationState.userPosition != null) {
        return Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              mapType: mapState.mapType,
              polylines: mapState.polyLines,
              markers: Set<Marker>.of(mapState.markers.values),
              initialCameraPosition: CameraPosition(
                zoom: 16,
                target: LatLng(widget.locationState.userPosition.latitude,
                    widget.locationState.userPosition.longitude),
              ),
              onMapCreated: mapState.onCreated,
            ),
            mapState.activeTrip
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Distance : " +
                            widget.locationState.vehicleRequest.distance
                                .toString() +
                            ' km'),
                        Text("Amount : Rs " +
                            widget.locationState.vehicleRequest.amount
                                .toString()),
                        MaterialButton(
                          onPressed: () async {
                            setState(() {
                              _earningToday = _earningToday +
                                  widget.locationState.vehicleRequest.amount;
                              globals.isReadyForTrip = true;
                            });
                            Preference.saveTodaysEarning(_earningToday);

                            mapState.endTrip();
                            mapState.setActiveTrip(false);
                          },
                          child: Text("END TRIP",
                              style: TextStyle(color: Colors.white)),
                          color: Colors.green,
                        ),
                      ],
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Card(
                      color: Colors.grey[50],
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Container(
                        height: size.height * 0.2,
                        width: size.width,
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5.0),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.circle,
                                color: widget.locationState.trackCarState
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text("Rs. $_earningToday"),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                child: buildVehicleIcon(),
                                onTap: () {
                                  setState(() {
                                    globals.isReadyForTrip =
                                        !globals.isReadyForTrip;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            mapTypesToggleButton(mapState),
          ],
        );
      } else {
        return Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        );
      }
    }

    return Consumer<MapState>(builder: (context, mapState, child) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
              leading: getVehicleIcon(authState.driver.vehicleType),
              title: Text(Constants.appName),
              actions: <Widget>[
                MaterialButton(
                  textColor: Colors.white,
                  child: Text('Status'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Consumer<LocationState>(
                            builder: (context, locationState, child) {
                          return StatusPage(
                            locationState: widget.locationState,
                          );
                        }),
                      ),
                    );
                  },
                ),
                IconButton(
                  // textColor: Colors.white,
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ),
                    );
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return ['Settings', 'About', 'Logout'].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                )
              ]),
          body: viewLoader(mapState, size),
        ),
      );
    });
  }
}

class MapTypeItem {
  String name;
  Icon icon;

  MapTypeItem({
    this.name,
    this.icon,
  });
}

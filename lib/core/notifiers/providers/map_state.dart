import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sbcb_driver_flutter/core/services/google_map_service.dart';
import 'package:sbcb_driver_flutter/core/services/global_config.dart'
    as globals;
import 'package:sbcb_driver_flutter/utils/constants.dart';

class MapState extends ChangeNotifier {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  MapType mapType = MapType.normal;

  bool _activeTrip = false;

  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Map<MarkerId, Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;
  bool get activeTrip => _activeTrip;

  changeMapType(MapType newMapType) {
    mapType = newMapType;

    notifyListeners();
  }

  setActiveTrip(bool active) {
    _activeTrip = active;
    notifyListeners();
  }

  void createMarker(LatLng latlng, bool user) {
    final MarkerId markerId =
        MarkerId(user ? "userMarker" : "destinationMarker");

    final Marker marker = Marker(
      markerId: markerId,
      position: latlng,
      icon: user ? Constants.userIcon : BitmapDescriptor.defaultMarker,
    );
    _markers[markerId] = marker;

    notifyListeners();
  }

  // ! TO CREATE ROUTE
  void createRoute(String encondedPoly) {
    clearRoute();
    _polyLines.add(
      Polyline(
        polylineId: PolylineId(globals.clientId.toString()),
        width: 5,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.black,
        geodesic: true,
      ),
    );
    notifyListeners();
  }

  void clearRoute() {
    _polyLines.clear();
    notifyListeners();
  }

  void endTrip() {
    // clear route
    _polyLines.clear();
    // clear markers
    _markers.clear();
    notifyListeners();
  }

  // ! CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  // ! SEND REQUEST
  void sendRequest(LatLng source, LatLng destination) async {
    print("Inside send Request");
    String route =
        await googleMapsServices.getRouteCoordinates(source, destination);
    createRoute(route);
    notifyListeners();
  }

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void animateCameraToDesireLocation(LatLng destination) {
    final GoogleMapController controller = mapController;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: destination, zoom: 15)));
    notifyListeners();
  }
}

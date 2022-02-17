import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sbcb_driver_flutter/core/model/vehicle_request.dart';
import 'package:sbcb_driver_flutter/core/notifiers/providers/auth_state.dart';
import 'package:sbcb_driver_flutter/core/services/notification_service.dart';
import 'package:sbcb_driver_flutter/core/services/track_car.dart';
import 'package:sbcb_driver_flutter/core/services/global_config.dart'
    as globals;
import 'package:sbcb_driver_flutter/utils/utilities.dart';

class LocationState extends ChangeNotifier {
  Position _pos;
  Geolocator _locator = Geolocator();
  bool _trackCarState = false;

  bool _isRequested = false;
  VehicleRequest _vehicleRequest = VehicleRequest();

  Position get userPosition => _pos;
  Geolocator get locator => _locator;
  bool get trackCarState => _trackCarState;
  bool get isRequested => _isRequested;
  VehicleRequest get vehicleRequest => _vehicleRequest;

  LocationState() {
    _init();
  }

  setVehicleRequest(VehicleRequest request) {
    _vehicleRequest = request;
    _isRequested = false;
    notifyListeners();
  }

  recheckLocation() {
    notifyListeners();
  }

  _checkPermission() async {
    var x = await GeolocatorPlatform.instance.checkPermission();
    if (x == LocationPermission.denied ||
        x == LocationPermission.deniedForever) {
      await Future.delayed(Duration(seconds: 3));
      if (Platform.isAndroid)
        await Utilities.showPlatformSpecificAlert(
            title: 'Notice',
            body:
                'This app collects location data to enable vechicle requests from passengers even when the app is in backgound. Please enable "Allow all the time"');
      GeolocatorPlatform.instance.requestPermission();
    }
  }

  _init() async {
    await Future.delayed(Duration(seconds: 3));
    await _checkPermission();

    Timer.periodic(Duration(seconds: 10), (t) async {
      var p = await GeolocatorPlatform.instance.checkPermission();
      if (p == LocationPermission.whileInUse ||
          p == LocationPermission.always) {
        _pos = await GeolocatorPlatform.instance.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation);
        print(_pos);

        var state = Provider.of<AuthState>(globals.navigatorKey.currentContext,
            listen: false);
        if (_pos != null && state.driver != null) {
          trackCarUpdate(
            bearing: '0.0',
            accuracy: _pos.accuracy.toString(),
            alitude: _pos.altitude.toString(),
            lat: _pos.latitude.toString(),
            long: _pos.longitude.toString(),
            phone: state.driver.phone,
            speed: _pos.speed.toString(),
          ).then((value) {
            _trackCarState = value;
          });

          getVehicleRequestApi(
                  globals.clientId.toString(), _pos.latitude, _pos.longitude)
              .then((value) {
            if (value.isNotEmpty) {
              _isRequested = true;
              _vehicleRequest = value.first;

              ///Showing notification only if taxi is ready for trip

              if (globals.isReadyForTrip)
                NotificationService.showNotif(
                  id: vehicleRequest.requestId,
                  title: "New Vehicle Request",
                  body: vehicleRequest.end.toString(),
                );
            }
            print("Length of vehicle request: ${value.length}");
          });
        }
      }

      notifyListeners();
    });
  }
}

import 'package:flutter/material.dart';
import 'package:sbcb_driver_flutter/utils/constants.dart';

Widget getVehicleIcon(String vehicleType, {double size = 24, Color color}) {
  return Icon(
    vehicleType == VehicleType.bike
        ? Icons.directions_bike
        : Icons.local_taxi_sharp,
    size: size,
    color: color,
  );
}

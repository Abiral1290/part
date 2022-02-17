import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants {
  static final appName = 'SBCB Driver';
  static bool isProduction = true;
  static String token = '';
  static const taxiReqTimeoutSec = 120;
  static var callServerNum = '9801980384';
  // static var callServerNum = '9808106489';
  static const accessEmail = 'sbcbadmin';
  static final sbcbClientId = '18';

  static BitmapDescriptor userIcon;

  static final zones = [
    "BA",
    "BH",
    "DH",
    "GA",
    "JA",
    "KA",
    "KO",
    "LU",
    "MA",
    "ME",
    "NA",
    "RA",
    "SA",
    "SE"
  ];
  static final vehicleCategories = ['PA', 'GA', 'JA'];

  static const googleAPIKey = "AIzaSyC_siAOGtkjHJ4i_1SzyjaSV8VC83vfYAw";

  static const playstoreShareLink =
      "https://play.google.com/store/apps/details?id=com.techsales.sbcb_driver";
  static const appstoreShareLink = "";
}

class VehicleType {
  static const bike = 'bike';
  static const taxi = 'taxi';
}

class Assets {
  static final appLogo = 'assets/sbcb_driver_logo.png';
}

class WorkingType {
  static String fulltime = "FT";
  static String parttime = "PT";
}

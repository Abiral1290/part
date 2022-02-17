import 'package:http/http.dart' as http;
import 'package:sbcb_driver_flutter/utils/api_urls.dart';

Future<bool> trackCarUpdate(
    {String phone,
    String lat,
    String long,
    String speed,
    String alitude,
    String accuracy,
    String bearing}) async {
  try {
    var url = ApiURLs.trackCar +
        '?id=$phone&timestamp=${DateTime.now().millisecondsSinceEpoch}&lat=$lat&lon=$long&speed=$speed&bearing=$bearing&altitude=$alitude&accuracy=$accuracy&batt=45.0&mock=false';
    final resp = await http.post(Uri.parse(url));
    print('track car: ' + resp.statusCode.toString());
    if (resp.statusCode == 200) {
      print('✅ track car success ✅');

      return true;
    }
    return false;
  } catch (e) {
    print('❌ track car error: ❌');
    print(e.toString());
    return false;
  }
}

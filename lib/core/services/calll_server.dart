import 'package:http/http.dart' as http;
import 'package:sbcb_driver_flutter/utils/api_urls.dart';
import 'package:sbcb_driver_flutter/utils/utilities.dart';

Future<bool> registerCallServer(String phNumber) async {
  final response = await http.get(
    Uri.parse(ApiURLs.callServerUrl + phNumber),
  );
  if (Utilities.handleStatus(response.statusCode)) {
    return true;
  }
  return false;
}

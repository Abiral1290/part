import 'package:sbcb_driver_flutter/utils/api_urls.dart';
import 'package:sbcb_driver_flutter/utils/constants.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sbcb_driver_flutter/utils/utilities.dart';

class VehicleRequest {
  int requestId;
  int appUserId;
  int clientId;
  String start;
  String end;
  String latitude;
  String longitude;
  String destLatitude;
  String destLongitude;
  String message;
  String remarks;
  bool isAccepted;
  bool isRejected;
  bool isCanceled;
  bool isEnded;
  double distance;
  int amount;
  String createdAt;
  String updatedAt;

  VehicleRequest(
      {this.requestId,
      this.appUserId,
      this.clientId,
      this.start,
      this.end,
      this.latitude,
      this.longitude,
      this.destLatitude,
      this.destLongitude,
      this.message,
      this.remarks,
      this.isAccepted,
      this.isRejected,
      this.isCanceled,
      this.isEnded,
      this.createdAt,
      this.updatedAt});

  VehicleRequest.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    appUserId = json['app_user_id'];
    clientId = json['client_id'];
    start = json['start'];
    end = json['end'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    destLatitude = json['dest_latitude'];
    destLongitude = json['dest_longitude'];
    message = json['message'];
    remarks = json['remarks'];
    var arr = message.split(',');
    distance = double.parse(arr.first);
    amount = int.parse(arr.last);
    isAccepted = json['is_accepted'] == 0 ? false : true;
    isRejected = json['is_rejected'] == 0 ? false : true;
    isCanceled = json['is_canceled'] == 0 ? false : true;
    isEnded = json['is_ended'] == 0 ? false : true;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['app_user_id'] = this.appUserId;
    data['client_id'] = this.clientId;
    data['start'] = this.start;
    data['end'] = this.end;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['dest_latitude'] = this.destLatitude;
    data['dest_longitude'] = this.destLongitude;
    data['message'] = this.message;
    data['remarks'] = this.remarks;
    data['is_accepted'] = this.isAccepted;
    data['is_rejected'] = this.isRejected;
    data['is_canceled'] = this.isCanceled;
    data['is_ended'] = this.isEnded;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

Future<List<VehicleRequest>> getVehicleRequestApi(
  String clientId,
  double lat,
  double long,
) async {
  var body = {
    "client_id": clientId,
    "longitude": lat.toString(),
    "latitude": long.toString(),
  };
  var header = {
    'Authorization': 'Bearer ' + Constants.token,
    'Accept': 'application/json'
  };
  try {
    final http.Response response = await http
        .post(Uri.parse(ApiURLs.requestList), headers: header, body: body);
    if (Utilities.handleStatus(response.statusCode)) {
      Map<String, dynamic> respMap = json.decode(response.body);
      if (!respMap["error"]) {
        final reqs = await respMap['data'].map<VehicleRequest>((json) {
          return VehicleRequest.fromJson(json);
        }).toList();
        return reqs;
      } else {
        return null;
      }
    } else {
      print(response.body);
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future<VehicleRequest> acceptRejectRequestModel(
    String requestId, String clientId, String action) async {
  try {
    final http.Response response = await http.post(Uri.parse(
        ApiURLs.updateRequest +
            "?request_id=$requestId&client_id=$clientId&action=$action"));
    if (response.statusCode == 200) {
      Map<String, dynamic> respMap = json.decode(response.body);
      if (!respMap["error"]) {
        final reqs = VehicleRequest.fromJson(respMap['data']);
        return reqs;
      } else {
        return null;
      }
    } else {
      print(response.body);
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

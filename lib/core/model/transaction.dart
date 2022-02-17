import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sbcb_driver_flutter/utils/api_urls.dart';
import 'package:sbcb_driver_flutter/utils/constants.dart';

class Transaction {
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
  int isAccepted;
  int isRejected;
  int isCanceled;
  int isEnded;
  String createdAt;
  String updatedAt;
  int totalAmount;
  double totalDistance;

  Transaction(
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
      this.isAccepted,
      this.isRejected,
      this.isCanceled,
      this.isEnded,
      this.createdAt,
      this.updatedAt,
      this.totalAmount,
      this.totalDistance});

  Transaction.fromJson(Map<String, dynamic> json) {
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
    isAccepted = json['is_accepted'];
    isRejected = json['is_rejected'];
    isCanceled = json['is_canceled'];
    isEnded = json['is_ended'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalAmount = json['total_amount'];
    totalDistance = json['total_distance'].toDouble();
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
    data['is_accepted'] = this.isAccepted;
    data['is_rejected'] = this.isRejected;
    data['is_canceled'] = this.isCanceled;
    data['is_ended'] = this.isEnded;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['total_amount'] = this.totalAmount;
    data['total_distance'] = this.totalDistance;
    return data;
  }
}

Future<List<Transaction>> getTransactionAPI(
    String startDate, String endDate) async {
  print(Constants.token);
  var body = {
    'start_date': startDate,
    'end_date': endDate,
  };
  var header = {
    'Authorization': 'Bearer ' + Constants.token,
    'Accept': 'application/json'
  };
  // try {
  final http.Response response = await http
      .post(Uri.parse(ApiURLs.transactionLists), headers: header, body: body);
  if (response.statusCode == 200) {
    Map<String, dynamic> respMap = json.decode(response.body);
    if (!respMap["error"]) {
      final reqs = await respMap['data'].map<Transaction>((json) {
        return Transaction.fromJson(json);
      }).toList();
      return reqs;
    } else {
      return null;
    }
  } else {
    print(response.body);
    return null;
  }
  // } catch (e) {
  //   print(e.toString());
  //   return null;
  // }
}

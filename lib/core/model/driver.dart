import 'package:sbcb_driver_flutter/utils/api_urls.dart';
import 'package:sbcb_driver_flutter/utils/constants.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sbcb_driver_flutter/utils/utilities.dart';

class Driver {
  int id;
  String name;
  String workingType;
  String vehicleType;
  String phone;
  String uniqueId;
  String deviceId;
  String image;
  String blueBook;
  String license;
  String date;
  int isApproved;
  String approvedBy;
  String approvedDate;
  int isRejected;
  String rejectionMessage;
  String rejectedDate;
  int userId;
  String referalCode;
  String createdAt;
  String updatedAt;
  String apiToken;

  Driver(
      {this.id,
      this.name,
      this.workingType,
      this.vehicleType,
      this.phone,
      this.uniqueId,
      this.deviceId,
      this.image,
      this.blueBook,
      this.license,
      this.date,
      this.isApproved,
      this.approvedBy,
      this.approvedDate,
      this.isRejected,
      this.rejectionMessage,
      this.rejectedDate,
      this.userId,
      this.referalCode,
      this.createdAt,
      this.updatedAt,
      this.apiToken});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    workingType = json['working_type'];
    vehicleType = json['vehicle_type'];
    phone = json['phone'];
    uniqueId = json['uniqueId'];
    deviceId = json['deviceId'];
    image = json['image'];
    license = json['license'];
    date = json['date'];
    isApproved = json['is_approved'];
    approvedBy = json['approved_by'];
    approvedDate = json['approved_date'];
    isRejected = json['is_rejected'];
    rejectionMessage = json['rejection_message'];
    rejectedDate = json['rejected_date'];
    userId = json['user_id'];
    referalCode = json['referal_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    apiToken = json['api_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['working_type'] = this.workingType;
    data['vehicle_type'] = this.vehicleType;
    data['phone'] = this.phone;
    data['uniqueId'] = this.uniqueId;
    data['deviceId'] = this.deviceId;
    data['image'] = this.image;
    data['license'] = this.license;
    data['date'] = this.date;
    data['is_approved'] = this.isApproved;
    data['approved_by'] = this.approvedBy;
    data['approved_date'] = this.approvedDate;
    data['is_rejected'] = this.isRejected;
    data['rejection_message'] = this.rejectionMessage;
    data['rejected_date'] = this.rejectedDate;
    data['user_id'] = this.userId;
    data['referal_code'] = this.referalCode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['api_token'] = this.apiToken;
    return data;
  }

  Future<String> getCallServerNumber() async {
    var header = {
      'Authorization': 'Bearer abcdefghij',
      'Accept': 'application/json'
    };
    try {
      var resp =
          await http.get(Uri.parse(ApiURLs.getServerNum), headers: header);
      print(resp.body);
      if (resp.statusCode == 200) {
        var jbody = json.decode(resp.body);
        var num = jbody['data']['server_number'];
        return num;
      } else {
        return '';
      }
    } catch (e) {
      print('❌ Error getting server number');
      print(e.toString());
      return '';
    }
  }

  static Future<dynamic> register(
      {String name,
      String phone,
      String workType,
      String vehicleNum,
      String license,
      String bluebook,
      String vehicleType,
      String deviceId,
      String image,
      String referalCode}) async {
    var body = {
      "name": name,
      "phone": phone,
      "working_type": workType,
      "uniqueId": vehicleNum,
      "deviceId": deviceId,
      "image": image,
      "license": license,
      "vehicle_type": vehicleType,
      "blue_book": bluebook,
      "user_id": Constants.sbcbClientId,
      "referal_code": referalCode
    };
    var header = {
      'Authorization': 'Bearer ' + Constants.token,
      'Accept': 'application/json'
    };
    try {
      final http.Response response = await http
          .post(Uri.parse(ApiURLs.registerUrl), headers: header, body: body);
      if (response.statusCode == 200) {
        Map<String, dynamic> respMap = json.decode(response.body);
        if (!respMap["error"]) {
          return true;
        } else {
          return respMap["message"];
        }
      } else {
        print(response.body);
        return 'Unknown error';
      }
    } catch (e) {
      return (e.toString());
    }
  }

  static Future<String> getTaxiRatingAPI(int driverID) async {
    String rating = 'N/A';
    try {
      final response = await http.post(
        Uri.parse(ApiURLs.driverRatingDisplay),
        headers: {
          'Authorization': 'Bearer ' + Constants.token,
          'Accept': 'application/json'
        },
        body: {'client_id': driverID.toString()},
      );
      if (Utilities.handleStatus(response.statusCode)) {
        Map<String, dynamic> mapResponse = json.decode(response.body);
        if (!mapResponse["error"]) {
          rating = mapResponse['data'].toString();
        }
      }
      return rating;
    } catch (e) {
      print(e.toString());
      return rating;
    }
  }
}

// 1@Phulbari1
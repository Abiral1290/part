class Passenger {
  int id;
  String mobileNumber;
  String modelName;
  String name;
  String gender;
  String profileImage;

  Passenger(
      {this.id,
      this.mobileNumber,
      this.modelName,
      this.name,
      this.gender,
      this.profileImage});

  Passenger.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileNumber = json['mobile_number'];
    modelName = json['model_name'];
    name = json['name'];
    gender = json['gender'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobile_number'] = this.mobileNumber;
    data['model_name'] = this.modelName;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['profile_image'] = this.profileImage;
    return data;
  }
}

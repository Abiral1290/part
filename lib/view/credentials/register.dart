import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sbcb_driver_flutter/core/model/driver.dart';
import 'package:sbcb_driver_flutter/core/services/mobile_details.dart';
import 'package:sbcb_driver_flutter/utils/constants.dart';
import 'package:sbcb_driver_flutter/utils/utilities.dart';

class RegisterPage extends StatefulWidget {
  final String vehicleType;

  const RegisterPage({Key key, @required this.vehicleType}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _vehicleNumberController =
      new TextEditingController();
  final TextEditingController _referalCodeController =
      new TextEditingController();
  GlobalKey<FormState> formKey = new GlobalKey();

  String _licenseImg = '', _blueBookImg = '', _profileImg;
  String _zone = '', _lot = '', _vehicleCat = '', _vehicleType;
  String workingType = "FT";

  String _type = WorkingType.fulltime;

  @override
  void initState() {
    super.initState();
    _zone = Constants.zones.first;
    _lot = '1';
    _vehicleCat = Constants.vehicleCategories.first;
    setState(() {
      if (widget.vehicleType == "") {
        _vehicleType = VehicleType.taxi;
      } else {
        _vehicleType = widget.vehicleType;
      }
    });
  }

  Future<String> _getImg(ImageSource src) async {
    String base64Image = '';
    var img = await ImagePicker().pickImage(source: src, imageQuality: 25);
    if (img != null) {
      List<int> imageBytes = await img.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }
    Navigator.pop(context, base64Image);

    return base64Image;
  }

  Future<String> _showPicker(context) async {
    return await showModalBottomSheet<String>(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () async {
                        var resp = await _getImg(ImageSource.gallery);
                        return resp;
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      var resp = await _getImg(ImageSource.camera);
                      return resp;
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget vehicleInfoWidget() {
      return Container(
        padding: const EdgeInsets.all(8.0),
        child: InputDecorator(
          isFocused: true,
          decoration: InputDecoration(
            labelText: 'Vehicle Information',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: _zone,
                onChanged: (i) {
                  setState(() {
                    _zone = i;
                  });
                },
                items: Constants.zones.map((z) {
                  return DropdownMenuItem<String>(
                    value: z,
                    child: Text(z),
                  );
                }).toList(),
              ),
              SizedBox(
                width: 5,
              ),
              DropdownButton<String>(
                value: _lot,
                onChanged: (i) {
                  setState(() {
                    _lot = i;
                  });
                },
                items: List<String>.generate(100, (i) => (i + 1).toString())
                    .map((z) {
                  return DropdownMenuItem<String>(
                    value: z,
                    child: Text(z.toString()),
                  );
                }).toList(),
              ),
              SizedBox(
                width: 5,
              ),
              DropdownButton<String>(
                value: _vehicleCat,
                onChanged: (i) {
                  setState(() {
                    _vehicleCat = i;
                  });
                },
                items: Constants.vehicleCategories.map((z) {
                  return DropdownMenuItem<String>(
                    value: z,
                    child: Text(z),
                  );
                }).toList(),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Input Licence Number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: _vehicleNumberController,
                  decoration: InputDecoration(
                    labelText: 'Number',
                  ),
                  maxLength: 4,
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget licenseBluebook() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'License',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      var res = await _showPicker(context);
                      setState(() {
                        _licenseImg = res;
                      });
                    },
                    child: _licenseImg != null && _licenseImg.isNotEmpty
                        ? Image.memory(base64Decode(_licenseImg))
                        : Row(children: [
                            Icon(Icons.photo),
                            SizedBox(width: 6),
                            Text('Choose Image')
                          ]),
                  )),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Bluebook',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      var res = await _showPicker(context);
                      setState(() {
                        _blueBookImg = res;
                      });
                    },
                    child: _blueBookImg != null && _blueBookImg.isNotEmpty
                        ? Image.memory(base64Decode(_blueBookImg))
                        : Row(children: [
                            Icon(Icons.photo),
                            SizedBox(width: 6),
                            Text('Choose Image')
                          ]),
                  )),
            )
          ],
        ),
      );
    }

    Widget workingTypeWidget() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Working Type',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Column(
              children: [
                RadioListTile<String>(
                  value: WorkingType.fulltime,
                  groupValue: _type,
                  onChanged: (value) {
                    setState(() {
                      _type = value;
                      workingType = value.toString();
                      print(workingType);
                    });
                  },
                  title: Text("Full Time"),
                ),
                RadioListTile<String>(
                  value: WorkingType.parttime,
                  groupValue: _type,
                  onChanged: (value) {
                    setState(() {
                      _type = value;
                      workingType = value.toString();
                      print(workingType);
                    });
                  },
                  title: Text("Part Time"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget vehicleTypeWidget() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Vehicle Type',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                items: [VehicleType.taxi, VehicleType.bike]
                    .map<DropdownMenuItem<String>>((String e) =>
                        DropdownMenuItem<String>(child: Text(e), value: e))
                    .toList(),
                value: _vehicleType,
                hint: Text("Choose Vehicle Type"),
                onChanged: (type) {
                  setState(() {
                    _vehicleType = type;
                  });
                },
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () async {
                  var res = await _showPicker(context);
                  if (res != null)
                    setState(() {
                      _profileImg = res;
                    });
                },
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: _profileImg == null
                      ? null
                      : MemoryImage(
                          base64Decode(
                            _profileImg,
                          ),
                          scale: 0.5),
                  radius: 60,
                  child: _profileImg != null
                      ? null
                      : Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text((_profileImg == null ? 'Select' : 'Change') +
                        ' Profile Picture')),
              ),
              vehicleTypeWidget(),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Input Name';
                  }
                  return null;
                },
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Name', prefixIcon: Icon(Icons.person)),
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Input Phone Number';
                  } else if (input.length < 10) {
                    return 'Input 10 digit number';
                  }
                  return null;
                },
                controller: _phoneController,
                style: TextStyle(fontSize: 35),
                maxLength: 10,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 16),
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone)),
              ),
              workingTypeWidget(),
              vehicleInfoWidget(),
              licenseBluebook(),
              TextFormField(
                controller: _referalCodeController,
                decoration: InputDecoration(
                    labelText: 'Referal Code (Optional)',
                    prefixIcon: Icon(Icons.code)),
              ),
              submitButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget submitButton() {
    return MaterialButton(
      onPressed: () async {
        final formState = formKey.currentState;
        if (formState.validate() &&
            _licenseImg.isNotEmpty &&
            _blueBookImg.isNotEmpty &&
            _profileImg != null &&
            workingType != "") {
          formState.save();
          String _plateNUm =
              "$_zone-$_lot-$_vehicleCat-${_vehicleNumberController.text}";
          print(_plateNUm);
          var mob = await MobileDetails.getDetails;
          Utilities.showPlatformSpecificAlert(
            dismissable: false,
            title: 'Registering',
            body: 'Please wait',
            canclose: false,
          );
          var res = await Driver.register(
              bluebook: _blueBookImg,
              license: _licenseImg,
              deviceId: mob.modelName,
              name: _nameController.text,
              phone: _phoneController.text,
              vehicleNum: _plateNUm,
              image: _profileImg,
              vehicleType: _vehicleType,
              workType: workingType,
              referalCode: _referalCodeController.text);

          if (res is bool) {
            Utilities.showInToast('Succesfully Registered',
                toastType: ToastType.SUCCESS);
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Utilities.showInToast(res.toString(), toastType: ToastType.ERROR);
            Navigator.pop(context);
          }
        } else {
          Utilities.showInToast("Please complete the form",
              toastType: ToastType.ERROR);
        }
      },
      textColor: Colors.white,
      color: Theme.of(context).primaryColor,
      child: Text('Submit'),
    );
  }
}

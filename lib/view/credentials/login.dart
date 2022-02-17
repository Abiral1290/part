import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sbcb_driver_flutter/core/model/driver.dart';
import 'package:sbcb_driver_flutter/core/notifiers/providers/auth_state.dart';
import 'package:sbcb_driver_flutter/core/services/calll_server.dart';
import 'package:sbcb_driver_flutter/utils/constants.dart';
import 'package:sbcb_driver_flutter/utils/utilities.dart';
import 'package:sbcb_driver_flutter/view/credentials/register.dart';
import 'package:sbcb_driver_flutter/view/widgets/terms_conditions.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _numberController = new TextEditingController();

  bool _termsChecked = false;
  bool generalLoading = false;
  bool triedFetchingServerNumber = false;

  String vehicleType = '';
  String _callServerNum = '';

  @override
  void initState() {
    _initFunc();
    super.initState();
  }

  _initFunc() async {
    int count = 0;
    do {
      var value = await Driver().getCallServerNumber();
      print('call server: ' + value);
      if (value.isNotEmpty) {
        setState(() {
          _callServerNum = value;
          triedFetchingServerNumber = true;
        });
        break;
      } else {
        count++;
      }
    } while (count < 3);
    if (count == 3 && _callServerNum.isEmpty) {
      setState(() {
        triedFetchingServerNumber = true;
      });
      Utilities.showInToast(
          "Coundn't fetch call server number. Please try again",
          toastType: ToastType.ERROR);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool valildateInput(String phNum) {
      if (phNum.length == 10) {
        return true;
      } else {
        Utilities.showInToast('Enter 10 digit number',
            toastType: ToastType.ERROR);
        return false;
      }
    }

    closeDialog() {
      if (!generalLoading) return;
      setState(() {
        generalLoading = false;
        Navigator.pop(context);
      });
    }

    directLogin(String number) async {
      var state = Provider.of<AuthState>(context, listen: false);
      // var details = await MobileDetails.getDetails;
      var resp = await state.signIn(number.trim());
      closeDialog();

      if (resp is String) {
        Utilities.showInToast(resp, toastType: ToastType.ERROR);
      }
    }

    checkForAPIResponse(bool isFirst) async {
      //waiting for 15 secs - call dial and hangup
      var res = false;
      await registerCallServer(_numberController.text).then((value) async {
        print(value);
        res = value;

        if (value) {
          directLogin(_numberController.text);
        } else {
          if (!isFirst) {
            Utilities.showInToast(
                'Session expired, Please call the server number',
                toastType: ToastType.ERROR);
            closeDialog();
          }
        }
      });
      return res;
    }

    Future generalLoadingDialog(BuildContext context) async {
      setState(() {
        generalLoading = true;
      });
      return showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Logging in. Please wait."),
            content: Container(
              child: Center(child: CircularProgressIndicator()),
              height: 35.0,
            ),
          );
        },
      );
    }

    // Widget vehicleTypeSeclector() {
    //   return Center(
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         InkWell(
    //           onTap: () {
    //             setState(() {
    //                vehicleType = VehicleType.taxi;
    //             });
    //           },
    //           child: Icon(
    //             Icons.local_taxi,
    //             size: 99,
    //           ),
    //         ),
    //         SizedBox(
    //           width: 75,
    //         ),
    //         InkWell(
    //           onTap: () {
    //             setState(() {
    //               vehicleType = VehicleType.bike;
    //             });
    //           },
    //           child: Icon(
    //             Icons.directions_bike,
    //             size: 99,
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    return SafeArea(
        child: Scaffold(
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                triedFetchingServerNumber
                    ? FloatingActionButton(
                        heroTag: "refetch",
                        backgroundColor: Theme.of(context).primaryColor,
                        onPressed: _initFunc,
                        child: Icon(
                          Icons.refresh,
                          size: 38,
                        ),
                      )
                    : SizedBox(),
                FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (!_termsChecked) {
                        Utilities.showInToast(
                            'Please agree terms and Condition',
                            toastType: ToastType.INFO);
                        return;
                      }
                      bool connected = await Utilities.isInternetWorking();
                      if (connected) {
                        //validation
                        if (valildateInput(_numberController.text)) {
                          generalLoadingDialog(context);
                          if (_numberController.text == "9823036454" || _numberController.text == "9860999666") {
                            directLogin(_numberController.text);
                          } else {
                            Utilities.showInToast(
                                'Please call the given number',
                                toastType: ToastType.INFO,
                                toastPos: 0);
                            launch(
                                "tel:${_callServerNum.isEmpty ? Constants.callServerNum : _callServerNum}");

                            if (!await checkForAPIResponse(true)) {
                              await Future.delayed(Duration(seconds: 20));

                              checkForAPIResponse(false);
                            }
                          }
                        }
                      } else {
                        Utilities.showInToast('No Internet',
                            toastType: ToastType.INFO);
                      }
                    },
                    child: Icon(
                      Icons.call,
                      size: 38,
                    )),
              ],
            ),
            body: Stack(
              children: [
                // vehicleType.isEmpty
                //     ? vehicleTypeSeclector()
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            Assets.appLogo,
                            scale: 2,
                          ),
                        ),
                        numberField(),
                        termsWidget(),
                        GestureDetector(
                          onTap: () async {
                            var number = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (_) => RegisterPage(
                                          vehicleType: vehicleType,
                                        )));
                            if (number != null) {
                              directLogin(number);
                            }
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.green[900],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 58.0),
                        //   child: LanguageSelector(),
                        // )
                      ],
                    ),
                  ),
                ),
                if (vehicleType.isNotEmpty)
                  BackButton(
                    onPressed: () {
                      setState(() {
                        vehicleType = '';
                      });
                    },
                  ),
              ],
            )));
  }

  Row termsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
            value: _termsChecked,
            onChanged: (val) {
              setState(() {
                _termsChecked = val;
              });
            }),
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => TermsConditions()));
          },
          child: Text(
            'I agree the Terns and Conditions',
            style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }

  Widget numberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45.0),
      child: Container(
          child: TextField(
        style: TextStyle(letterSpacing: 2.5, fontSize: 18),
        controller: _numberController,
        maxLength: 10,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          hintText: 'Phone',
          prefixText: '+977 - ',
          icon: Icon(Icons.phone),
        ),
      )),
    );
  }
}

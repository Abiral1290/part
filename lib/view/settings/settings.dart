import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sbcb_driver_flutter/core/model/driver.dart';
import 'package:sbcb_driver_flutter/core/notifiers/providers/auth_state.dart';
import 'package:sbcb_driver_flutter/utils/constants.dart';
import 'package:sbcb_driver_flutter/utils/utilities.dart';
import 'package:sbcb_driver_flutter/view/transaction/transaction_page.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget bodyData(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: Colors.green[900],
            ),
          ),
        ],
      ),
    );
  }

  Widget shareWidget(AuthState state) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                "Your Referral Code",
                style: TextStyle(fontSize: 18.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    state.driver.phone,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  IconButton(
                      onPressed: () {
                        Clipboard.setData(
                                ClipboardData(text: state.driver.phone))
                            .whenComplete(() => Utilities.showInToast(
                                "Copied to clipboard",
                                toastType: ToastType.SUCCESS));
                      },
                      icon: Icon(Icons.copy)),
                ],
              ),
            ],
          ),
          VerticalDivider(
            thickness: 3.0,
          ),
          Column(
            children: [
              Text(
                "Share App",
                style: TextStyle(fontSize: 18.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Share.share(Constants.playstoreShareLink);
                    },
                    icon: Icon(
                      Icons.android,
                      color: Colors.green[700],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Share.share(Constants.appstoreShareLink);
                    },
                    icon: Icon(Icons.phone_iphone),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Consumer<AuthState>(builder: (context, authState, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Profile"),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TransactionPage()));
            },
            label: Text("View Transactions"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(authState.driver.isApproved == 1
                              ? "Approved"
                              : authState.driver.isRejected == 1
                                  ? "Rejected"
                                  : "Pending"),
                          Icon(
                            Icons.circle,
                            color: authState.driver.isApproved == 1
                                ? Colors.green
                                : authState.driver.isRejected == 1
                                    ? Colors.red
                                    : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 35.0,
                      child: Text(
                        authState.driver.name.substring(0, 1),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      authState.driver.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      authState.driver.phone,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Divider(
                      height: 15,
                      thickness: 3,
                    ),
                    FutureBuilder<String>(
                      future: Driver.getTaxiRatingAPI(authState.driver.id),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == 'N/A')
                            return Container(
                              child: Text(snapshot.data),
                            );
                          else {
                            int number = double.parse(snapshot.data).toInt();

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(number, (n) {
                                return Icon(Icons.star);
                              }),
                            );
                          }
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    bodyData("Vehicle Type", authState.driver.vehicleType),
                    bodyData("Number Plate", authState.driver.uniqueId),
                    bodyData("Phone", authState.driver.phone),
                    bodyData("Date", authState.driver.date),
                    Divider(
                      height: 15,
                      thickness: 3,
                    ),
                    shareWidget(authState),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

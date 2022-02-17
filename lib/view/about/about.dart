import 'package:flutter/material.dart';
import 'package:sbcb_driver_flutter/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  Widget infoWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            Assets.appLogo,
            scale: 2,
          ),
          SizedBox(
            height: 13,
          ),
          Text(
            'Sambriddha Multi-purpose Community Busines Pvt.Ltd',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 13,
          ),
          GestureDetector(
            onTap: () {
              launch('tel://061536271');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone),
                SizedBox(
                  width: 13,
                ),
                Text(
                  '061536271', //०६१६२०२१०
                  // style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              launch('tel://061536272');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone),
                SizedBox(
                  width: 13,
                ),
                Text(
                  '061536272', //०६१६२०२१०
                  // style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              launch('https://sbcb.com.np/');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.web),
                SizedBox(
                  width: 13,
                ),
                Text(
                  'sbcb.com.np', //०६१६२०२१०
                  // style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              launch('mailto:info@sbcb.com.np');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email),
                SizedBox(
                  width: 13,
                ),
                Text(
                  'info@sbcb.com.np', //०६१६२०२१०
                  // style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: infoWidget(),
    );
  }
}

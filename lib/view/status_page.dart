import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sbcb_driver_flutter/core/notifiers/providers/location_state.dart';

class StatusPage extends StatefulWidget {
  final LocationState locationState;

  StatusPage({this.locationState});

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<StatusClass> listStatus = [];

  @override
  Widget build(BuildContext context) {
    log(
      'hello',
      name: 'name',
      time: DateTime.now(),
    );

    StatusClass statusClass = StatusClass(
      status: widget.locationState.trackCarState,
      time: DateTime.now(),
    );
    listStatus.add(statusClass);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Status'),
          actions: [
            FlatButton(
              child: Text(
                "Clear",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  listStatus.clear();
                });
              },
            )
          ],
        ),
        body: ListView(
            children: listStatus
                .map((e) {
                  return Card(
                    child: ListTile(
                      leading: Icon(e.status ? Icons.check : Icons.error),
                      tileColor: e.status ? Colors.green : Colors.red,
                      title: Text(e.time.toString().split('.').first),
                    ),
                  );
                })
                .toList()
                .reversed
                .toList()));
  }
}

class StatusClass {
  bool status;
  DateTime time;

  StatusClass({this.status, this.time});
}

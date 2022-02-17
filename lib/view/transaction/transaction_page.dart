import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sbcb_driver_flutter/core/model/transaction.dart';
import 'package:sbcb_driver_flutter/core/notifiers/providers/transaction_state.dart';

class TransactionPage extends StatelessWidget {
  final TextStyle textStyle = TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildTransactionTile(Transaction transaction) {
      return Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          padding: EdgeInsets.all(10.0),
          // height: size.height * 0.15,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "From:          ",
                    style: textStyle,
                  ),
                  // Spacer(),
                  Flexible(
                    child: Text(
                      transaction.start,
                      overflow: TextOverflow.ellipsis,
                      // style: textStyle.copyWith(fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "To:              ",
                    style: textStyle,
                  ),
                  // Spacer(),
                  Flexible(
                    child: Text(
                      transaction.end,
                      overflow: TextOverflow.visible,
                      // style: textStyle.copyWith(fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Income:     ",
                    style: textStyle,
                  ),
                  // Spacer(),
                  Flexible(
                    child: Text(
                      "Rs. " + transaction.totalAmount.toString(),
                      style: textStyle.copyWith(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Distance:   ",
                    style: textStyle,
                  ),
                  // Spacer(),
                  Flexible(
                    child: Text(
                      transaction.totalDistance.toString() + ' KM',
                      // style: textStyle.copyWith(fontSize: 15),
                    ),
                  ),
                ],
              ),
              Text(DateFormat.yMEd()
                  .add_jms()
                  .format(DateTime.parse(transaction.createdAt))),
            ],
          ),
        ),
      );
    }

    Widget buildFromToTile(TransactionState transactionState) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("From"),
                Container(
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: Row(
                    children: [
                      Text(DateFormat.yMd()
                          .format(DateTime.parse(transactionState.startDate))),
                      InkWell(
                        child: Icon(Icons.date_range),
                        onTap: () async {
                          var fromDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.parse(transactionState.startDate),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now().add(Duration(days: 7)));
                          if (fromDate != null) {
                            transactionState.setStartDate(fromDate.toString());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("To"),
                Container(
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: Row(
                    children: [
                      Text(DateFormat.yMd()
                          .format(DateTime.parse(transactionState.endDate))),
                      InkWell(
                        child: Icon(Icons.date_range),
                        onTap: () async {
                          var toDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.parse(transactionState.endDate),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now().add(Duration(days: 7)));
                          if (toDate != null) {
                            transactionState.setEndDate(toDate.toString());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    Widget buildTotalTile(TransactionState transactionState) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(5.0),
          width: size.width,
          // height: size.height * 0.05,
          child: Column(
            children: [
              Text(
                "Total Income:  Rs. ${transactionState.totalRate}",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Total Distance:  ${transactionState.totalDistance} KM",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    return Consumer<TransactionState>(
      builder: (context, transactionState, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Transaction"),
            actions: [
              IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () => transactionState.fetchTransactions())
            ],
          ),
          body: transactionState.transactionList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    buildFromToTile(transactionState),
                    transactionState.transactionList.isEmpty
                        ? Center(child: Text("No transaction yet!"))
                        : Expanded(
                            child: ListView.builder(
                              itemCount:
                                  transactionState.transactionList.length,
                              itemBuilder: (context, index) {
                                return buildTransactionTile(
                                    transactionState.transactionList[index]);
                              },
                            ),
                          ),
                    buildTotalTile(transactionState),
                  ],
                ),
        );
      },
    );
  }
}

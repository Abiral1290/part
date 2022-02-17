import 'package:flutter/foundation.dart';
import 'package:sbcb_driver_flutter/core/model/transaction.dart';

class TransactionState with ChangeNotifier {
  String _startDate = DateTime.now().subtract(Duration(days: 1)).toString();
  String _endDate = DateTime.now().toString();

  int _totalRate = 0;
  double _totalDistance = 0.0;

  List<Transaction> transactionList;

  String get startDate => _startDate;
  String get endDate => _endDate;

  int get totalRate => _totalRate;
  double get totalDistance => _totalDistance;

  TransactionState() {
    fetchTransactions();
  }

  void setStartDate(String start) {
    _startDate = start;
    fetchTransactions();
  }

  void setEndDate(String end) {
    _endDate = end;
    fetchTransactions();
  }

  fetchTransactions() {
    getTransactionAPI(startDate, endDate).then((value) {
      if (value != null) {
        transactionList = value;
        print("List of transaction: ${transactionList.length}");
        _totalRate = 0;
        _totalDistance = 0.0;
        for (var transaction in transactionList) {
          _totalRate = _totalRate + transaction.totalAmount;
          _totalDistance = _totalDistance + transaction.totalDistance;
        }

        notifyListeners();
      }
    });
  }
}

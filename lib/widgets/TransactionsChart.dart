import 'package:expense_tracker/models/Transaction.dart';
import 'package:expense_tracker/widgets/ChartBar.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class TransactionsChart extends StatelessWidget {
  TransactionsChart({this.weeklyTransactions});
  final List<Transaction> weeklyTransactions;

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSumOfTheDay = 0.0;

      for(var i=0; i<weeklyTransactions.length; i++) {
        if(weeklyTransactions[i].date.day == weekDay.day &&
            weeklyTransactions[i].date.month == weekDay.month &&
            weeklyTransactions[i].date.year == weekDay.year) {
          totalSumOfTheDay += weeklyTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSumOfTheDay,
      };
    }).reversed.toList();
  }

  double get totalSpendingOfTheWeek {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: data['day'],
                spendingAmount: data['amount'],
                percentageTotal: totalSpendingOfTheWeek == 0.0 ? 0.0 : (data['amount'] as double)/totalSpendingOfTheWeek,
              ),
            );
          }).toList()
        ),
      ),
    );
  }
}

import 'package:expense_tracker/models/Transaction.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/TransactionTile.dart';

class TransactionCard extends StatelessWidget {
  TransactionCard({this.transactions, this.deleteTransaction});
  final List<Transaction> transactions;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return transactions.isEmpty ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/z.png',
            fit: BoxFit.cover,
            height: mediaQuery.size.height*0.3,
          ),
          Text(
            'No Transactions added yet!',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    ) : ListView(
          children: transactions.map((tx) => TransactionTile(
              key: ValueKey(tx.id),
              transaction: tx,
              mediaQuery: mediaQuery,
              deleteTransaction: deleteTransaction
          )).toList(),
    );
  }
}
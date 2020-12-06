import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_tracker/models/Transaction.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    Key key,
    @required this.transaction,
    @required this.mediaQuery,
    @required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final MediaQueryData mediaQuery;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 8.0,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30.0,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FittedBox(
              child: Text('\$${transaction.amount}'),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
        ),
        trailing: mediaQuery.size.width > 400 ?
        FlatButton.icon(
          icon: Icon(Icons.delete),
          label: Text('Delete'),
          textColor: Theme.of(context).errorColor,
          onPressed: () => deleteTransaction(transaction.id),
        ) :
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).errorColor,
          ),
          onPressed: () => deleteTransaction(transaction.id),
        ),
      ),
    );
  }
}
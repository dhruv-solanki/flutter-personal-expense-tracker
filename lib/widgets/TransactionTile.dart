import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_tracker/models/Transaction.dart';

class TransactionTile extends StatefulWidget {
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
  _TransactionTileState createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  Color _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.black,
      Colors.yellow,
      Colors.teal,
      Colors.pink,
    ];

    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

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
          backgroundColor: _bgColor,
          radius: 30.0,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FittedBox(
              child: Text('\$${widget.transaction.amount}'),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),
        trailing: widget.mediaQuery.size.width > 400 ?
        FlatButton.icon(
          icon: Icon(Icons.delete),
          label: Text('Delete'),
          textColor: Theme.of(context).errorColor,
          onPressed: () => widget.deleteTransaction(widget.transaction.id),
        ) :
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).errorColor,
          ),
          onPressed: () => widget.deleteTransaction(widget.transaction.id),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:expense_tracker/models/Transaction.dart';
import 'package:expense_tracker/widgets/TransactionCard.dart';
import 'package:expense_tracker/widgets/TransactionForm.dart';
import 'package:expense_tracker/widgets/TransactionsChart.dart';

void main() {
//  WidgetsFlutterBinding.ensureInitialized();
//  SystemChrome.setPreferredOrientations([
//    DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown,
//  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expense Tracker",
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.pink,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
          button: TextStyle(
            color: Colors.white,
          )
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20.0,
            ),
          ),
        )
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
//    Transaction(id: 't1', title: 'iPhone X', amount: 999.9, date: DateTime.now()),
//    Transaction(id: 't2', title: 'Jacket', amount: 45.15, date: DateTime.now()),
  ];

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: txDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(context: ctx, builder: (_) {
      return GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: TransactionForm(
          addTx: _addNewTransaction,
        ),
      );
    });
  }

  List<Transaction> get _weeklyTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  bool _showChart = false;

  List<Widget> _buildLandscapeMode(MediaQueryData mediaQuery, AppBar appBar, Widget txsCard) {
    return [Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Show Chart',
          style: Theme.of(context).textTheme.headline6,
        ),
        Switch.adaptive(
          value: _showChart,
          onChanged: (val) {
            setState(() {
              _showChart = val;
            });
          },
        )
      ],
    ), _showChart ? Container(
        height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) * 0.6,
        child: TransactionsChart(
          weeklyTransactions: _weeklyTransactions,
        ),
      ) : txsCard];
  }

  List<Widget> _buildPortraitMode(MediaQueryData mediaQuery, AppBar appBar, Widget txsCard) {
    return [Container(
      height: (mediaQuery.size.height -
          appBar.preferredSize.height -
          mediaQuery.padding.top) * 0.3,
      child: TransactionsChart(
        weeklyTransactions: _weeklyTransactions,
      ),
    ), txsCard];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS ? CupertinoNavigationBar(
      middle: Text('Personal Expenses'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context),
          )
        ],
      ),
    ) : AppBar(
      title: Text(
        'Expense Tracker',
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
          ),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
    final txsCard = Container(
      height: (mediaQuery.size.height -
          appBar.preferredSize.height -
          mediaQuery.padding.top) * 0.7,
      child: TransactionCard(
        transactions: _userTransactions,
        deleteTransaction: _deleteTransaction,
      ),
    );
    final pageBody = SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            if(isLandscape)
              ..._buildLandscapeMode(mediaQuery, appBar, txsCard),
            if(!isLandscape)
              ..._buildPortraitMode(mediaQuery, appBar, txsCard),
          ],
        ),
      ),
    );

    return Platform.isIOS ? CupertinoPageScaffold(
      navigationBar: appBar,
      child: pageBody,
    ) : Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS ? Container() : FloatingActionButton(
        child: Icon(
          Icons.add
        ),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}

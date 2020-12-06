import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {

  TransactionForm({this.addTx});
  final Function addTx;

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate;

  void _submitData() {
    final titleInput = _titleController.text;
    final amountInput = double.parse(_amountController.text);

    if(titleInput == '' || amountInput <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      titleInput,
      amountInput,
      _selectedDate,
    );

    Navigator.pop(context);
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if(pickedDate == null) {
        return;
      }
     setState(() {
       _selectedDate = pickedDate;
     });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: mediaQuery.viewInsets.bottom + 10
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    labelText: 'Title'
                ),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Amount'
                ),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _selectedDate == null ?
                      'No Date Chosen!' :
                      'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Pick Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: _presentDatePicker,
                    )
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                child: Text('Add Transaction'),
                onPressed: _submitData
              )
            ],
          ),
        ),
      ),
    );
  }
}

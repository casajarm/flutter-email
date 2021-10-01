import 'package:flutter/material.dart';

/* mostly taken from https://medium.com/flutterdevs/dropdown-in-flutter-324ae9caa743 */
class DropdownList extends StatefulWidget {
  DropdownList(this._itemsList, this._chosenValue, this.changeHandler);

  List<String> _itemsList;
  String? _chosenValue;
  Function changeHandler;
  @override
  _DropdownState createState() =>
      _DropdownState(_itemsList, _chosenValue, changeHandler);
}

class _DropdownState extends State<DropdownList> {
  List<String> _itemsList;
  String? _chosenValue;
  Function changeHandler;

  _DropdownState(this._itemsList, this._chosenValue, this.changeHandler);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: DropdownButton<String>(
        value: _chosenValue ?? _itemsList[0],
        //elevation: 5,
        style: TextStyle(color: Colors.black),

        items: _itemsList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: Text(
          "Please choose an email account",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onChanged: (String? value) => setState(() {
          if (value!.isNotEmpty) {
            _chosenValue = value;
            print('set droplist selected value to: ' + value);
          }
          changeHandler(value);
        }),
      ),
    );
  }
}

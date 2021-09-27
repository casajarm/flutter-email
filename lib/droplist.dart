import 'package:flutter/material.dart';
/* mostly taken from https://medium.com/flutterdevs/dropdown-in-flutter-324ae9caa743 */
class DropdownList extends StatefulWidget {
  //String chosenValue;
  List<String> itemsList;
  String stateElement;
  DropdownList(this.itemsList, this.stateElement);
  @override
  _DropdownState createState() => _DropdownState(itemsList, stateElement);
}

class _DropdownState extends State<DropdownList> {
  List<String> _itemsList;
  String _chosenValue = '1';
  String _stateElement;

  _DropdownState(this._itemsList, this._stateElement);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(0.0),
        child: DropdownButton<String>(
          value: _itemsList[0],
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
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          onChanged: (String? value) => setState(() {
            if (value!.isNotEmpty) {
              _chosenValue = value;
              _stateElement = value;
              print('set value to: ' + value);
            }
            }),
        ),
      );
  }
}
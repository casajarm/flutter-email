import 'package:flutter/material.dart';

class DropdownList extends StatefulWidget {
  //String chosenValue;
  List<String> itemsList;
  DropdownList(this.itemsList);
  @override
  _DropdownState createState() => _DropdownState(itemsList);
}

class _DropdownState extends State<DropdownList> {
  List<String> _itemsList;
  String _chosenValue = '1';

  _DropdownState(this._itemsList);
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
            "Please choose a langauage",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          onChanged: (String? value) => setState(() {
            if (value!.isNotEmpty) {
              this._chosenValue = value;
              print('set value to: ' + value);
            }
            }),
        ),
      );
  }
}
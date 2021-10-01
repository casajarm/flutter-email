import 'package:flutter/material.dart';

import './droplist.dart';
import './models/email-message.dart';
import './models/mail-provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generated App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<
      FormState>(); //important to annotate that the globalkey is formstate object
  final _message = EmailMessage();
  var _emailService = EmailService();
  final List<String> emailsList =
      emailConfigs.map<String>((e) => e.EmailAddress).toList();
  //have to be really specific here to tell dart that the list coming into map is going to be a string

  void setFromAddress(address) {
    setState(() {
      _message.fromUser = address;
      print('setting state for from address: ' + address);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Handbill'),
      ),
      body: Container(
        child: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: Text(
                        "Send Message",
                        style: TextStyle(
                          fontSize: 26.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Merriweather",
                        ),
                      ),
                    ),
                    Text(
                      "From Address",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Merriweather",
                      ),
                    ),
                    DropdownList(emailsList, _message.fromUser, setFromAddress),
                    Text(
                      "Subject",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Merriweather",
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a subject';
                        }
                      },
                      onSaved: (val) => setState(() => _message.subject = val!),
                      style: TextStyle(
                        fontSize: 22.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Merriweather",
                      ),
                    ),
                    Text(
                      "Message",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Merriweather",
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a message';
                        }
                      },
                      onSaved: (val) => setState(() => _message.message = val!),
                      minLines: 6,
                      maxLines: 14,
                      style: TextStyle(
                        fontSize: 22.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w200,
                        fontFamily: "Merriweather",
                      ),
                    ),
                    TextButton(
                        key: null,
                        onPressed: () {
                          final form = _formKey.currentState;
                          if (form!.validate()) {
                            form.save();
                            //_message.fromUser = ; //TODO get the user account from the selected email address
                            _message.save();
                            /* _showDialog(context); */
                          }
                        },
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            primary: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w600,
                              fontFamily: "Merriweather",
                            ),
                            backgroundColor: Colors.blue),
                        child: Text(
                          "Send Message",
                        )),
                  ]),
              padding: const EdgeInsets.all(0.0),
              alignment: Alignment.center,
            ),
          ),
        ),
      ),
    );
  }
}

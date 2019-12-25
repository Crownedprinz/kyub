import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kyub/services/api_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'data/Json_user.dart';
import 'login_page.dart';

class ConfirmPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ConfirmPage> {
  final _formKey = GlobalKey<FormState>();
  String _ticket;
  bool _isLoading = false;
  

  @override
  Widget build(BuildContext context) {
    final ticketText = Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        onSaved: (value) => _ticket = value.trim(),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please input a valid ticket';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Ticket Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );

    final submitButton = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        elevation: 5.0,
        shadowColor: Colors.lime.shade100,
        child: MaterialButton(
          minWidth: 200.0,
          height: 48.0,
          child: Text(
            "Confirm Ticket",
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          color: Colors.lime,
          onPressed: () async {
            var s = new Service();
            final form = _formKey.currentState;
            form.save();
            if (form.validate()) {
              setState(() => _isLoading = true);
              var res = await s.confirmTicket(_ticket);

              var responseJson = json.decode(res.data);
              
              if (res.statusCode == 200 || res.statusCode == 201) {
                JsonUser message = JsonUser.fromSuccess(responseJson);
                setState(() => _isLoading = false);
                Alert(
                  context: context,
                  type: AlertType.success,
                  title: "Bravo",
                  desc: message.accessToken,
                  buttons: [
                    DialogButton(
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                      onPressed: (){ 
                          setState(() => _isLoading = false);
                          Navigator.pop(context);
                          },
                      width: 120,
                    )
                  ],
                ).show();
              } else if (res.statusCode == 400) {
                 JsonUser message = JsonUser.fromError(responseJson);
                Alert(
                  context: context,
                  type: AlertType.error,
                  title: "Error",
                  desc: message.accessToken,
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                      onPressed: (){ 
                          setState(() => _isLoading = false);
                          Navigator.pop(context);
                          },
                      width: 120,
                    )
                  ],
                ).show();
              } else
                Alert(
                  context: context,
                  type: AlertType.error,
                  title: "Error",
                  desc: "There seems to be a connectivity issue",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                      onPressed: () {
                         setState(() => _isLoading = false);
                        Navigator.pop(context);
                      },
                      width: 120,
                    )
                  ],
                ).show();
            }
          },
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("The Kyub Ticket Validation"),
        actions: <Widget>[LogoutButton()],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child:_isLoading
                  ? LoadingCircle()
                  : ListView(
            children: [ticketText, submitButton],
          ),
        ),
      ),
    );
  }
}

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: new Icon(Icons.exit_to_app),
        onPressed: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                settings: RouteSettings(name: "LoginPage"),
                builder: (BuildContext context) => LoginPage()),
          );
        });
  }
}
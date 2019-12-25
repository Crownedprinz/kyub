import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kyub/confirm_ticket.dart';
import 'package:kyub/services/api_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'data/Json_user.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _email;
  bool _isLoading = false;

  

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  var radius = 32.0;
  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      onSaved: (value) => _email = value.trim(),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please input your email address';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Email',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(radius))),
    );
    final passwordField = TextFormField(
      onSaved: (value) => _password = value.trim(),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please input your password';
        }
        return null;
      },
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: 'Password',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(radius))),
    );
    final loginButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xff01A0C7),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () async {
           var s = new Service();
           // s.getuser(_email, _password);
            // save the fields..
            final form = _formKey.currentState;
            form.save();
            if (form.validate()) {
              setState(() => _isLoading = true);
              var res = await s.getuser(_email, _password);
              var responseJson = json.decode(res.data);
              if (res.statusCode == 200 || res.statusCode == 201) {
                setState(() => _isLoading = false);
                var responseJson = json.decode(res.data);
                JsonUser user = JsonUser.fromSuccess(responseJson);
                if (user != null) {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new ConfirmPage();
                  }));
                } else {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("Wrong email or")));
                }
              } else if (res.statusCode == 401) {
                setState(() => _isLoading = false);
                JsonUser message = JsonUser.fromError(responseJson);
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
                      onPressed: () => Navigator.pop(context),
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
                      onPressed: () {
                         setState(() => _isLoading = false);
                        Navigator.pop(context);
                      },
                      width: 120,
                    )
                  ],
                ).show();
              }else{
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
            }
          },
          child: Text(
            'Login',
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ));

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            height: 90.0,
                            child: Image.asset(
                              "assets/logo.png",
                              fit: BoxFit.contain,
                            )),
                        SizedBox(height: 10.0),
                        emailField,
                        SizedBox(height: 10.0),
                        passwordField,
                        SizedBox(
                          height: 10.0,
                        ),
                        _isLoading ? LoadingCircle() : loginButton,
                      ],
                    ),
            ),
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

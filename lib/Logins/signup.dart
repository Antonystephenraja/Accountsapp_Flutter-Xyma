import 'dart:convert';
import 'package:account_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
class signup extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;
  String? _phone;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  Future register(BuildContext context) async {
    var url = Uri.parse("http://64.227.129.107/account_app/register.php");
    var response = await http.post(url, body: {
      "name": name.text,
      "email": email.text,
      "phone": phone.text,
      "password": password.text,
    });
    var data = json.decode(response.body);
    if (data == "Error") {
      Fluttertoast.showToast(
        msg: "This User Already Exists!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
    else {
      Fluttertoast.showToast(
        msg: "Registration Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER ,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 16.0,
      ); Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return Homepage();
        }),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/xyma.png',
                            height: 200,
                            width: 200,
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                "Login to your account",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(),
                          ),
                          controller: name, // Add this line
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _name = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                          ),
                          controller: email, // Add this line
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            // You can add more email validation logic if needed
                            return null;
                          },
                          onSaved: (value) {
                            _email = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Phone",
                            border: OutlineInputBorder(),
                          ),
                          controller: phone, // Add this line
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            }
                            // You can add more phone number validation logic if needed
                            return null;
                          },
                          onSaved: (value) {
                            _phone = value;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(),
                          ),
                          controller: password, // Add this line
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            // You can add more password validation logic if needed
                            return null;
                          },
                          onSaved: (value) {
                            _password = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  Padding(padding:
                  EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      padding: EdgeInsets.only(top: 1, left: 1),
                      margin: EdgeInsets.only(bottom: 190),

                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: ()  {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            register(context);
                          }
                        },
                        color: Colors.black,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),

                        ),
                        child: GestureDetector(
                          child: Text(
                            "Submit", style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
      )
    );
  }
}
// we will be creating a widget for text field
Widget inputFile({label, obscureText = false})
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color:Colors.black87
        ),
      ),
      SizedBox(
        height: 4,
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0,
                horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87)
            )
        ),
      ),
      SizedBox(height: 20,)
    ],
  );
}


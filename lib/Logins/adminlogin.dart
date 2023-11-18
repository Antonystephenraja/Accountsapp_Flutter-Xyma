import 'dart:convert';
import 'package:account_app/admin_dashboard/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class adminlogin extends StatefulWidget {
  const adminlogin({super.key});
  @override
  State<adminlogin> createState() => _adminlogin();
}

class _adminlogin extends State<adminlogin> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Color myColor;
  late Size mediaSize;
  String? _email;
  String? _password;
  Future<void> login(BuildContext context) async {
    var url = Uri.parse("http://64.227.129.107/account_app/adminlogin.php");
    var response = await http.post(url, body: {
      "email": emailController.text,
      "password": passwordController.text,
    });
    var data = json.decode(response.body);
    if (data == "Success") {
      Fluttertoast.showToast(
        msg: "Login Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return dashboard(email: emailController.text);
      }));
    } else {
      Fluttertoast.showToast(
        msg: "Username & Password incorrect!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
  bool rememberUser = false;
  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColorLight;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/group_img.jpg"),
          alignment: Alignment.topCenter,
          fit: BoxFit.cover,
          colorFilter:
          ColorFilter.mode(myColor.withOpacity(0.5), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(
            top: 30,
            left:10,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }


  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }
  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome",
            style: TextStyle(
                color: Colors.black, fontSize: 32, fontWeight: FontWeight.w500),
          ),
          _buildGreyText("Please login with your information"),
          const SizedBox(height: 20),
          _buildGreyText("Email address"),
          _buildInputField(emailController ,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              return null;
            },
            onSaved: (value) {
              _email = value;
            },),
          const SizedBox(height: 20),
          _buildGreyText("Password"),
          _buildInputField(passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
              onSaved: (value) {
                _password = value;
              },isPassword: true),
          const SizedBox(height: 20),
          _buildRememberForgot(),
          const SizedBox(height: 20),
          _buildLoginButton(),
          const SizedBox(height: 20),
          _buildOtherLogin(),
        ],
      ),
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.black54),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {bool isPassword = false, String? Function(String?)? validator, void Function(String?)? onSaved}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : Icon(Icons.done),
      ),
      obscureText: isPassword,
      validator: validator, // Add the validator here
      onSaved: onSaved,     // Add the onSaved callback here
    );
  }
  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
                value: rememberUser,
                onChanged: (value) {
                  setState(() {
                    rememberUser = value!;
                  });
                }),
            _buildGreyText("Remember me"),
          ],
        ),
        TextButton(
            onPressed: () {}, child: _buildGreyText("I forgot my password"))
      ],
    );
  }
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: (){
        if(formKey.currentState!.validate()){
          formKey.currentState!.save();
          login(context);
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: Colors.black,
        minimumSize: const Size.fromHeight(60),

      ),
      child: const Text(
        "login",
        style: TextStyle(color: Colors.white), // Set the text color here
      ),
    );
  }
  Widget _buildOtherLogin() {
    return Center(
      child: Column(
        children: [
          _buildGreyText("Or Login with"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tab(icon: Image.asset("assets/images/facebook.png")),
              Tab(icon: Image.asset("assets/images/twitter.png")),
              Tab(icon: Image.asset("assets/images/google.png")),
            ],
          )
        ],
      ),
    );
  }
}




import 'package:account_app/Logins/adminlogin.dart';
import 'package:account_app/Logins/signup.dart';
import 'package:account_app/Logins/userlogin.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(const Homepage());
}
class Homepage extends StatelessWidget {
  const Homepage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XYMA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'WELCOME TO XYMA'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 185),
            const Text(
              'Welcome to XYMA',
              style: TextStyle(
                fontSize: 22.0,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w900,
              ),
            ),
            Transform.scale(
              scale: 0.8, // adjust the scale as per your requirement
              child: Image.asset('assets/images/xyma.png'),
            ),
            SizedBox(height: 80),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return adminlogin();
                }));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 120.0,
                  vertical: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return LoginScreen()  ;
                }));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 120.0,
                  vertical: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return signup();
                }));
              },
              child: Text(
                'Create an account',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 16,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

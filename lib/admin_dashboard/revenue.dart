import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class total_revenue extends StatelessWidget {
  Future<List<dynamic>> getRecord() async {
    String uri = "http://64.227.129.107/account_app/total_revenue.php";
    try {
      var response = await http.get(Uri.parse(uri));
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return [];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Add the AppBar widget
        backgroundColor: Colors.grey, // Set the desired app bar color
        title: Text('Total Cost'), // Set the app bar title
      ),
      backgroundColor: Colors.grey,
      body: FutureBuilder<List<dynamic>>(
        future: getRecord(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> userdata = snapshot.data!;
            return ListView.builder(
              itemCount: userdata.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(50),
                  child: ListTile(
                    leading: Icon(Icons.attach_money,size: 60,color: Colors.brown,), // Add the Icon widget here
                    title: Column(
                      children: [
                        Center(
                         child: Text("TOTAL COST: ${userdata[index]["SUM(total_amount)"]}"),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error occurred"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

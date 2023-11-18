import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../user_dashboard/EditRecordScreen.dart';

class ViewData extends StatelessWidget {
  Future<List<dynamic>> getRecord() async {
    String uri = "http://64.227.129.107/account_app/recent_upload.php";
    try {
      var response = await http.get(Uri.parse(uri));
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> deleteRecord(List<dynamic> userdata, int index) async {
    String uri = "http://64.227.129.107/account_app/delete.php";
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          "id": userdata[index]["id"], // Pass the ID of the record to delete
        },
      );
      if (response.statusCode == 200) {
        // Successful deletion
        print("Record deleted");
      } else {
        // Failed to delete
        print("Failed to delete record");
      }
    } catch (e) {
      print(e);
    }
  }

  void editRecord(BuildContext context, dynamic record) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecordScreen(record: record),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total upload'),
        backgroundColor: Colors.orange,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<dynamic>>(
        future: getRecord(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> userdata = snapshot.data!;
            return SingleChildScrollView( // Wrap the ListView.builder with SingleChildScrollView
              child: ListView.builder(
                itemCount: userdata.length,
                shrinkWrap: true, // Set shrinkWrap to true
                physics: NeverScrollableScrollPhysics(), // Disable scrolling of the ListView
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: Container(
                      color: Colors.black12,
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Product Name: ${userdata[index]["product_name"]}"),
                            Text("Company Name: ${userdata[index]["company_name"]}"),
                            Text("Invoice Number: ${userdata[index]["invoice_no"]}"),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date: ${userdata[index]["date"]}"),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                editRecord(context, userdata[index]);
                              },
                              child: Icon(Icons.edit,color: Colors.black),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm Delete"),
                                      content: Text("Are you sure you want to delete this record?"),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Delete"),
                                          onPressed: () {
                                            deleteRecord(userdata, index);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Icon(Icons.delete,color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
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

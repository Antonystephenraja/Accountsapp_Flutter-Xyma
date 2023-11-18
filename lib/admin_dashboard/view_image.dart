import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ViewImage1 extends StatefulWidget {

  const ViewImage1({Key? key}) : super(key: key);

  @override
  State<ViewImage1> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage1> {
  List<dynamic> record = [];

  Future<void> imageFromDb() async {
    try {
      String uri = "http://64.227.129.107/account_app/adminimages.php?";
      var response = await http.get(Uri.parse(uri));
      setState(() {
        record = jsonDecode(response.body);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    imageFromDb();
  }

  void viewImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: InteractiveViewer(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Image'),
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
      body: SingleChildScrollView(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: record.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () => viewImage("http://64.227.129.107/account_app/uploads/" + record[index]["filename"]),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        "http://64.227.129.107/account_app/uploads/" + record[index]["filename"],
                      ),
                    ),
                    Text(record[index]["invoice_no"]),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

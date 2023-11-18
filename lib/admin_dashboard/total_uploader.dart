import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class TableView extends StatefulWidget {
  const TableView({Key? key}) : super(key: key);
  @override
  State<TableView> createState() => _ViewImageState();
}

class _ViewImageState extends State<TableView> {
  List<Map<String, dynamic>> _users = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  void fetchData() async {
    final response = await http.get(Uri.parse('http://64.227.129.107/account_app/pdf.php'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      setState(() {
        _users = jsonData.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to fetch data from the server');
    }
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
      ),   body: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(),
          defaultColumnWidth: FixedColumnWidth(150.0),
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[300]),
              children: [
                TableCell(child: Center(child: Text('ID'))),
                TableCell(child: Center(child: Text('Date'))),
                TableCell(child: Center(child: Text('Invoice Number'))),
                TableCell(child: Center(child: Text('Company Name'))),
                TableCell(child: Center(child: Text('Uploader Name'))),
                TableCell(child: Center(child: Text('Product Name'))),
                TableCell(child: Center(child: Text('Paid By'))),
                TableCell(child: Center(child: Text('Advance Amount'))),
                TableCell(child: Center(child: Text('Balance Amount'))),
                TableCell(child: Center(child: Text('Total Amount'))),
                TableCell(child: Center(child: Text('Remarks'))),
              ],
            ),
            ..._users.map((user) {
              return TableRow(
                children: [
                  TableCell(
                    child: Container(
                      height: 30.0, // Increase the height as per your requirement
                      child: Center(child: Text(user['id'].toString())),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      height: 30.0,
                      child: Center(child: Text(user['date'].toString())),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      height: 30.0,
                      child: Center(child: Text(user['invoice_no'].toString())),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      height: 30.0,
                      child: Center(child: Text(user['company_name'].toString())),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      height: 30.0,
                      child: Center(child: Text(user['uploader_name'].toString())),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      height: 30.0,
                      child: Center(child: Text(user['product_name'].toString())),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      height: 30.0,
                      child: Center(child: Text(user['paid_by'].toString())),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      height: 30.0,
                      child: Center(child: Text(user['advance_amount'].toString())),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      height: 30.0,
                      child: Center(child: Text(user['balance_amount'].toString())),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      height: 30.0,
                      child: Center(child: Text(user['total_amount'].toString())),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      height: 30.0,
                      child: Center(child: Text(user['remarks'].toString())),
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    ),
    );
  }
}

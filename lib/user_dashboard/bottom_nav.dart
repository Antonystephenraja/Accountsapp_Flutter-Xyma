import 'dart:convert';
import 'package:account_app/main.dart';
import 'package:account_app/user_dashboard/userupload.dart';
import 'package:account_app/user_dashboard/view_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;



class UserDashboard extends StatefulWidget {
  final String email;
  UserDashboard({required this.email});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}
class _UserDashboardState extends State<UserDashboard> {
  int _currentIndex = 0;
  late List<Widget> _pages;



  @override
  void initState() {
    super.initState();
    _pages = [
      Screen1(Email:widget.email),
      Screen2(email: widget.email,),
      //Screen2(rows: rows, email: widget.email),
      Screen3(userEmail: widget.email),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 50,
        backgroundColor: Colors.white,
        color: Colors.orange,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.add_chart, size: 30),
          Icon(Icons.table_view, size: 30),
        ],
        onTap: (index) {
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Screen3(userEmail: widget.email)),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }
}
class Screen1 extends StatelessWidget {
  final String Email;
  Screen1({required this.Email});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return userupload(Email: Email);
                    }),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blueGrey),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.add_circled,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'UPLOAD',
                        textAlign: TextAlign.center,style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Container(
              width: 150,
              height: 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {

                      return ViewImage(email:Email,);
                    }),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blueGrey),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.photo_on_rectangle,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'INVOICE',
                        textAlign: TextAlign.center,style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class Screen2 extends StatefulWidget {
  final String email;
  Screen2({required this.email});
  @override
  _Screen2State createState() => _Screen2State();
}
class _Screen2State extends State<Screen2> {
  List<dynamic>? data;
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> deleteRecord(String id) async {
    String uri = "http://64.227.129.107/account_app/delete.php";
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: {
          "id": id,
        },
      );
      if (response.statusCode == 200) {
        print("Record deleted");
        setState(() {
          data!.removeWhere((item) => item['id'] == id);
        });
      } else {
        print("Failed to delete record");
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void>updateRecord(String id,String updateData)async{
    String uri="http:/64.227.129.107/accounts_app/sample.php";
    try{
      var response= await http.post(
        Uri.parse(uri),
        body: {
          "id":id,
          "upadteData":updateData,
        },
      );
      if(response.statusCode==200){
        print("Record update");
      }else{
        print("Failed to update record");
      }
    }catch(e){
      print(e);
    }
  }
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://64.227.129.107/account_app/getdata.php'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final filteredData = jsonData.where((item) => item['email'] == widget.email).toList();
        setState(() {
          data = filteredData;
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data != null
          ? ListView.builder(
        itemCount: data!.length,
        itemBuilder: (context, index) {
          final item = data![index];
          return Card(
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['invoice_no']),
                  Text(item['filename']),
                  Text(item['date']),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditScreen(data: item, updateRecord: updateRecord)));
                    },
                  ),
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
                                  // Delete the record
                                  String id = item['id'];
                                  deleteRecord(id);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


class EditScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(String, String) updateRecord;
  const EditScreen({required this.data, required this.updateRecord});
  @override
  _EditScreenState createState() => _EditScreenState();
}
class _EditScreenState extends State<EditScreen> {
  late TextEditingController idController;
  // late TextEditingController filenameController;
  // late TextEditingController invoiceNoController;
  late TextEditingController CompanyNameController;
  late TextEditingController invoice;
  late TextEditingController date;
  late TextEditingController uploadername;
  late TextEditingController advanceamount;
  late TextEditingController balanceamount;
  late TextEditingController totalamount;
  late TextEditingController remarks;
  late TextEditingController paidedby;
  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.data['id']);
    // filenameController = TextEditingController(text: widget.data['filename']);
    // invoiceNoController = TextEditingController(text: widget.data['invoice_no']);
    CompanyNameController = TextEditingController(text: widget.data['company_name']);
    invoice = TextEditingController(text: widget.data['invoice_no']);
    date = TextEditingController(text: widget.data['date']);
    uploadername = TextEditingController(text: widget.data['uploader_name']);
    advanceamount = TextEditingController(text: widget.data['advance_amount']);
    balanceamount = TextEditingController(text: widget.data['balance_amount']);
    totalamount = TextEditingController(text: widget.data['total_amount']);
    remarks = TextEditingController(text: widget.data['remarks']);
    paidedby = TextEditingController(text: widget.data['dropdownController']);
  }
  @override
  void dispose() {
     idController.dispose();
    // filenameController.dispose();
    // invoiceNoController.dispose();
    CompanyNameController.dispose();
    invoice.dispose();
    date.dispose();
    uploadername.dispose();
    advanceamount.dispose();
    balanceamount.dispose();
    totalamount.dispose();
    remarks.dispose();
    paidedby.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: CompanyNameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoice Number',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: invoice,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: date,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uploader Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: uploadername,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: uploadername,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Advance Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: advanceamount,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Balance Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: balanceamount,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: totalamount,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Padied By',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: paidedby,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remarks',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: remarks,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Update the record in the MySQL database
                   String id = idController.text;
                  // String updatedFilename = filenameController.text;
                  // String updatedInvoiceNo = invoiceNoController.text;
                  String updatedCompanyName = CompanyNameController.text;
                  String updatedInvoiceNo = invoice.text;
                  String updatedDate = date.text;
                  String updatedUploaderName = uploadername.text;
                  String updatedAdvanceAmount = advanceamount.text;
                  String updatedBalanceAmount = balanceamount.text;
                  String updatedTotalAmount = totalamount.text;
                  String updatedRemarks = remarks.text;
                  String updatedPaidedby = paidedby.text;

                  String uri = "http://64.227.129.107/account_app/sample.php";
                  try {
                    var response = await http.post(
                      Uri.parse(uri),
                      body: {
                         "id": id,
                        // "filename": updatedFilename,
                        "invoice_no": updatedInvoiceNo,
                        //"CompanyNameController": updatedCompanyName,
                        "company_name": updatedCompanyName,
                        "date": updatedDate,
                        "uploader_name": updatedUploaderName,
                        "advance_amount": updatedAdvanceAmount,
                        "balance_amount": updatedBalanceAmount,
                        "total_amount": updatedTotalAmount,
                        "remarks": updatedRemarks,
                        "dropdownController": updatedPaidedby,
                      },
                    );
                    if (response.statusCode == 200) {
                      // Successful update
                      print("Record updated");
                    } else {
                      // Failed to update
                      print("Failed to update record");
                    }
                  } catch (e) {
                    print(e);
                  }
                  Navigator.pop(context); // Go back to the previous screen
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Screen3 extends StatefulWidget {
  final String userEmail;

  Screen3({required this.userEmail});

  @override
  _Screen3State createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
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
      final filteredData = jsonData
          .where((user) => user['email'] == widget.userEmail)
          .toList();
      setState(() {
        _users = filteredData.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to fetch data from the server');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datas'),
        backgroundColor: Colors.orange,
        elevation: 0,
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
      endDrawer: Drawer(
        elevation: 16.0,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("user"),
              accountEmail: Text(widget.userEmail),),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Setting"),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Homepage();
                }));
              },
            )
          ],
        ),
      ),

      body: SingleChildScrollView(
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
                        height: 30.0,
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
                        child:
                        Center(child: Text(user['invoice_no'].toString())),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        height: 30.0,
                        child:
                        Center(child: Text(user['company_name'].toString())),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        height: 30.0,
                        child:
                        Center(child: Text(user['uploader_name'].toString())),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        height: 30.0,
                        child:
                        Center(child: Text(user['product_name'].toString())),
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
                        child: Center(
                            child: Text(user['advance_amount'].toString())),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        height: 30.0,
                        child: Center(
                            child: Text(user['balance_amount'].toString())),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        height: 30.0,
                        child: Center(
                            child: Text(user['total_amount'].toString())),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        height: 30.0,
                        child:
                        Center(child: Text(user['remarks'].toString())),
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



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditRecordScreen extends StatefulWidget {
  final dynamic record;

  EditRecordScreen({required this.record});

  @override
  _EditRecordScreenState createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  // Define TextEditingController for each form field
  TextEditingController product_name = TextEditingController();
  TextEditingController company_name = TextEditingController();
  TextEditingController invoice_no = TextEditingController();
  TextEditingController uploader_name = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController advance_amount = TextEditingController();
  TextEditingController balance_amount = TextEditingController();
  TextEditingController total_amount = TextEditingController();
  TextEditingController remarks = TextEditingController();
  TextEditingController dropdownController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill the form fields with the data from the record
    product_name.text = widget.record["product_name"];
    company_name.text = widget.record["company_name"];
    invoice_no.text = widget.record["invoice_no"];
    uploader_name.text = widget.record["uploader_name"];
    date.text = widget.record["date"];
    advance_amount.text = widget.record["advance_amount"];
    balance_amount.text = widget.record["balance_amount"];
    total_amount.text = widget.record["total_amount"];
    remarks.text = widget.record["remarks"];
    dropdownController.text = widget.record["dropdownController"];
  }

  @override
  void dispose() {
    // Clean up the text controllers
    product_name.dispose();
    company_name.dispose();
    invoice_no.dispose();
    uploader_name.dispose();
    date.dispose();
    advance_amount.dispose();
    balance_amount.dispose();
    total_amount.dispose();
    remarks.dispose();
    dropdownController.dispose();
    super.dispose();
  }

  void submitChanges() async {
    // Get the updated values from the form fields
    String updatedProductName = product_name.text;
    String updatedCompanyName = company_name.text;
    String updatedInvoiceNumber = invoice_no.text;
    String updatedUploaderName = uploader_name.text;
    String updatedDate = date.text;
    String updatedAdvanceAmount = advance_amount.text;
    String updatedBalanceAmount = balance_amount.text;
    String updatedTotalAmount = total_amount.text;
    String updatedRemarks = remarks.text;
    String updatedDropDown = dropdownController.text;

    Map<String, dynamic> updatedData = {
      "id": widget.record["id"], // Pass the ID of the record to update
      "product_name": updatedProductName,
      "company_name": updatedCompanyName,
      "invoice_no": updatedInvoiceNumber,
      "uploader_name": updatedUploaderName,
      "date": updatedDate,
      "advance_amount": updatedAdvanceAmount,
      "balance_amount": updatedBalanceAmount,
      "total_amount": updatedTotalAmount,
      "remarks": updatedRemarks,
      "dropdownController": updatedDropDown,
    };

    // Send the updated data to the server
    String uri = "http://64.227.129.107/account_app/update.php";
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: updatedData,
      );
      if (response.statusCode == 200) {
        // Successful update
        print("Record updated");
        // Navigate back to the previous screen
        Navigator.pop(context);
      } else {
        // Failed to update
        print("Failed to update record");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Record"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: company_name,
                decoration: InputDecoration(
                  labelText: "Company Name",
                  border: OutlineInputBorder(), // Add border here
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: invoice_no,
                decoration: InputDecoration(
                  labelText: "Invoice Number",
                  border: OutlineInputBorder(), // Add border here
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: uploader_name,
                decoration: InputDecoration(
                  labelText: "Uploader Name",
                  border: OutlineInputBorder(), // Add border here
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: product_name,
                decoration: InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(), // Add border here
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: date,
                decoration: InputDecoration(
                  labelText: "Date",
                  border: OutlineInputBorder(), // Add border here
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: dropdownController,
                decoration: InputDecoration(
                  labelText: "Paid By",
                  border: OutlineInputBorder(), // Add border here
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: advance_amount,
                decoration: InputDecoration(
                  labelText: "Advance Amount",
                  border: OutlineInputBorder(), // Add border here
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: balance_amount,
                decoration: InputDecoration(
                  labelText: "Balance Amount",
                  border: OutlineInputBorder(), // Add border here
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: total_amount,
                decoration: InputDecoration(
                  labelText: "Total Amount",
                  border: OutlineInputBorder(), // Add border here
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: remarks,
                decoration: InputDecoration(
                  labelText: "Remarks",
                  border: OutlineInputBorder(), // Add border here
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: submitChanges,
                child: Text("Save Changes",style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(200, 50)), // Set the button size here
                  backgroundColor: MaterialStateProperty.all(Colors.black), // Set the button color here
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

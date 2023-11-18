
import 'package:account_app/admin_dashboard/admin_dashboard.dart';
import 'package:account_app/user_dashboard/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
class adminupload extends StatefulWidget {
  final String Email; // Add email parameter
  adminupload({Key? key, required this.Email}) : super(key: key);
  String? invoice;

  @override
  State<adminupload> createState() => _page();
}

class _page extends State<adminupload> {
  final _formKey = GlobalKey<FormState>();
  String? companyname;
  String? invoice;
  String? uploadername;
  String? productname;
  String? dates;
  String? padiedby;
  String? totalamount;
  String? advanceamount;
  String? balanceamount;
  String? remark;
  TextEditingController company_name = TextEditingController();
  TextEditingController invoice_no = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController uploader_name = TextEditingController();
  TextEditingController product_name = TextEditingController();
  TextEditingController advance_amount = TextEditingController();
  TextEditingController balance_amount = TextEditingController();
  TextEditingController total_amount = TextEditingController();
  TextEditingController remarks = TextEditingController();
  TextEditingController controller = TextEditingController();
  String dropdownValue = 'Company Account';
  ValueNotifier<String> dropdownController = ValueNotifier<String>('Company Account');
  File? imageFile;
  File? file;
  ImagePicker image = ImagePicker();
  var url;
  // ...

  Future uploadImage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String base64Image = base64Encode(file!.readAsBytesSync());
    String email = widget.Email; // Fetch the email from the widget
    String companyName = company_name.text;
    String invoiceNumber = invoice_no.text;
    String Date = date.text;
    String uploaderName = uploader_name.text;
    String productName = product_name.text;
    String advanceAmount = advance_amount.text;
    String balanceAmount = balance_amount.text;
    String totalAmount = total_amount.text;
    String remark = remarks.text;
    String dropdown = dropdownController.value;

    var url = Uri.parse("http://64.227.129.107/account_app/upload_image.php");
    var response = await http.post(url, body: {
      "image": base64Image,
      "email": email,
      "company_name": companyName,
      "invoice_no": invoiceNumber,
      "date": Date,
      "uploader_name": uploaderName,
      "product_name": productName,
      "advance_amount": advanceAmount,
      "balance_amount": balanceAmount,
      "total_amount": totalAmount,
      "remarks": remark,
      "dropdownController": dropdown,
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Image uploaded successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return dashboard(email: widget.Email);
      }));
    } else {
      Fluttertoast.showToast(
        msg: "Image upload failed!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload',
          style: TextStyle(
            color: Colors.black, // Set the desired text color here
          ),
        ),
        backgroundColor: Colors.amberAccent,
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: BoxDecoration(
                color:Colors.amberAccent,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(400),
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                        height: 300,
                        width: 300,
                        child: file == null
                            ? IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            size: 90,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          onPressed: ()
                          async {
                            Map<Permission, PermissionStatus> statuses = await [
                              Permission.storage, Permission.camera,
                            ].request();
                            if(statuses[Permission.storage]!.isGranted && statuses[Permission.camera]!.isGranted){
                              showImagePicker(context);
                            } else {
                              print('no permission provided');
                            }
                          },
                        )
                            : MaterialButton(
                          height: 100,
                          child: Image.file(
                            file!,
                            fit: BoxFit.fill,
                          ),
                          onPressed: () {
                            getImage();
                          },
                        )
                    ),
                  ),SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 250,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        //controller: email,
                        enabled: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: widget.Email,// Fetch the email from widget
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      controller: company_name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an company name';
                        }
                        // You can add more email validation logic if needed
                        return null;
                      },
                      onSaved: (value) {
                        companyname = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Company Name',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      controller: invoice_no,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an invoice number';
                        }
                        // You can add more email validation logic if needed
                        return null;
                      },
                      onSaved: (value) {
                        invoice = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Invoice Number',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      controller: uploader_name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an uploader name';
                        }
                        // You can add more email validation logic if needed
                        return null;
                      },
                      onSaved: (value) {
                        uploadername = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Uploader Name',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      controller: product_name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an product name';
                        }
                        // You can add more email validation logic if needed
                        return null;
                      },
                      onSaved: (value) {
                        productname = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Product Name',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      controller: date,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please choose a date';
                        }
                        // You can add more email validation logic if needed
                        return null;
                      },
                      onSaved: (value) {
                        dates = value;
                      },
                      readOnly: true, // make the field read-only to prevent user input
                      onTap: () async {
                        final DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          date.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Select Date',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 320,
                    child: ValueListenableBuilder(

                      valueListenable: dropdownController,


                      builder: (BuildContext context, String? value, Widget? child) {
                        return DropdownButtonFormField<String>(
                          value: value,
                          onChanged: (String? newValue) {
                            dropdownController.value = newValue!;
                          },
                          items: <String>['Company Account', 'Personal Account']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            hintText: 'Select an option',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(width: 1.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      controller: total_amount,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an total amount';
                        }
                        // You can add more email validation logic if needed
                        return null;
                      },
                      onSaved: (value) {
                        totalamount = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Total Amount',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      controller: advance_amount,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an advance amount';
                        }
                        // You can add more email validation logic if needed
                        return null;
                      },
                      onSaved: (value) {
                        advanceamount = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Advance Amonut',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      controller: balance_amount,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an balance amount';
                        }
                        // You can add more email validation logic if needed
                        return null;
                      },
                      onSaved: (value) {
                        balanceamount = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Balance Amount',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      controller: remarks,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an remarks';
                        }
                        // You can add more email validation logic if needed
                        return null;
                      },
                      onSaved: (value) {
                        remark = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Remark',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 1.0),
                        ),
                      ),

                    ),

                  ),
                  SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    width: 250, // Add the desired width here
                    child: MaterialButton(
                      height: 50,
                      onPressed: uploadImage,
                      color: Colors.black,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        "Add",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),

                ],
              ),
            ),
            Container(

            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
    print(file);
  }
  final picker = ImagePicker();
  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                          child: Column(
                            children: const [
                              Icon(Icons.image, size: 60.0,),
                              SizedBox(height: 12.0),
                              Text(
                                "Gallery",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              )
                            ],
                          ),
                          onTap: () {
                            _imgFromGallery();
                            Navigator.pop(context);
                          },
                        )),
                    Expanded(
                        child: InkWell(
                          child: SizedBox(
                            child: Column(
                              children: const [
                                Icon(Icons.camera_alt, size: 60.0,),
                                SizedBox(height: 12.0),
                                Text(
                                  "Camera",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            _imgFromCamera();
                            Navigator.pop(context);
                          },
                        ))
                  ],
                )),
          );
        }
    );
  }
  _imgFromGallery()  async {

    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
    print(file);
  }
  _imgFromCamera() async {
    var img=await picker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      file =File(img!.path);
    });
    print(file);
  }
}
@override
Widget build(BuildContext context) {
  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
    ),
  );
}




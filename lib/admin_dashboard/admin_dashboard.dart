import 'dart:convert';
import 'dart:typed_data';
import 'package:account_app/admin_dashboard/adminupload.dart';
import 'package:account_app/admin_dashboard/revenue.dart';
import 'package:account_app/admin_dashboard/total_uploader.dart';
import 'package:account_app/admin_dashboard/view_image.dart';
import 'package:account_app/admin_dashboard/viewuser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class dashboard extends StatefulWidget {
  final String email;

  dashboard({Key? key, required this.email}) : super(key: key);

  @override
  State<dashboard> createState() => ReportPage();
}
class ReportPage extends State<dashboard> {
  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse("http://64.227.129.107/account_app/fetch.php"));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      return jsonData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch data from the server');
    }
  }
  Future<pw.Document> generatePdf() async {
    final data = await fetchData();
    final pdf = pw.Document();

    final chunkSize = 10; // Number of rows per page
    final totalChunks = (data.length / chunkSize).ceil();

    for (var chunkIndex = 0; chunkIndex < totalChunks; chunkIndex++) {
      final start = chunkIndex * chunkSize;
      final end = (start + chunkSize < data.length) ? start + chunkSize : data.length;
      final chunk = data.sublist(start, end);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Table.fromTextArray(
              data: [
                ['ID', 'company_name', 'invoice_no', 'email', 'date', 'uploader_name', 'product_name', 'advance_amount', 'balance_amount', 'total_amount', 'remarks', 'dropdownController'],
                ...chunk.map((row) => [
                  row['id'], row['company_name'], row['invoice_no'], row['email'], row['date'], row['uploader_name'], row['product_name'],
                  row['advance_amount'], row['balance_amount'], row['total_amount'], row['remarks'], row['dropdownController']
                ]),
              ],
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.centerLeft,
                5: pw.Alignment.centerLeft,
                6: pw.Alignment.centerLeft,
                8: pw.Alignment.centerLeft,
                9: pw.Alignment.centerLeft,
                10: pw.Alignment.centerLeft,
                11: pw.Alignment.centerLeft,
                12: pw.Alignment.centerLeft,
              },
            );
          },
        ),
      );
    }

    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color:Colors.orange,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(500),
              ),
            ),
            child: Column(
              children: [
                // Row(
                //   children: [
                //     SizedBox(height: 100),
                //     IconButton(
                //       onPressed: () {
                //         // Handle back button action here
                //       },
                //       icon: Icon(Icons.arrow_back, color: Colors.white), // Icon widget here
                //     ),
                //     Expanded(child: ListTile(
                //       contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                //       title: Text('Hello!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                //           color: Colors.white
                //       )),
                //     ))
                //   ],
                // ),
                const SizedBox(height: 50),
                Row(
                  children: [
                    SizedBox(height: 100),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white), // Icon widget here
                    ),
                    Expanded(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        title: Text('Hello!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white
                        )),
                        subtitle: Text('Welcome to Xyma', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white54
                        )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Container(
            color: Colors.orange,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(200)
                  )
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  itemDashboard6('Upload', CupertinoIcons.add_circled, Colors.teal),
                  itemDashboard2('List', CupertinoIcons.list_dash, Colors.green),
                  itemDashboard3('View', CupertinoIcons.sort_down_circle, Colors.purple),
                  itemDashboard1('Invoice', CupertinoIcons.photo_on_rectangle, Colors.deepOrange),
                  itemDashboard5('Total Cost', CupertinoIcons.money_dollar_circle, Colors.indigo),
                  itemDashboard4('PDF', CupertinoIcons.arrow_down_doc, Colors.brown),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
  itemDashboard1(String title, IconData iconData, Color background) => GestureDetector(
    onTap: () {
      // // Navigate to a new page
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return ViewImage1();
      }));
    },
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context).primaryColor.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white)
          ),
          const SizedBox(height: 8),
          Text(title.toUpperCase(), style: Theme.of(context).textTheme.titleMedium)
        ],
      ),
    ),
  );
  itemDashboard2(String title, IconData iconData, Color background) => GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return ViewData();
      }));

    },
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context).primaryColor.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white)
          ),
          const SizedBox(height: 8),
          Text(title.toUpperCase(), style: Theme.of(context).textTheme.titleMedium)
        ],
      ),
    ),
  );
  itemDashboard3(String title, IconData iconData, Color background) => GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return TableView();
      }));
    },
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context).primaryColor.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white)
          ),
          const SizedBox(height: 8),
          Text(title.toUpperCase(), style: Theme.of(context).textTheme.titleMedium)
        ],
      ),
    ),
  );
  itemDashboard4(String title, IconData iconData, Color background) => GestureDetector(
    onTap: ()async{
      final pdf = await generatePdf();
      Printing.layoutPdf(onLayout: (_) => pdf.save());
    } ,
    child: Container(
      height: 350,
      width: 340,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Theme.of(context).primaryColor.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(title.toUpperCase(), style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    ),
  );



  itemDashboard5(String title, IconData iconData, Color background) => GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return total_revenue();
      }));

    },
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context).primaryColor.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white)
          ),
          const SizedBox(height: 8),
          Text(title.toUpperCase(), style: Theme.of(context).textTheme.titleMedium)
        ],
      ),
    ),
  );
  itemDashboard6(String title, IconData iconData, Color background) => GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return adminupload(Email: widget.email);
      }));
    },
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context).primaryColor.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white)
          ),
          const SizedBox(height: 8),
          Text(title.toUpperCase(), style: Theme.of(context).textTheme.titleMedium)
        ],
      ),
    ),
  );

}



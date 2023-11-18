import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<List<Map<String, dynamic>>> fetchDataFromDatabase() async {
  final response = await http.get(Uri.parse('http://64.227.129.107/account_app/pdf.php'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body) as List<dynamic>;
    return jsonData.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to fetch data from the server');
  }
}

class ss extends StatelessWidget {
  Future<Uint8List> generateDocument() async {
    final data = await fetchDataFromDatabase();
    final pdf = pw.Document();

    // Load the logo image
    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/xyma.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Image(logoImage,width: 200,height: 200),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FixedColumnWidth(50),

                  12: pw.FixedColumnWidth(10),
                  // Add more column widths as per your requirements
                },
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey,
                    ),
                    children: [
                      pw.Text('Id', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Invoice Number', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Company Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Uploader Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Product Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Paid By', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Total Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Advance Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Balance Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Remarks', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Images', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      // Add more TableCell widgets for additional columns
                    ],
                  ),
                  for (var row in data)
                    pw.TableRow(
                      children: [
                        pw.Text(row['id'].toString()),
                        pw.Text(row['date'].toString()),
                        pw.Text(row['invoice_no'].toString()),
                        pw.Text(row['company_name'].toString()),
                        pw.Text(row['uploader_name'].toString()),
                        pw.Text(row['product_name'].toString()),
                        pw.Text(row['dropdownController'].toString()),
                        pw.Text(row['total_amount'].toString()),
                        pw.Text(row['advance_amount'].toString()),
                        pw.Text(row['balance_amount'].toString()),
                        pw.Text(row['remarks'].toString()),
                        pw.Text(row['filename'].toString()),
                        // Add more TableCell widgets for additional columns
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> printPdf(BuildContext context) async {
    final pdfBytes = await generateDocument();
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate PDF'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => printPdf(context), // Pass the context here
          child: Text('Generate PDF'),
        ),
      ),
    );
  }
}



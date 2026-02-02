import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/property.dart';

class InvoiceService {
  static Future<void> generateAndPrintInvoice({
    required Property property,
    required String guestName,
    required String guestEmail,
    required int numberOfGuests,
    required DateTime startDate,
    required DateTime endDate,
    required double totalPrice,
  }) async {
    final doc = pw.Document();

    final image = await imageFromAssetBundle(property.images.first);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(
                      children: [
                        pw.Container(
                          width: 60,
                          height: 60,
                          child: pw.ClipRRect(
                            horizontalRadius: 8,
                            verticalRadius: 8,
                            child: pw.Image(image, fit: pw.BoxFit.cover),
                          ),
                        ),
                        pw.SizedBox(width: 15),
                        pw.Text('Urbino Student Housing', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    pw.Text('INVOICE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.grey)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Billed To:'),
                      pw.Text(guestName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(guestEmail),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Invoice Date: ${DateTime.now().toString().split(' ')[0]}'),
                      pw.Text('Property Ref: ${property.id}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Text('Reservation Details', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              pw.SizedBox(height: 10),
              _buildRow('Property', property.title),
              _buildRow('Location', property.location),
              _buildRow('Check-in', '${startDate.day}/${startDate.month}/${startDate.year}'),
              _buildRow('Check-out', '${endDate.day}/${endDate.month}/${endDate.year}'),
              _buildRow('Guests', numberOfGuests.toString()),
              _buildRow('Duration', '${endDate.difference(startDate).inDays} nights'),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Total Amount: ', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Text('€${totalPrice.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue)),
                ],
              ),
              pw.Spacer(),
              pw.Center(child: pw.Text('Thank you for choosing Urbino Student Housing!', style: const pw.TextStyle(color: PdfColors.grey))),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Invoice_${property.id}_$guestName.pdf',
    );
  }

  static pw.Widget _buildRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(color: PdfColors.grey700)),
          pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}

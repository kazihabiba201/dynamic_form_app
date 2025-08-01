import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/models/form_model.dart';
import '../utils/app_string.dart';

class FileExportService {

  //SaveAsTXT
  static Future<void> saveAsTXT(Map<String, dynamic> data, String formName, BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${formName.replaceAll(" ", "_")}_${DateTime.now().millisecondsSinceEpoch}.txt';
      final file = File(path);
      await file.writeAsString(jsonEncode(data));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppStrings.showSuccessSnackBar}. \n$path')));
      await OpenFilex.open(path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppStrings.showErrorSnackBar} $e')));
    }
  }




  //SaveAsPDF
  static Future<void> saveAsPdfAndOpen(Map<String, dynamic> data, String formName, BuildContext context, FormModel form) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          List<pw.Widget> widgets = [];

          widgets.add(pw.Header(level: 0, child: pw.Text(formName, style: pw.TextStyle(fontSize: 24))));

          for (final key in data.keys) {
            final value = data[key];
            final field = form.sections.expand((section) => section.fields).firstWhere((f) => f.key == key);

            if (field == null) continue;

            // Handle dropdown/checkbox list (id == 2)
            if (field.id == 2) {
              final List items = jsonDecode(field.properties['listItems'] ?? '[]');

              if (value is List) {
                final displayNames = value.map((val) {
                  final match = items.firstWhere((item) => item['value'].toString() == val.toString(), orElse: () => null);
                  return match?['name'] ?? val.toString();
                }).toList();

                widgets.add(
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('$key:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Bullet(text: displayNames.join(', ')),
                      pw.SizedBox(height: 10),
                    ],
                  ),
                );
              } else {
                final match = items.firstWhere((item) => item['value'].toString() == value.toString(), orElse: () => null);
                final name = match?['name'] ?? value.toString();

                widgets.add(
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('$key:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(name),
                      pw.SizedBox(height: 10),
                    ],
                  ),
                );
              }
            }
            // Handle single image
            else if (value is String && File(value).existsSync()) {
              final image = pw.MemoryImage(File(value).readAsBytesSync());
              widgets.add(
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('$key:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 5),
                    pw.Image(image, height: 150),
                    pw.SizedBox(height: 10),
                  ],
                ),
              );
            }
            // Handle multiple images
            else if (value is List && value.isNotEmpty && value.first is String && File(value.first).existsSync()) {
              widgets.add(
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('$key:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 5),
                    ...value.map((path) {
                      if (File(path).existsSync()) {
                        final img = pw.MemoryImage(File(path).readAsBytesSync());
                        return pw.Padding(padding: const pw.EdgeInsets.only(bottom: 10), child: pw.Image(img, height: 150));
                      } else {
                        return pw.Text('$AppStrings.showImageError $path');
                      }
                    }).toList(),
                    pw.SizedBox(height: 10),
                  ],
                ),
              );
            }
            // Fallback: normal text
            else {
              widgets.add(
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('$key:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(value?.toString() ?? ''),
                    pw.SizedBox(height: 10),
                  ],
                ),
              );
            }
          }

          return widgets;
        },
      ),
    );

    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/${formName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File(filePath);

      await file.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$AppStrings.showSavePDFToast \n$filePath')));
      await OpenFilex.open(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$AppStrings.showSavePDFToast $e')));
    }
  }
}

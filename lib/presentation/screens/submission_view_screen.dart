import 'dart:convert';

import 'package:dynamic_form_app/core/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/file_export_service.dart';
import '../providers/form_provider.dart';

class SubmissionViewScreen extends StatelessWidget {
  const SubmissionViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FormProvider>(context);
    final responses = provider.formResponses;
    final formName = provider.selectedForm?.formName ?? "submission";

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            AppStrings.submissionPreviewTitle,
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: responses.length,
        itemBuilder: (context, index) {
          final key = responses.keys.elementAt(index);
          final value = responses[key];
          String displayValue = '';

          final form = provider.selectedForm;
          if (form != null) {
            for (var section in form.sections) {
              for (var field in section.fields) {
                if (field.key == key) {
                  if (field.id == 2) {
                    // Dropdown or checkbox list
                    final List items = jsonDecode(field.properties['listItems']);
                    if (value is List) {
                      // Multi-select: map values to names
                      List<String> selectedNames = [];
                      for (var val in value) {
                        final match = items.firstWhere((item) => item['value'].toString() == val.toString(), orElse: () => null);
                        if (match != null) selectedNames.add(match['name']);
                      }
                      displayValue = selectedNames.join(', ');
                    } else {
                      // Single select: find name by value
                      final match = items.firstWhere((item) => item['value'].toString() == value.toString(), orElse: () => null);
                      displayValue = match != null ? match['name'] : value.toString();
                    }
                  } else {
                    displayValue = value.toString();
                  }
                  break;
                }
              }
            }
          }

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.label_important, color: Colors.green),
                title: Text(
                  '$key:',
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.green),
                ),
                subtitle: Text(displayValue, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 10),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.green),
                label: Text(AppStrings.saveTXT, style: TextStyle(color: Colors.green)),
                onPressed: () => FileExportService.saveAsTXT(responses, formName, context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.green, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                label: const Text(AppStrings.savePDF, style: TextStyle(color: Colors.white)),
                onPressed: () => FileExportService.saveAsPdfAndOpen(responses, formName, context, provider.selectedForm!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

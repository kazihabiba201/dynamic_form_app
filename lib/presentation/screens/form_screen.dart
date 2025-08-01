import 'package:dynamic_form_app/core/utils/app_string.dart';
import 'package:dynamic_form_app/presentation/widgets/field_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/routes/routes.dart';
import '../providers/form_provider.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  bool _validateFields(BuildContext context, FormProvider provider) {
    final form = provider.selectedForm!;
    final responses = provider.formResponses;

    for (var section in form.sections) {
      for (var field in section.fields) {
        final props = field.properties;
        final key = field.key;
        final value = responses[key];

        if (field.id == 1) {
          // Text validation
          final min = props['minLength'] ?? 0;
          final max = props['maxLength'] ?? 1000;
          if (value == null || value.toString().trim().length < min) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${props['label']} {$AppStrings.leastNumberWarning} $min {$AppStrings.characters}')),
            );
            return false;
          }
          if (value.toString().length > max) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${props['label']} {$AppStrings.lessNumberWarning} $max {$AppStrings.characters}')),
            );
            return false;
          }
        } else if (field.id == 2 && props['multiSelect'] == false) {
          if (value == null || value.toString().isEmpty) return false;
        } else if (field.id == 3) {
          if (value == null || value.toString().isEmpty) return false;
        } else if (field.id == 4) {
          // Image field: optional for Form ID 1 and Form ID 3
          final isOptional = (form.id == 1 || form.id == 3);
          if (!isOptional && (value == null || value.toString().isEmpty)) {
            return false;
          }


        }
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FormProvider>(context);
    final form = provider.selectedForm;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          form!.formName,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            context.goNamed(RouteName.formList);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: form.sections.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, sectionIndex) {
          final section = form.sections[sectionIndex];
          return Card(
            color: Colors.white,

            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(section.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  ...section.fields.map((field) => FieldWidgets(field: field)).toList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () {
            if (_validateFields(context,provider)) {
              context.goNamed(RouteName.formSubmission);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.pleaseCompleteAllFieldsProperlySnackBarText)));
            }
          },
          child: const Text(
            AppStrings.submitBtn,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

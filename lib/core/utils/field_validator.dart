import 'package:flutter/material.dart';

import '../../presentation/providers/form_provider.dart';
import 'app_string.dart';

class FieldValidator {
  static bool validateFields(BuildContext context, FormProvider provider) {
    final form = provider.selectedForm!;
    final responses = provider.formResponses;

    for (var section in form.sections) {
      for (var field in section.fields) {
        final props = field.properties;
        final key = field.key;
        final value = responses[key];

        if (field.id == 1 ) {
          // Text field
          final min = props['minLength'] ?? 0;
          final max = props['maxLength'] ?? 1000;

          // Check if this is the allergy detail field (text_3 and Form ID 3)
          if (key == 'text_3' && form.id == 3) {
            final allergyAnswer = responses['yesno_1'];
            final isRequired = allergyAnswer == 'Yes';

            if (isRequired && (value == null || value.toString().trim().isEmpty)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.pleaseSpecifyYourAllergyWarning)),
              );
              return false;
            }
          } else {
            if (value == null || value.toString().trim().length < min) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${props['label']} ${AppStrings.leastNumberWarning} $min ${AppStrings.characters}')),
              );
              return false;
            }
            if (value.toString().length > max) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${props['label']} ${AppStrings.mostNumberWarning} $max ${AppStrings.characters}')),
              );
              return false;
            }
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
}

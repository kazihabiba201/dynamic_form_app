import 'package:dynamic_form_app/core/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/routes/routes.dart';
import '../providers/form_provider.dart';

class FormListScreen extends StatelessWidget {
  const FormListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FormProvider>(context);
    final forms = provider.formList;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            AppStrings.formListTitle,
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: forms.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: forms.length,
              itemBuilder: (context, index) {
                final form = forms[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    title: Text(form.formName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    leading: Icon(Icons.library_books_sharp, color: Colors.green),
                    subtitle: Text(AppStrings.formListSubTitle, style: TextStyle(color: Colors.grey[600])),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      provider.selectForm(form);
                      context.goNamed(RouteName.fORM);
                    },
                  ),
                );
              },
            ),
    );
  }
}

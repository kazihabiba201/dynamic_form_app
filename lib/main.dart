import 'package:dynamic_form_app/core/utils/app_string.dart';
import 'package:dynamic_form_app/presentation/providers/form_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes/route_paths.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FormProvider()..loadForms(),
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}

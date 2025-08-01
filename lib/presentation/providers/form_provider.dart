import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/models/form_model.dart';

class FormProvider with ChangeNotifier {
  List<FormModel> _formList = [];
  FormModel? _selectedForm;
  Map<String, dynamic> _formResponses = {}; // user responses by key

  List<FormModel> get formList => _formList;
  FormModel? get selectedForm => _selectedForm;
  Map<String, dynamic> get formResponses => _formResponses;

  Future<void> loadForms() async {
    final jsonList = await Future.wait([
      rootBundle.loadString('assets/forms/form_1.json'),
      rootBundle.loadString('assets/forms/form_2.json'),
      rootBundle.loadString('assets/forms/form_3.json'),
    ]);

    _formList = jsonList.map((json) => FormModel.fromJson(jsonDecode(json))).toList();
    notifyListeners();
  }

  void selectForm(FormModel form) {
    _selectedForm = form;
    _formResponses = {};
    notifyListeners();
  }

  void updateResponse(String fieldKey, dynamic value) {
    _formResponses[fieldKey] = value;
    notifyListeners();
  }

  void clearSelection() {
    _selectedForm = null;
    _formResponses = {};
    notifyListeners();
  }
}

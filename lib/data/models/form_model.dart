import 'dart:convert';

class FormModel {
  final String formName;
  final int id;
  final List<SectionModel> sections;

  FormModel({
    required this.formName,
    required this.id,
    required this.sections,
  });

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      formName: json['formName'],
      id: json['id'],
      sections: (json['sections'] as List)
          .map((e) => SectionModel.fromJson(e))
          .toList(),
    );
  }
}

class SectionModel {
  final String name;
  final String key;
  final List<FieldModel> fields;

  SectionModel({
    required this.name,
    required this.key,
    required this.fields,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      name: json['name'],
      key: json['key'],
      fields: (json['fields'] as List)
          .map((e) => FieldModel.fromJson(e))
          .toList(),
    );
  }
}

class FieldModel {
  final int id;
  final String key;
  final Map<String, dynamic> properties;

  FieldModel({
    required this.id,
    required this.key,
    required this.properties,
  });

  factory FieldModel.fromJson(Map<String, dynamic> json) {
    return FieldModel(
      id: json['id'],
      key: json['key'],
      properties: Map<String, dynamic>.from(json['properties']),
    );
  }
}

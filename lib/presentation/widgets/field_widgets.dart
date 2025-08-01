import 'dart:convert';
import 'dart:io';

import 'package:dynamic_form_app/core/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../data/models/form_model.dart';
import '../providers/form_provider.dart';

class FieldWidgets extends StatelessWidget {
  final FieldModel field;

  const FieldWidgets({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    final props = field.properties;
    final provider = Provider.of<FormProvider>(context);
    final fieldKey = field.key;

    switch (field.id) {
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(props['label'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: provider.formResponses[fieldKey] ?? '',
                decoration: InputDecoration(
                  hintText: props['hintText'],
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                ),
                onChanged: (val) => provider.updateResponse(fieldKey, val),
              ),
            ],
          ),
        );

      case 2:
        final List items = jsonDecode(props['listItems']);
        final isMulti = props['multiSelect'] ?? false;

        if (isMulti) {
          List selected = provider.formResponses[fieldKey] ?? [];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(props['label'], style: const TextStyle(fontWeight: FontWeight.bold)),
                ...items.map<Widget>((item) {
                  return CheckboxListTile(
                    value: selected.contains(item['value']),
                    title: Text(item['name']),
                    onChanged: (val) {
                      if (val == true) {
                        selected.add(item['value']);
                      } else {
                        selected.remove(item['value']);
                      }
                      provider.updateResponse(fieldKey, List.from(selected));
                    },
                  );
                }).toList(),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: props['label'],
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
              value: provider.formResponses[fieldKey],
              icon: const Icon(Icons.arrow_drop_down),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              items: items.map<DropdownMenuItem>((item) {
                return DropdownMenuItem(value: item['value'], child: Text(item['name']));
              }).toList(),
              onChanged: (val) => provider.updateResponse(fieldKey, val),
            ),
          );
        }
      case 3:
        final value = provider.formResponses[fieldKey];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(props['label'], style: const TextStyle(fontWeight: FontWeight.bold)),
              Column(
                children: ['Yes', 'No', 'NA'].map((opt) {
                  return RadioListTile(title: Text(opt), value: opt, groupValue: value, onChanged: (val) => provider.updateResponse(fieldKey, val));
                }).toList(),
              ),
            ],
          ),
        );
      case 4:
        final picked = provider.formResponses[fieldKey];
        final isMulti = props['multiImage'] == true;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(props['label'], style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              ElevatedButton.icon(
                icon: const Icon(Icons.add_a_photo, color: Colors.black),
                label: Text(AppStrings.pickImage, style: const TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.green, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final List<String> currentImages = List<String>.from(picked ?? []);
                  final int remaining = 5 - currentImages.length;

                  if (remaining == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.showToastDoNotAllowMoreThanFiveImage)));
                    return;
                  }

                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text(AppStrings.cameraBtn),
                            onTap: () async {
                              Navigator.pop(ctx);
                              final XFile? image = await picker.pickImage(source: ImageSource.camera);
                              if (image != null) {
                                final paths = List<String>.from(picked ?? []);
                                if (paths.length >= 5) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.showToastDoNotAllowMoreThanFiveImage)));
                                  return;
                                }
                                paths.add(image.path);
                                provider.updateResponse(fieldKey, paths);
                              }
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text(AppStrings.galleryBtn),
                            onTap: () async {
                              Navigator.pop(ctx);
                              final List<XFile> images = await picker.pickMultiImage();
                              if (images.isNotEmpty) {
                                final paths = List<String>.from(picked ?? []);
                                final int remainingSlots = 5 - paths.length;
                                if (remainingSlots <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.showToastDoNotAllowMoreThanFiveImage)));
                                  return;
                                }

                                final newImages = images.take(remainingSlots).map((img) => img.path).toList();
                                paths.addAll(newImages);
                                provider.updateResponse(fieldKey, paths);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              if (picked != null)
                isMulti
                    ? Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List<Widget>.from(
                          (picked as List).map(
                            (imgPath) => Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(File(imgPath), height: 100, width: 100, fit: BoxFit.cover),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      List<String> updated = List<String>.from(picked)..remove(imgPath);
                                      provider.updateResponse(fieldKey, updated);
                                    },
                                    child: const CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(File(picked), height: 100, fit: BoxFit.cover),
                      ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

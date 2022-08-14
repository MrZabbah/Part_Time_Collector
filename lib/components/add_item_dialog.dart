import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../item.dart';

// ignore: must_be_immutable
class AddItemDialog extends AlertDialog {
  final List<Item?> items;
  final GlobalKey<FormState> formKey;
  final void Function(String itemName, String? trophiePath) onSaveItem;
  String itemName = '';
  String? trophiePath;

  AddItemDialog(
      {Key? key,
      required this.items,
      required this.formKey,
      required this.onSaveItem})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              validator: (value) => value != null && value.isEmpty
                  ? 'Item must have a name'
                  : null,
              onSaved: (value) => itemName = value!,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final picker = ImagePicker();
                  final pickedImage =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (pickedImage == null) return;

                  trophiePath = pickedImage.path;
                } on PlatformException catch (e) {
                  debugPrint('Failed to load image: $e');
                }
              },
              child: const Text('Pick image'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            final form = formKey.currentState!;
            if (form.validate()) {
              form.save();
              onSaveItem(itemName, trophiePath);
              Navigator.pop(context);
            }
          },
          child: const Text('SUBMIT'),
        ),
      ],
    );
  }
}

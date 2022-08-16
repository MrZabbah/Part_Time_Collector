import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class AddItemDialog extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final void Function(String itemName, String trophiePath)? onSaveItem;
  final void Function(String itemName, String trophiePath, int index)?
      onUpdateItem;
  String itemName = '';
  String trophiePath = '';
  int index = -1;
  AddItemDialog(
      {Key? key,
      required this.formKey,
      this.onSaveItem,
      this.onUpdateItem,
      this.itemName = '',
      this.trophiePath = '',
      this.index = -1})
      : super(
          key: key,
        );

  @override
  State<AddItemDialog> createState() => _AddItemDialogState(
      formKey: formKey,
      onSaveItem: onSaveItem,
      onUpdateItem: onUpdateItem,
      itemName: itemName,
      trophiePath: trophiePath,
      index: index);
}

class _AddItemDialogState extends State<AddItemDialog> {
  final GlobalKey<FormState> formKey;
  final void Function(String itemName, String trophiePath)? onSaveItem;
  final void Function(String itemName, String trophiePath, int index)?
      onUpdateItem;
  String itemName = '';
  String trophiePath = '';
  int index = -1;

  _AddItemDialogState(
      {required this.formKey,
      this.onSaveItem,
      this.onUpdateItem,
      this.itemName = '',
      this.trophiePath = '',
      this.index = -1})
      : super();

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
              initialValue: itemName,
              validator: (value) => value != null && value.isEmpty
                  ? 'Item must have a name'
                  : null,
              onSaved: (value) => itemName = value!,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                    setState(() {});
                  },
                  child: const Text('Pick image'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() {
                    trophiePath = '';
                  }),
                  child: const Text('Delete image'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(
                        1,
                        1,
                      ),
                      blurRadius: 5.0,
                    ),
                  ],
                  image: (trophiePath.isNotEmpty)
                      ? DecorationImage(
                          image: FileImage(
                            File(trophiePath),
                          ),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage('images/no_image.jpg'),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            )
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
              if (onSaveItem != null) {
                onSaveItem!(itemName, trophiePath);
              } else {
                onUpdateItem!(itemName, trophiePath, index);
              }
              Navigator.pop(context);
            }
          },
          child: const Text('SUBMIT'),
        ),
      ],
    );
  }
}

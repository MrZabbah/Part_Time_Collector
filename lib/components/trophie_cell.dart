import 'dart:io';

import 'package:flutter/material.dart';
import 'package:part_time_hero/item.dart';

class TrophieCell extends StatelessWidget {
  final int index;
  final List<Item?> items;
  const TrophieCell(
      {Key? key, required, required this.index, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          image:
              (index >= items.length || index < 0 || !items[index]!.isCompleted)
                  ? const DecorationImage(
                      image: AssetImage('images/locked_trophie.jpg'),
                    )
                  : (items[index]!.trophiePath.isEmpty)
                      ? DecorationImage(
                          image: AssetImage(
                              'images/trophies/trophie_${items[index]!.index + 1}.jpg'),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: FileImage(
                            File(items[index]!.trophiePath),
                          ),
                          fit: BoxFit.cover,
                        ),
        ),
      ),
    );
  }
}

import 'dart:collection';

import 'package:flutter/material.dart';

import '../horizontal_curvy_clipper.dart';
import '../item.dart';

class ItemCell extends StatelessWidget {
  final int index;
  final List<Item?> items;
  final void Function(int index) onUpdateCount;
  final void Function(int index) onDelete;
  const ItemCell(
      {Key? key,
      required this.index,
      required this.items,
      required this.onUpdateCount,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: InkWell(
          onLongPress: () {
            onUpdateCount(index);
          },
          onDoubleTap: () => onDelete(index),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Ink(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 26, 26, 26),
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                      ),
                      Text(
                        items[index]!.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              ClipPath(
                clipper: HorizontalCurvyClipper(),
                child: Container(
                  width: MediaQuery.of(context).size.width / 6,
                  decoration: const BoxDecoration(
                    //color: Color.fromARGB(255, 61, 62, 63),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 61, 62, 63),
                      Color.fromARGB(255, 110, 110, 110),
                    ], stops: [
                      0.6,
                      0.95
                    ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (6 * 6),
                    ),
                    Icon(
                      Icons.star,
                      color: (items[index]!.isCompleted)
                          ? const Color.fromARGB(255, 211, 163, 21)
                          : const Color.fromARGB(85, 0, 0, 0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

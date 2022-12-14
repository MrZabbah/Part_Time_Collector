import 'package:flutter/material.dart';

import '../horizontal_curvy_clipper.dart';
import '../item.dart';

class ItemCell extends StatelessWidget {
  final int index;
  final List<Item?> items;
  final void Function(int index) onUpdateCount;
  const ItemCell(
      {Key? key,
      required this.index,
      required this.items,
      required this.onUpdateCount})
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
                        width: MediaQuery.of(context).size.width / 5.5,
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
                  width: MediaQuery.of(context).size.width / 5.5,
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / (5.5 * 5.5),
                    ),
                    Icon(
                      Icons.star,
                      color: (items[index]!.isCompleted)
                          ? const Color.fromARGB(255, 211, 163, 21)
                          : const Color.fromARGB(85, 0, 0, 0),
                    ),
                    if (items[index]!.isCompleted)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 211, 163, 21),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Positioned(
                right: 5,
                bottom: 4,
                child: Icon(
                  Icons.slideshow_rounded,
                  color: Color.fromARGB(255, 143, 143, 143),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

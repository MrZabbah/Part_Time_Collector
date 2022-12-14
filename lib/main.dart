import 'dart:collection';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:part_time_hero/components/add_item_dialog.dart';
import 'package:part_time_hero/components/item_cell.dart';
import 'package:part_time_hero/components/trophie_cell.dart';
import 'package:part_time_hero/item.dart';
import 'package:part_time_hero/utils/items_database.dart';
import 'package:part_time_hero/utils/simple_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SimplePreferences.init();
  await ItemsDatabase.init();
  final l = await ItemsDatabase.items();
  debugPrint(l.toString());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RootPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  List<Item?> items = List.generate(25, (index) => null);
  List<int> itemsOnRoad = [];
  Queue<int> availablePositions = Queue<int>();
  int completedItemsCount = 0;

  @override
  void initState() {
    super.initState();
    completedItemsCount = SimplePreferences.getCompletedCount();
    availablePositions = SimplePreferences.getAvailable();
    _loadItems();
  }

  _loadItems() async {
    final itemList = await ItemsDatabase.items();
    setState(() {
      for (var element in itemList) {
        itemsOnRoad.add(element.index);
        items[element.index] = element;
      }
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final urlImage =
      'https://4.bp.blogspot.com/-sFiJklMll-M/W4u5WWmQvXI/AAAAAAAAARo/_v_GL40alTcTCvvya11BocrFEcgVrDH5wCLcBGAs/s1600/icon.png';

  _saveItem(String name, String trophiePath) async {
    debugPrint('Name: $name - Path: $trophiePath');
    int index = availablePositions.removeFirst();
    itemsOnRoad.add(index);
    Item item = Item(name, trophiePath, index);
    await ItemsDatabase.insertItem(item);
    await SimplePreferences.setAvailablePositions(availablePositions.toList());
    setState(() {
      items[index] = (item);
    });
  }

  _updateItem(String name, String trophiePath, int index) async {
    if (index < 0) return;
    Item item = Item(name, trophiePath, itemsOnRoad[index],
        items[itemsOnRoad[index]]!.isCompleted);
    setState(() {
      items[itemsOnRoad[index]] = item;
    });
    await ItemsDatabase.insertItem(item);
  }

  _deleteItem(int index) async {
    setState(() {
      completedItemsCount = (items[index]!.isCompleted)
          ? completedItemsCount - 1
          : completedItemsCount;
      items[index] = null;
      availablePositions.addFirst(index);
      itemsOnRoad.remove(index);
    });
    await SimplePreferences.setCompletedCount(completedItemsCount);
    await SimplePreferences.setAvailablePositions(availablePositions.toList());
    await ItemsDatabase.deleteItem(index);
  }

  _deleteAll() async {
    setState(() {
      completedItemsCount = 0;
      itemsOnRoad = [];
      items.clear();
      items = List.generate(25, (index) => null);
    });
    await SimplePreferences.clearPreferences();
    await ItemsDatabase.clearDatabase();
    availablePositions = SimplePreferences.getAvailable();
  }

  _updateCount(int index) async {
    setState(
      () {
        items[index]!.isCompleted = !items[index]!.isCompleted;
        items[index]!.isCompleted
            ? completedItemsCount++
            : completedItemsCount--;
      },
    );
    await ItemsDatabase.insertItem(items[index]!);
    await SimplePreferences.setCompletedCount(completedItemsCount);
  }

  @override
  Widget build(BuildContext context) {
    final isDialOpen = ValueNotifier(false);

    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
        }

        return !isDialOpen.value;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey,
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: const Color.fromARGB(255, 50, 66, 73),
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          spacing: 12,
          openCloseDial: isDialOpen,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add),
              label: 'Add',
              onTap: () {
                if (availablePositions.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "There is no more space",
                    toastLength: Toast.LENGTH_SHORT,
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    backgroundColor: const Color.fromARGB(255, 90, 90, 90),
                  );
                  return;
                }
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: ((context, setState) {
                        return AddItemDialog(
                          formKey: _formKey,
                          onSaveItem: _saveItem,
                        );
                      }),
                    );
                  },
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.info),
              label: 'Info',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return const AboutDialog(
                            applicationName: 'Part Time Collector',
                            applicationVersion: 'v0.1',
                            children: [
                              Text(
                                'This application is currently under development.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                              Divider(
                                height: 16,
                                color: Colors.transparent,
                              ),
                              Text(
                                'Part Time Collector allows you to generate a list with up to 25 achievement to fulfill.',
                                textAlign: TextAlign.justify,
                              ),
                              Divider(
                                height: 8,
                                color: Colors.transparent,
                              ),
                              Text(
                                'Each achievement has its own image (by default or chosen), which will occupy a place in the trophy cabinet.',
                                textAlign: TextAlign.justify,
                              ),
                              Divider(
                                height: 8,
                                color: Colors.transparent,
                              ),
                              Text(
                                'Sliding an achivement to the right will leave visible a menu of options to delete or modify it.',
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          );
                        },
                      );
                    });
              },
            ),
            SpeedDialChild(
                child: const Icon(Icons.delete_forever),
                label: 'Reset',
                onTap: () => _deleteAll()),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 26, 26, 26),
              child: Container(
                margin: MediaQuery.of(context).padding,
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.gamepad,
                      size: 12,
                      color: Colors.amber,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      '$completedItemsCount/${itemsOnRoad.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            ExpansionTile(
              title: const Text('Trophies'),
              trailing: const Icon(Icons.gamepad),
              textColor: Colors.black,
              iconColor: Colors.amber,
              initiallyExpanded: true,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 25,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5),
                  itemBuilder: (context, index) {
                    return TrophieCell(
                        index: items[index]?.index ?? -1, items: items);
                  },
                ),
              ],
            ),
            Expanded(
              child: itemsOnRoad.isEmpty
                  ? const Text('There is no goal. Please create one to start')
                  : ListView.builder(
                      cacheExtent: 0,
                      addAutomaticKeepAlives: true,
                      padding: EdgeInsets.zero,
                      itemCount: itemsOnRoad.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  _deleteItem(itemsOnRoad[index]);
                                },
                                icon: FontAwesomeIcons.trash,
                                backgroundColor:
                                    const Color.fromARGB(255, 156, 16, 6),
                                foregroundColor: Colors.white,
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: ((context, setState) {
                                          return AddItemDialog(
                                            formKey: _formKey,
                                            onUpdateItem: _updateItem,
                                            itemName:
                                                items[itemsOnRoad[index]]!.name,
                                            trophiePath:
                                                items[itemsOnRoad[index]]!
                                                    .trophiePath,
                                            index: index,
                                          );
                                        }),
                                      );
                                    },
                                  );
                                },
                                icon: FontAwesomeIcons.envelopeOpenText,
                                backgroundColor:
                                    const Color.fromARGB(255, 1, 109, 64),
                                foregroundColor: Colors.white,
                              ),
                              SlidableAction(
                                borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(24),
                                ),
                                onPressed: (context) {
                                  Fluttertoast.showToast(
                                    msg: "Not available yet",
                                    toastLength: Toast.LENGTH_SHORT,
                                    textColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontSize: 16,
                                    backgroundColor:
                                        const Color.fromARGB(255, 90, 90, 90),
                                  );
                                },
                                icon: FontAwesomeIcons.trophy,
                                backgroundColor:
                                    const Color.fromARGB(255, 5, 6, 70),
                                foregroundColor: Colors.white,
                              ),
                            ],
                          ),
                          child: ItemCell(
                            index: itemsOnRoad[index],
                            items: items,
                            onUpdateCount: _updateCount,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

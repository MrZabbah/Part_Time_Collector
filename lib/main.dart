import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:part_time_hero/components/add_item_dialog.dart';
import 'package:part_time_hero/components/item_cell.dart';
import 'package:part_time_hero/components/trophie_cell.dart';
import 'package:part_time_hero/item.dart';

void main() {
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
  Set<int> availablePositions = <int>{};
  int completedItemsCount = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final urlImage =
      'https://4.bp.blogspot.com/-sFiJklMll-M/W4u5WWmQvXI/AAAAAAAAARo/_v_GL40alTcTCvvya11BocrFEcgVrDH5wCLcBGAs/s1600/icon.png';

  _saveItem(String name, String? trophiePath) {
    debugPrint('Name: $name - Path: $trophiePath');
    int index = availablePositions.first;
    availablePositions.remove(index);
    itemsOnRoad.add(index);
    setState(() {
      items[index] = (Item(name, trophiePath, index));
    });
  }

  _deleteItem(int index) {
    setState(() {
      completedItemsCount = (items[index]!.isCompleted)
          ? completedItemsCount - 1
          : completedItemsCount;
      items[index] = null;
      availablePositions.add(index);
      itemsOnRoad.remove(index);
    });
  }

  _deleteAll() {
    setState(() {
      completedItemsCount = 0;
      itemsOnRoad = [];
      items.clear();
      items = List.generate(25, (index) => null);
      availablePositions.clear();
    });
  }

  _updateCount(int index) {
    setState(
      () {
        items[index]!.isCompleted = !items[index]!.isCompleted;
        items[index]!.isCompleted
            ? completedItemsCount++
            : completedItemsCount--;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDialOpen = ValueNotifier(false);

    if (availablePositions.isEmpty && itemsOnRoad.isEmpty) {
      List<int> trophieOrder = List.generate(25, (index) => index);
      trophieOrder.shuffle();
      availablePositions.addAll(trophieOrder);
    }

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
                          items: items,
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
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(24),
                                ),
                                onPressed: (context) {
                                  _deleteItem(itemsOnRoad[index]);
                                },
                                icon: Icons.delete,
                                label: 'Delete',
                                backgroundColor:
                                    const Color.fromARGB(255, 156, 16, 6),
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

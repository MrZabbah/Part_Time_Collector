import 'package:flutter/material.dart';
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
  List<Item> items = [Item('Red Dead Redemption 2', null)];
  int completedItemsCount = 0;
  String itemName = '';
  String? trophiePath;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final urlImage =
      'https://4.bp.blogspot.com/-sFiJklMll-M/W4u5WWmQvXI/AAAAAAAAARo/_v_GL40alTcTCvvya11BocrFEcgVrDH5wCLcBGAs/s1600/icon.png';

  _saveItem(String name, String? trophiePath) {
    debugPrint('Name: $name - Path: $trophiePath');
    setState(() {
      items.add(Item(name, trophiePath));
    });
  }

  _updateCount(int index) {
    setState(
      () {
        items[index].isCompleted = !items[index].isCompleted;
        items[index].isCompleted
            ? completedItemsCount++
            : completedItemsCount--;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
        backgroundColor: const Color.fromARGB(255, 50, 66, 73),
        child: const Icon(Icons.add),
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
                    '$completedItemsCount/${items.length}',
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
                  return TrophieCell(index: index, items: items);
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ItemCell(
                  index: index,
                  items: items,
                  onUpdateCount: _updateCount,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

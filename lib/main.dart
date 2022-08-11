import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:part_time_hero/horizontal_curvy_clipper.dart';
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
  List<Item> items = [Item('Red Dead Redemption 2')];
  int completedItemsCount = 0;
  String itemName = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final urlImage =
      'https://4.bp.blogspot.com/-sFiJklMll-M/W4u5WWmQvXI/AAAAAAAAARo/_v_GL40alTcTCvvya11BocrFEcgVrDH5wCLcBGAs/s1600/icon.png';

  _saveItem(String name) {
    setState(() {
      items.add(Item(name));
    });
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
                  return AlertDialog(
                    content: Form(
                      key: _formKey,
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
                              final picker = ImagePicker();
                              final pickedImage = await picker.pickImage(
                                  source: ImageSource.gallery);

                              if (pickedImage == null) return;

                              // if(isFile)
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
                          final form = _formKey.currentState!;
                          if (form.validate()) {
                            form.save();
                            _saveItem(itemName);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('SUBMIT'),
                      ),
                    ],
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
                      ),
                      child: Image.network(
                        urlImage,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onLongPress: () {
                      setState(
                        () {
                          items[index].isCompleted = !items[index].isCompleted;
                          items[index].isCompleted
                              ? completedItemsCount++
                              : completedItemsCount--;
                        },
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Ink(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 26, 26, 26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 6,
                                ),
                                Text(
                                  items[index].name,
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
                              gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 61, 62, 63),
                                    Color.fromARGB(255, 110, 110, 110),
                                  ],
                                  stops: [
                                    0.6,
                                    0.95
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter),
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
                                width:
                                    MediaQuery.of(context).size.width / (6 * 6),
                              ),
                              Icon(
                                Icons.star,
                                color: (items[index].isCompleted)
                                    ? const Color.fromARGB(255, 211, 163, 21)
                                    : const Color.fromARGB(85, 0, 0, 0),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

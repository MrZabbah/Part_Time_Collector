class Item {
  int index = -1;
  String name = '';
  String trophiePath = '';
  bool isCompleted = false;

  Item(this.name, this.trophiePath, this.index, [this.isCompleted = false]);
//index INTEGER PRIMARY KEY, name TEXT, trophie TEXT, iscompleted INTEGER
  Map<String, dynamic> toMap() {
    return {
      'id': index,
      'name': name,
      'trophie': trophiePath,
      'iscompleted': isCompleted,
    };
  }

  @override
  String toString() {
    return 'Item{index: $index, name: $name, trophiePath: $trophiePath, isCompleted: $isCompleted}';
  }
}

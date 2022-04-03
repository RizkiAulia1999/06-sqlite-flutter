class Item {
  late int _id;
  late String name;
  late int price;

  int get id => this._id;

  //Konstruktor Versi 1
  Item({required this.name, required this.price});

  //konstruktor versi 2 : konversi dari Map ke Item
  Item.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    name = map['name'];
    price = map['price'];
  }

  //Konversi dari Item ke Map
  Map<String, dynamic> toMap() {
    return {'id': _id, 'name': name, 'price': price};
  }
}

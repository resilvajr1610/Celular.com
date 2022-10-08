import '../Utils/export.dart';

class UpdatesModel{

  String _id;
  String _date;
  String _brand;
  String _part;
  String _price;
  String _quantity;
  String _type;
  String _item;
  String _store;
  String _supply;

  UpdatesModel();

  UpdatesModel.fromSnapshot(DocumentSnapshot snapshot):_item = snapshot['item'];

  UpdatesModel.createId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference brands = db.collection("historicoPrecos");
    this.id = brands.doc().id;
  }

  UpdatesModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.id;
    this.item = documentSnapshot["item"];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : this.id,
      "marca" : this.brand,
      "data" : this.date,
      "preco" : this.price,
      "peca" : this.part,
      "quantidade" : this.quantity,
      "tipo":this.type,
      "item":this.item,
      "store":this.store,
      "supply":this.supply,
    };
    return map;
  }

  String get item => _item;

  set item(String value) {
    _item = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get quantity => _quantity;

  set quantity(String value) {
    _quantity = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  String get part => _part;

  set part(String value) {
    _part = value;
  }

  String get brand => _brand;

  set brand(String value) {
    _brand = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }


  String get supply => _supply;

  set supply(String value) {
    _supply = value;
  }

  String get store => _store;

  set store(String value) {
    _store = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
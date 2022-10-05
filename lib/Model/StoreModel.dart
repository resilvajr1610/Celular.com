import '../Utils/export.dart';

class StoreModel{

  String _store;

  StoreModel();

  StoreModel.fromSnapshot(DocumentSnapshot snapshot):_store = snapshot['store'];

  StoreModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.store = documentSnapshot["store"];
  }

  String get store => _store;

  set store(String value) {
    _store = value;
  }
}
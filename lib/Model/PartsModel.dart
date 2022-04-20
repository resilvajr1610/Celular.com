import 'package:cloud_firestore/cloud_firestore.dart';
class PartsModel{

  String _id;
  String _item;

  PartsModel();

  PartsModel.fromSnapshot(DocumentSnapshot snapshot):_item = snapshot['item'];

  PartsModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.id;
    this.item = documentSnapshot["item"];
  }

  PartsModel.createId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference parts = db.collection("pecas");
    this.id = parts.doc().id;
  }

  String get item => _item;

  set item(String value) {
    _item = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
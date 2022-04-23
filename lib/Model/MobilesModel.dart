
import 'package:cloud_firestore/cloud_firestore.dart';

class MobilesModel{

  String _id;
  String _mobiles;
  String _brands;

  MobilesModel();

  MobilesModel.fromSnapshot(DocumentSnapshot snapshot):_mobiles = snapshot['item'];

  MobilesModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.id;
    this.mobiles = documentSnapshot["celular"];
  }

  MobilesModel.createId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference brands = db.collection("celulares");
    this.id = brands.doc().id;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : this.id,
      "celular" : this.mobiles,
      "marca" : this.brands,
    };
    return map;
  }

  String get brands => _brands;

  set brands(String value) {
    _brands = value;
  }

  String get mobiles => _mobiles;

  set mobiles(String value) {
    _mobiles = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
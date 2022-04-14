
import 'package:cloud_firestore/cloud_firestore.dart';

class BrandsModel{

  String _id;
  String _brands;

  BrandsModel();

  BrandsModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.id;
    this.brands = documentSnapshot["marca"];
  }

  BrandsModel.createId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference brands = db.collection("marcas");
    this.id = brands.doc().id;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : this.id,
      "marcas" : this.brands,
    };
    return map;
  }

  String get brands => _brands;

  set brands(String value) {
    _brands = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
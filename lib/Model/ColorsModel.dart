import '../Utils/export.dart';

class ColorsModel{

  String _id;
  String _color;

  ColorsModel();

  ColorsModel.fromSnapshot(DocumentSnapshot snapshot):_color = snapshot['cor'];

  ColorsModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.id;
    this.color = documentSnapshot["cor"];
  }

  ColorsModel.createId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference brands = db.collection("cores");
    this.id = brands.doc().id;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : this.id,
      "cor" : this.color,
    };
    return map;
  }

  String get color => _color;

  set color(String value) {
    _color = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
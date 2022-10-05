import '../Utils/export.dart';

class RefModel{

  String _ref;

  RefModel();

  RefModel.fromSnapshot(DocumentSnapshot snapshot):_ref = snapshot['ref'];

  RefModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.ref = documentSnapshot["ref"];
  }

  String get ref => _ref;

  set ref(String value) {
    _ref = value;
  }
}
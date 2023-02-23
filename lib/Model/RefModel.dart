import '../Utils/export.dart';

class RefModel{

  String _ref;
  String _model;
  String _brand;

  RefModel();

  RefModel.fromSnapshotRef(DocumentSnapshot snapshot):_ref = snapshot['ref'];
  RefModel.fromSnapshotModelo(DocumentSnapshot snapshot):_model = snapshot['modelo'];
  RefModel.fromSnapshotMarca(DocumentSnapshot snapshot):_brand = snapshot['marca'];

  RefModel.fromDocumentSnapshotRef(DocumentSnapshot documentSnapshot){
    this.ref = documentSnapshot["ref"];
  }
  RefModel.fromDocumentSnapshotModelo(DocumentSnapshot documentSnapshot){
    this.model = documentSnapshot["modelo"];
  }
  RefModel.fromDocumentSnapshotMarca(DocumentSnapshot documentSnapshot){
    this.brand = documentSnapshot["marca"];
  }

  String get ref => _ref;
  String get model => _model;
  String get brand => _brand;

  set ref(String value) {
    _ref = value;
  }
  set model(String value) {
    _model = value;
  }
  set brand(String value) {
    _brand = value;
  }
}
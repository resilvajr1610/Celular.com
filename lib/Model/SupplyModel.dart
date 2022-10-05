import '../Utils/export.dart';

class SupplyModel{

  String _supply;

  SupplyModel();

  SupplyModel.fromSnapshot(DocumentSnapshot snapshot):_supply = snapshot['supply'];

  SupplyModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.supply = documentSnapshot["supply"];
  }

  String get supply => _supply;

  set supply(String value) {
    _supply = value;
  }
}
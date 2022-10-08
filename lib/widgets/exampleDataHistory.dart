import '../Utils/export.dart';

class ExampleDataHistory extends StatelessWidget {

  final String date;
  final String quantity;
  final String price;
  final String brand;
  final String part;
  final String type;
  final String supply;

  ExampleDataHistory({
    @required this.date,
    @required this.quantity,
    @required this.price,
    @required this.brand,
    @required this.part,
    @required this.type,
    @required this.supply,
});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Data'),
              SizedBox(width: 10),
              Text(this.date,style: TextStyle(fontWeight: FontWeight.bold,color: PaletteColor.darkGrey))
            ],
          ),
          Row(
            children: [
              Text('Marca : '),
              Text(this.brand,style: TextStyle(fontWeight: FontWeight.bold,color: PaletteColor.darkGrey))
            ],
          ),
          Row(
            children: [
              Text('Peça : '),
              Text(this.part,style: TextStyle(fontWeight: FontWeight.bold,color: PaletteColor.darkGrey))
            ],
          ),
          supply==''?Container():Row(
            children: [
              Text('Tipo : '),
              Text(this.type,style: TextStyle(fontWeight: FontWeight.bold,color: PaletteColor.darkGrey))
            ],
          ),
          Row(
            children: [
              Text('Fornecedor : '),
              Text(this.supply,style: TextStyle(fontWeight: FontWeight.bold,color: PaletteColor.darkGrey))
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text('Quantidade'),
              SizedBox(width: 10),
              Text(this.quantity,style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Text(this.type=="entrada"?"Preço Venda":"Preço Compra"),
              SizedBox(width: 10),
              Text('R\$ '+this.price,style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ],
      ),
    );
  }
}

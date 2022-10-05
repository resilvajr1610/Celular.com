import '../Utils/export.dart';

class InputSearch extends StatelessWidget {

  final TextEditingController controller;

  InputSearch({
    @required this.controller
});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.bottomLeft,
      height: 35,
      width: width*0.75,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
      decoration: BoxDecoration(
        color: PaletteColor.lightGrey,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            offset: Offset(0, -2), // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        controller: this.controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.text,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(Icons.search,color: PaletteColor.darkGrey,size: 20),
            hintText: "Pesquisar",
            hintStyle: TextStyle(
              color: PaletteColor.darkGrey,
              fontSize: 20,
            )
        ),
      ),
    );
  }
}

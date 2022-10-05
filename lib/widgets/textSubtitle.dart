import '../Utils/export.dart';

class TextSubtitle extends StatelessWidget {

  final String text;

  TextSubtitle({
    @required this.text
});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: Text(this.text,
        style: TextStyle(fontSize: 14,color: PaletteColor.darkGrey),),
    );
  }
}

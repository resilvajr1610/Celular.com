import '../Model/export.dart';

class TextTitle extends StatelessWidget {

  final String text;
  final double fonts;

  TextTitle({
    @required this.text,
    @required this.fonts,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
      child: Text(this.text,
        style: TextStyle(fontSize: this.fonts,color: PaletteColor.darkGrey),),
    );
  }
}

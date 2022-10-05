import '../Utils/export.dart';

class ButtonsEnterScreens extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

  ButtonsEnterScreens({
    @required this.text,
    @required this.onPressed
  });

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        color:PaletteColor.lightGrey,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: width,
          child: TextButton(
            child: Text(this.text,
                style: TextStyle(
                  fontSize: 20,
                  color: PaletteColor.darkGrey,
                  fontWeight: FontWeight.w400,
                )),
            style: TextButton.styleFrom(
            ),
            onPressed: this.onPressed,
          ),
        ),
      ),
    );
  }
}

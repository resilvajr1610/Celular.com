import '../Utils/export.dart';

class ButtonsRegister extends StatelessWidget {

  final VoidCallback onTap;
  final String text;
  final Color color;
  final double width;

  ButtonsRegister({
    @required this.onTap,
    @required this.text,
    @required this.color,
    this.width = 100
});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: this.onTap,
        child: Container(
            width: width,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: this.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(this.text, style: TextStyle(color: Colors.white),)
        )
    );
  }
}

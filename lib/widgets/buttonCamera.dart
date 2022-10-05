import '../Utils/export.dart';

class ButtonCamera extends StatelessWidget {

  final VoidCallback onTap;
  final double width;

  ButtonCamera({
    @required this.onTap,
    @required this.width
});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        width: this.width,
        height: this.width,
        child: Icon(Icons.add_a_photo,color: PaletteColor.darkGrey,size: 30),
        decoration: BoxDecoration(
          color: PaletteColor.lightGrey,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

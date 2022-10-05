import '../Utils/export.dart';

class ButtonsAdd extends StatelessWidget {

  final VoidCallback onPressed;

  ButtonsAdd({
    @required this.onPressed
});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: this.onPressed,
        alignment: Alignment.center,
        icon: Icon(Icons.add_circle,
            color: PaletteColor.blueButton,
            size: 40
        )
    );
  }
}

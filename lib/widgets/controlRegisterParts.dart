import '../Utils/export.dart';

class ControlRegisterParts extends StatelessWidget {

  final VoidCallback onPressedBack;
  final VoidCallback onPressedForward;
  final VoidCallback onTapRegister;

  ControlRegisterParts({
    @required this.onPressedBack,
    @required this.onPressedForward,
    @required this.onTapRegister
});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            color: PaletteColor.blueButton,
            onPressed:this.onPressedBack,
            icon: Icon(Icons.arrow_back_ios)
        ),
        ButtonsRegister(
            text: "Salvar",
            color: PaletteColor.green,
            onTap:this.onTapRegister
        ),
        IconButton(
            color: PaletteColor.blueButton,
            onPressed:this.onPressedForward,
            icon: Icon(Icons.arrow_forward_ios)
        ),
      ],
    );
  }
}

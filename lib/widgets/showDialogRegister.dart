import 'package:flutter/material.dart';
import '../Model/export.dart';
import 'buttonsRegister.dart';
import 'inputRegister.dart';

class ShowDialogRegister extends StatelessWidget {

  final TextEditingController controllerRegister = TextEditingController();
  final String title;
  final String hint;
  final List<Widget> list;

  ShowDialogRegister({
    @required this.title,
    @required this.list,
    @required this.hint,
});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(this.title)),
      titleTextStyle: TextStyle(color: PaletteColor.darkGrey,fontSize: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InputRegister(controller: controllerRegister, hint: this.hint,fonts: 20)
        ],
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      actions: this.list,
    );
  }
}

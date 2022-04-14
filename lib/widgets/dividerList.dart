import 'package:flutter/material.dart';
import '../Model/export.dart';

class DividerList extends StatelessWidget {
  const DividerList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
        color: PaletteColor.divider,
        thickness: 1,
        indent: 10,
        endIndent: 10
    );
  }
}

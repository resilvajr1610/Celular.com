import 'package:celular/widgets/dropDownItens.dart';
import 'package:celular/widgets/textTitle.dart';
import 'package:flutter/material.dart';
import 'buttonCamera.dart';
import 'inputRegister.dart';

class GroupStock extends StatelessWidget {

  final TextEditingController controllerStock ;
  final TextEditingController controllerPricePuschace ;
  final TextEditingController controllerStockMin ;
  final TextEditingController controllerPriceSale;
  final TextEditingController controllerCod;
  final List<DropdownMenuItem<String>>listItensUp;
  final List<DropdownMenuItem<String>>listItensLow;
  final VoidCallback onTapCamera;
  final dynamic onChangedUp;
  final dynamic onChangedLow;
  final bool showStockmin;
  final bool showPrice;
  final bool showCamera;
  final bool showDropDownUp;
  final bool showDropDownLow;
  final bool showCod;
  final String titlePrice;
  final String title;
  final String subtitle;
  final String selectedUp;
  final String selectedLow;
  final double fontsTitle;
  final double fontsSubtitle;
  final double width;

  GroupStock({
    @required this.title,
    this.subtitle,
    @required this.fontsTitle,
    this.fontsSubtitle,
    @required this.width,
    this.controllerCod,
    @required this.controllerPricePuschace,
    @required this.controllerPriceSale,
    @required this.controllerStock,
    @required this.controllerStockMin,
    @required this.showDropDownUp,
    @required this.showDropDownLow,
    @required this.showCod,
    this.onTapCamera,
    this.listItensUp,
    this.listItensLow,
    this.onChangedUp,
    this.onChangedLow,
    this.selectedUp,
    this.selectedLow,
    @required this.showStockmin,
    @required this.showPrice,
    @required this.titlePrice,
    @required this.showCamera,
});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextTitle(text: this.title, fonts: fontsTitle),
        showDropDownUp? DropdownItens(
            width: this.width,
            //listItens: this.listItensUp,
            onChanged: this.onChangedUp,
            selected: this.selectedUp
        ):Container(),
        showDropDownLow?TextTitle(text: this.subtitle, fonts: fontsSubtitle):Container(),
        showDropDownLow? DropdownItens(
            width: this.width,
            //listItens: this.listItensLow,
            onChanged: this.onChangedLow,
            selected: this.selectedLow
        ):Container(),
        showCod?TextTitle(text: 'Código', fonts: fontsSubtitle):Container(),
        showCod? InputRegister(
          controller: this.controllerCod,
          hint: '0000000',
          width: width*0.5,
          fonts: 14,
        ):Container(),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextTitle(text: 'Estoque',fonts: 14),
                InputRegister(
                  controller: this.controllerStock,
                  hint: '01',
                  width: width*0.2,
                  fonts: 14,
                ),
                showPrice?TextTitle(text: 'Preço Compra',fonts: 14):Container(),
                showPrice?InputRegister(
                  controller: this.controllerPricePuschace,
                  hint: 'R\$ 00,00',
                  width: width*0.3,
                  fonts: 14,
                ):Container()
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                showStockmin? TextTitle(text: 'Estoque mínimo',fonts: 14):Container(),
                showStockmin? InputRegister(
                  controller: this.controllerStockMin,
                  hint: '01',
                  width: width*0.2,
                  fonts: 14,
                ):Container(),
                TextTitle(text: this.titlePrice,fonts: 14),
                InputRegister(
                  controller: this.controllerPriceSale,
                  hint: 'R\$ 00,00',
                  width: width*0.3,
                  fonts: 14,
                )
              ],
            ),
            showCamera? ButtonCamera(
                onTap: this.onTapCamera,
                width: width*0.2
            ):Container()
          ],
        ),
      ],
    );
  }
}

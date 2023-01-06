import '../Utils/export.dart';

class GroupStock extends StatelessWidget {

  final TextEditingController controllerStock ;
  final TextEditingController controllerPricePuschace ;
  final TextEditingController controllerStockMin ;
  final TextEditingController controllerPriceSale;
  final TextEditingController controllerCod;
  final Widget streamBuilderUp;
  final Widget streamBuilderLow;
  final VoidCallback onTapCamera;
  final VoidCallback onTapRegisterColor;
  final dynamic onChangedUp;
  final dynamic onChangedLow;
  final bool showStockmin;
  final bool showPrice;
  final bool showCamera;
  final bool showDropDownUp;
  final bool showDropDownLow;
  final bool showCod;
  final bool showDisplay;
  final bool sendPhoto;
  final bool sendData;
  final bool showStockAndPrice;
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
    this.onTapRegisterColor,
    @required this.controllerPricePuschace,
    @required this.controllerPriceSale,
    @required this.controllerStock,
    @required this.controllerStockMin,
    @required this.showDropDownUp,
    @required this.showDropDownLow,
    @required this.showCod,
    this.showStockAndPrice = false,
    this.onTapCamera,
    this.sendPhoto,
    this.sendData,
    this.streamBuilderUp,
    this.streamBuilderLow,
    this.onChangedUp,
    this.onChangedLow,
    this.selectedUp,
    this.selectedLow,
    @required this.showStockmin,
    @required this.showPrice,
    @required this.titlePrice,
    @required this.showCamera, this.showDisplay,
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
            streamBuilder: this.streamBuilderUp,
            onChanged: this.onChangedUp,
            selected: this.selectedUp
        ):Container(),
        showDropDownLow?TextTitle(text: this.subtitle, fonts: fontsSubtitle):Container(),
        showDropDownLow? DropdownItens(
            width: this.width,
            streamBuilder: this.streamBuilderLow,
            onChanged: this.onChangedLow,
            selected: this.selectedLow
        ):Container(),
        showCod?TextTitle(text: 'Código', fonts: fontsSubtitle):Container(),
        showCod? InputRegister(
          obscure: false,
          keyboardType: TextInputType.text,
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
                showStockAndPrice?TextTitle(text: showPrice?'Estoque':"Quantidade",fonts: 14):Container(),
                showStockAndPrice?InputRegister(
                  obscure: false,
                  keyboardType: TextInputType.number,
                  controller: this.controllerStock,
                  hint: '00',
                  width: width*0.2,
                  fonts: 14,
                ):Container(),
                showPrice&&showStockAndPrice?TextTitle(text: 'Preço Compra',fonts: 14):Container(),
                showPrice&&showStockAndPrice?InputRegister(
                  obscure: false,
                  keyboardType: TextInputType.number,
                  inputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    RealInputFormatter(centavos: true)
                  ],
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
                  obscure: false,
                  keyboardType: TextInputType.number,
                  controller: this.controllerStockMin,
                  hint: '00',
                  width: width*0.2,
                  fonts: 14,
                ):Container(),
                TextTitle(text: this.titlePrice,fonts: 14),
                InputRegister(
                  obscure: false,
                  keyboardType: TextInputType.number,
                  inputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    RealInputFormatter(centavos: true)
                  ],
                  controller: this.controllerPriceSale,
                  hint: 'R\$ 00,00',
                  width: width*0.3,
                  fonts: 14,
                )
              ],
            ),
            showCamera? sendPhoto?Column(
              children: [
                Icon(Icons.done,color: PaletteColor.green),
                Text('Foto enviada!',style: TextStyle(color: PaletteColor.green,fontSize: 10),)
              ],
            ):Visibility(
              visible: this.sendData,
              child: ButtonCamera(
                  onTap: this.onTapCamera,
                  width: width*0.2
              ),
            ):Container()
          ],
        ),
      ],
    );
  }
}

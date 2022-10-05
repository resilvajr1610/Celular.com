import '../Utils/export.dart';

class ItemsList extends StatelessWidget {

  final String item;
  final String data;
  VoidCallback onPressedDelete;
  VoidCallback onPressedEdit;
  VoidCallback onTapItem;
  final bool showDelete;

  ItemsList({
    this.data,
    this.item,
    this.onPressedDelete,
    this.onPressedEdit,
    this.showDelete,
    this.onTapItem
});

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: this.onTapItem,
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                width: width*0.7,
                alignment: Alignment.centerLeft,
                child: Text(
                  this.data!=null? this.data: this.item,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 15,
                    color: PaletteColor.darkGrey,
                    fontWeight: FontWeight.w400,
                  ),
                )
            ),
            Spacer(),
            SizedBox(width: 5),
            this.onPressedEdit!=null?GestureDetector(
              onTap: this.onPressedEdit,
              child: Icon(Icons.edit,color: PaletteColor.lightBlue),
            ):Container(),
            SizedBox(width: 5),
            showDelete?GestureDetector(
                        onTap: this.onPressedDelete,
                        child: Icon(Icons.delete,color: PaletteColor.lightBlue),
                      ):Container(),
          ],
        ),
      ),
    );
  }
}

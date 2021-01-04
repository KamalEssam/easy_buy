import 'package:easy_buy/data/model/product_model.dart';
import 'package:easy_buy/features/card/payment_view.dart';
import 'package:easy_buy/features/settings/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SelectedProductBottomSheet extends StatefulWidget {
  final Product product;
  final Function() setState;

  SelectedProductBottomSheet({this.product, this.setState});

  @override
  _IngredientsBottomSheetState createState() => _IngredientsBottomSheetState();
}

class _IngredientsBottomSheetState extends State<SelectedProductBottomSheet> {
  int c = 1;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.47,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.01,
              width: 65,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white),
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Step 1",
                      style: TextStyle(
                          // fontFamily: 'norican',
                          fontSize: 22,
                          color: Colors.black,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Text(
                      widget.product.name,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Image.network(
                      widget.product.photo,
                      height: 120,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (c <= widget.product.quantity)
                              c++;
                            else {
                              Fluttertoast.showToast(
                                  msg: "no more items",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1);
                            }
                          });
                        },
                        child: Icon(
                          Icons.add_box,
                          color: AppTheme().appTheme.primaryColor,
                          size: 35,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          c.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (c > 1)
                              c--;
                            else {
                              Fluttertoast.showToast(
                                  msg: "must add at least one item",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1);
                            }
                          });
                        },
                        child: Icon(
                          Icons.indeterminate_check_box,
                          color: AppTheme().appTheme.primaryColor,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.product.orderQuantity=c;
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PaymentMethod(product: widget.product)
                          )
                      );
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: AppTheme().appTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          'Order now',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:easy_buy/data/model/order_model.dart';
import 'package:easy_buy/data/model/product_model.dart';
import 'package:easy_buy/features/settings/theme.dart';
import 'package:easy_buy/features/widget/input_widget.dart';
import 'package:easy_buy/redux/action_report.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/utils/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'card_view_model.dart';

class PaymentMethod extends StatelessWidget {
  final Product product;

  const PaymentMethod({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CardViewModel>(
      distinct: true,
      converter: (store) => CardViewModel.fromStore(store),
      builder: (_, viewModel) => _PaymentMethodContent(
        viewModel: viewModel,
        product: product,
      ),
    );
  }
}

class _PaymentMethodContent extends StatefulWidget {
  CardViewModel viewModel;
  Product product;

  _PaymentMethodContent({Key key, this.viewModel, this.product})
      : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<_PaymentMethodContent> {
  TextEditingController cardController;
  TextEditingController expiredDateController;
  TextEditingController cvvController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();
    cardController = TextEditingController();
    cvvController = TextEditingController();
    expiredDateController = TextEditingController();
  }
  var payment = [
    'assets/images/mastercart.jpg',
    'assets/images/visa.jpg',
  ];
  int _value = 1;

  @override
  void didUpdateWidget(_PaymentMethodContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () {
      if (this.widget.viewModel.addOrderReport?.status ==
          ActionStatus.running) {
        if (progressDialog == null)
          progressDialog = new ProgressDialog(context);

        if (!progressDialog.isShowing()) {
          progressDialog.setMessage("Ordering ...");
          progressDialog.show();
        }
      } else if (this.widget.viewModel.addOrderReport?.status ==
          ActionStatus.error) {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
        showError(this.widget.viewModel.addOrderReport?.msg.toString());
      } else if (this.widget.viewModel.addOrderReport?.status ==
          ActionStatus.complete) {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
        this.widget.viewModel.addOrderReport?.status = null;
        showError("Order added");
        Navigator.pop(context);
      } else {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
      }
      this.widget.viewModel.addOrderReport?.status = null;
    });
  }


  @override
  Widget build(BuildContext context) {
    print(widget.product.quantity);
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Step 2",
                    style: TextStyle(
                        // fontFamily: 'norican',
                        fontSize: 22,
                        color: Colors.black,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(
                height: 50,
                color: Colors.grey[200],
                thickness: 2,
              ),
              SizedBox(
                height: 125,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 13, bottom: 13),
                              child: Image.asset(payment[index],width: 150,),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        ChoiceChip(
                          shape: CircleBorder(),
                          label: Icon(
                            Icons.done,
                            color: _value == index ? Colors.white : Colors.grey[300],
                          ),
                          selected: _value == index,
                          selectedColor: AppTheme().appTheme.primaryColor,
                          onSelected: (bool value) {
                            setState(() {
                              _value = value ? index : null;
                            });
                          },
                          backgroundColor: Colors.grey[300],
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  },
                ),),
              Container(
                margin: EdgeInsets.only(top: 16.0, left: 18, right: 18),
                child: Input(
                  controller: cardController,
                  hint: "card number",
                  obscureText: false,
                  type: TextInputType.number,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 16.0, left: 18, right: 18),
                    width: 150,
                    child: Input(
                        controller: expiredDateController,
                        hint: "expire date",
                        obscureText: false,
                        type: TextInputType.number),
                  ),
                  Container(
                    width: 110,
                    margin: EdgeInsets.only(top: 16.0, left: 18, right: 18),
                    child: Input(
                        controller: cvvController,
                        hint: "CVV",
                        obscureText: false,
                        type: TextInputType.number),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: order,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 230,
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppTheme().appTheme.primaryColor),
                    child: Center(
                        child: Text("confirmPay",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.bold,
                              //fontFamily: 'jost'
                            ))),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showError(String error) {
    final snackBar = SnackBar(content: Text(error));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  order() {
    if (cardController.text.isEmpty) {
      showError("Card number is empty");
      return;
    }
    if (expiredDateController.text.isEmpty) {
      showError("Expired Date is empty");
      return;
    }
    if (cvvController.text.isEmpty) {
      showError("CVV is empty");
      return;
    }
    if (cardController.text.length != 16) {
      showError("Card number must be 16 numbers");
      return;
    }
    if (cvvController.text.length != 3) {
      showError("CVV is 3 numbers only");
      return;
    }
    FocusScope.of(context).unfocus();
    widget.viewModel.order(Order(
        product: widget.product,
        orderBy:FirebaseAuth.instance.currentUser.uid,
        pId: widget.product.productId
    ));
  }
}

import 'dart:io';
import 'dart:ui';
import 'package:easy_buy/data/model/product_model.dart';
import 'package:easy_buy/data/model/user_model.dart';
import 'package:easy_buy/features/profile/personal_data.dart';
import 'package:easy_buy/features/profile/profile_view_model.dart';
import 'package:easy_buy/features/settings/theme.dart';
import 'package:easy_buy/features/widget/button.dart';
import 'package:easy_buy/features/widget/gallary_or_camera_dialog.dart';
import 'package:easy_buy/features/widget/input_widget.dart';
import 'package:easy_buy/features/widget/list_view.dart';
import 'package:easy_buy/redux/action_report.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/utils/animation_utils.dart';
import 'package:easy_buy/utils/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfileViewModel>(
      distinct: true,
      converter: (store) => ProfileViewModel.fromStore(store),
      builder: (_, viewModel) => _ProfileContent(
        viewModel: viewModel,
      ),
    );
  }
}

class _ProfileContent extends StatefulWidget {
  ProfileViewModel viewModel;

  _ProfileContent({Key key, this.viewModel}) : super(key: key);

  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<_ProfileContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File userImage;
  ProgressDialog progressDialog;
  UserModel user;
  Product product;

  @override
  void initState() {
    super.initState();
    user = widget.viewModel.user;
    if (widget.viewModel.user != null) {
      if (widget.viewModel.user.role != "admin")
        widget.viewModel.getOrders(user.id);
      else
        widget.viewModel.getOrders(null);
    }

  }

  void showError(String error) {
    final snackBar = SnackBar(content: Text(error));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: widget.viewModel.user != null
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                    elevation: 2,
                    margin: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(70)),
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            height: 75,
                            width: 75,
                            child: user.img == null
                                ? Image.asset(
                                    "assets/images/female.png",
                                  )
                                : Image.network(
                                    user.img,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              user.name ?? "",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: AppTheme().appTheme.primaryColor),
                            ),
                            Text(
                              user.phone,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: AppTheme().appTheme.primaryColor),
                            ),
                            Text(
                              user.address,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: AppTheme().appTheme.primaryColor),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PersonalData()));
                            }
                          },
                          child: Icon(
                            Icons.edit,
                            color: AppTheme().appTheme.primaryColor,
                            size: 20,
                          ),
                        )
                      ],
                    )),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Text(
                    "Orders :",
                    style: TextStyle(
                        fontSize: 18, color: AppTheme().appTheme.primaryColor),
                  ),
                ),
                Expanded(
                  child: MyListView(
                    report: this.widget.viewModel.getOrdersReport,
                    listSize: widget.viewModel.orders.length,
                    listBuilder: ListView.builder(
                      itemCount: widget.viewModel.orders.length,
                      itemBuilder: (BuildContext context, int index) {
                        product = widget.viewModel.orders[index].product;
                        return InkWell(
                          onTap: () {},
                          child: new Card(
                            elevation: 2,
                            margin: EdgeInsets.all(8.0),
                            color: Colors.white,
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Image.network(
                                    product.photo,
                                    height: 105,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppTheme()
                                                  .appTheme
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Order quantity : " +
                                              product.orderQuantity.toString(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Order price : " +
                                              product.price.toString() +
                                              " LE",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          : Container(
              child: Center(
                child: Hero(
                  tag: "noData",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/ecommerce.png",
                        fit: BoxFit.fitWidth,
                        width: 300,
                      ),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Login first to find your data here',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme().appTheme.primaryColor,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      MyButton(
                        text: "Login now",
                        onTap: () {
                          Navigator.of(context).pushNamed("/login");
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

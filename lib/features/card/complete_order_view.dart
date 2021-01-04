import 'dart:io';
import 'dart:ui';
import 'package:easy_buy/data/model/product_model.dart';
import 'package:easy_buy/data/model/user_model.dart';
import 'package:easy_buy/features/card/card_view_model.dart';
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

class CompleteOrderView extends StatelessWidget {
  const CompleteOrderView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfileViewModel>(
      distinct: true,
      converter: (store) => ProfileViewModel.fromStore(store),
      builder: (_, viewModel) => _CompleteOrderViewContent(
        viewModel: viewModel,
      ),
    );
  }
}

class _CompleteOrderViewContent extends StatefulWidget {
  ProfileViewModel viewModel;

  _CompleteOrderViewContent({Key key, this.viewModel}) : super(key: key);

  @override
  _CompleteOrderState createState() => _CompleteOrderState();
}

class _CompleteOrderState extends State<_CompleteOrderViewContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  void showError(String error) {
    final snackBar = SnackBar(content: Text(error));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.viewModel.user.id);
    print("widget.viewModel.user.id)");
    return Scaffold(
      key: _scaffoldKey,
      body: Container()
    );
  }
}

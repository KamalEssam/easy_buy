import 'dart:async';
import 'dart:convert';
import 'package:easy_buy/data/model/user_model.dart';
import 'package:easy_buy/features/splash/splash_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../redux/app/app_state.dart';

class SplashView extends StatelessWidget {
  SplashView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SplashViewModel>(
      distinct: true,
      converter: (store) => SplashViewModel.fromStore(store),
      builder: (_, viewModel) => SplashViewContent(
        viewModel: viewModel,
      ),
    );
  }
}

class SplashViewContent extends StatefulWidget {
  SplashViewModel viewModel;

  SplashViewContent({
    Key key,
    this.viewModel,
  }) : super(key: key);

  _SplashViewContentState createState() => _SplashViewContentState();
}

class _SplashViewContentState extends State<SplashViewContent> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 4), onDoneLoading);
  }

  onDoneLoading() async {
    SharedPreferences.getInstance().then((prefs) {
      bool isLogined = prefs.getBool("isLogined") ?? false;
      if (!isLogined) {
        Navigator.of(context).pushReplacementNamed("/login");
      } else {
        final JsonDecoder _decoder = new JsonDecoder();
        setState(() {
          this.widget.viewModel.setUser(
              UserModel.fromJson(_decoder.convert(prefs.getString("user"))));
        });
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: Hero(
              tag: "Logo",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/loader.gif",
                    fit: BoxFit.fitWidth,
                    width: 300,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

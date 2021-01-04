import 'dart:ui';
import 'package:easy_buy/features/category/category_view.dart';
import 'package:easy_buy/features/profile/profile.dart';
import 'package:easy_buy/features/settings/theme.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(
      distinct: true,
      converter: (store) => HomeViewModel.fromStore(store),
      builder: (_, viewModel) => _HomeViewContent(
        viewModel: viewModel,
      ),
    );
  }
}

class _HomeViewContent extends StatefulWidget {
  HomeViewModel viewModel;

  _HomeViewContent({Key key, this.viewModel}) : super(key: key);

  @override
  _HomeViewContentState createState() => _HomeViewContentState();
}

class _HomeViewContentState extends State<_HomeViewContent>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  List<Widget> _children;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _children = [
      CategoryView(),
      Profile(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor:AppTheme().appTheme.primaryColor,
        title: Align(
          child: Text(
            'Easy buy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontFamily: 'Norican',
            ),
          ),
        ),
        actions: [
          widget.viewModel.user!=null?Container(
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                widget.viewModel.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              },
              child: Icon(
                Icons.power_settings_new,
                color: Colors.white,
                size: 22,
              ),
            ),
          ):Container(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
       //backgroundColor: Colors.grey[200],
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor:AppTheme().appTheme.primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,size: 25,),
            title: Text(
              "Home",
              style: TextStyle(
                fontSize: 12,
                fontFamily: "din-regular",
              ),
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                size: 25,
              ),
              title: Text(
                "Account",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "din-regular",
                ),
              )),
        ],
      ),
      body:  _children[_currentIndex],
    );
  }
}

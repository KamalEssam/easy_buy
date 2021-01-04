import 'dart:async';
import 'package:easy_buy/features/splash/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_buy/trans/translations.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/redux/store.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_buy/features/settings/settings_option.dart';
import 'package:easy_buy/features/settings/settings_option_page.dart';
import 'package:easy_buy/features/settings/text_scale.dart';
import 'package:easy_buy/features/settings/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/sign_in/sign_in_view.dart';
import 'features/auth/sign_up/signup_view.dart';
import 'features/category/add_category_view.dart';
import 'features/home/home_view.dart';



main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var store = await createStore();
  runApp(MyApp(store));
}

class MyApp extends StatefulWidget {
  final Store<AppState> store;

  MyApp(this.store);

  @override
  _MyAppState createState() => new _MyAppState();
}


class _MyAppState extends State<MyApp> {
  SettingsOptions _options;

  @override
  void initState() {
    super.initState();
    _options = new SettingsOptions(
      theme: AppTheme().appTheme,
      textScaleFactor: appTextScaleValues[0],
      platform: defaultTargetPlatform,
    );
    SharedPreferences.getInstance().then((prefs) {
      var isDark = prefs.getBool("isDark") ?? false;
      if (isDark) {
        AppTheme.configure(ThemeName.DARK);
        setState(() {
          _options = _options.copyWith(theme: AppTheme().appTheme);
        });
      }
    });
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: widget.store,
        child: MaterialApp(
          title: 'Easy buy',
          debugShowCheckedModeBanner: false,
          routes: _routes(),
          theme: _options.theme.copyWith(platform: _options.platform),
          builder: (BuildContext context, Widget child) {
            return new Directionality(
              textDirection: _options.textDirection,
              child: _applyTextScaleFactor(child),
            );
          },
          localizationsDelegates: [
            const TranslationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            const FallbackCupertinoLocalisationsDelegate(),
          ],
          supportedLocales: [
            const Locale('zh', 'CH'),
            const Locale('en', 'US'),
          ],
        ));
  }


  Widget _applyTextScaleFactor(Widget child) {
    return new Builder(
      builder: (BuildContext context) {
        return new MediaQuery(
          data: MediaQuery.of(context).copyWith(
                textScaleFactor: _options.textScaleFactor.scale,
              ),
          child: child,
        );
      },
    );
  }

  void _handleOptionsChanged(SettingsOptions newOptions) {
    setState(() {
      _options = newOptions;
    });
  }

  Map<String, WidgetBuilder> _routes() {
    return <String, WidgetBuilder>{
      "/settings": (_) => SettingsOptionsPage(
            options: _options,
            onOptionsChanged: _handleOptionsChanged,
          ),
      "/": (_) => SplashView(),
      "/home": (_) => HomeView(),
      "/login": (_) => SignInView(),
      "/signUp": (_) => SignUpView(),
      "/addCategory": (_) => AddCategoryView(),
    };
  }
}
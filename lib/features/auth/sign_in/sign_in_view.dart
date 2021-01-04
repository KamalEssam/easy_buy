import 'dart:ui';
import 'package:easy_buy/features/settings/theme.dart';
import 'package:easy_buy/features/widget/gradient.dart';
import 'package:easy_buy/features/widget/image_filter.dart';
import 'package:easy_buy/features/widget/wave_clippers.dart';
import 'package:easy_buy/redux/action_report.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/utils/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../auth_input_widget.dart';
import 'sign_in_view_model.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SignInViewModel>(
      distinct: true,
      converter: (store) => SignInViewModel.fromStore(store),
      builder: (_, viewModel) => _SignInViewContent(
        viewModel: viewModel,
      ),
    );
  }
}

class _SignInViewContent extends StatefulWidget {
  SignInViewModel viewModel;

  _SignInViewContent({Key key, this.viewModel}) : super(key: key);

  @override
  _SignInViewContentState createState() => _SignInViewContentState();
}

class _SignInViewContentState extends State<_SignInViewContent>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AnimationController _controller;
  Animation<double> _animation, delayedDuration, muchDelayedDuration;

  TextEditingController emailController;
  TextEditingController passwordController;

  ProgressDialog progressDialog;

  bool showPassword = false;
  bool passwordValidate=false;
  bool emailValidate=false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void didUpdateWidget(_SignInViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () {
      if (this.widget.viewModel.getLoginReport?.status ==
          ActionStatus.running) {
        if (progressDialog == null)
          progressDialog = new ProgressDialog(context);

        if (!progressDialog.isShowing()) {
          progressDialog.setMessage("Sign in...");
          progressDialog.show();
        }
      } else if (this.widget.viewModel.getLoginReport?.status ==
          ActionStatus.error) {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
        showError(this.widget.viewModel.getLoginReport?.msg.toString());
      } else if (this.widget.viewModel.getLoginReport?.status ==
          ActionStatus.complete) {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
        this.widget.viewModel.getLoginReport?.status = null;
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/home', (Route<dynamic> route) => false);
      } else {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
      }
      this.widget.viewModel.getLoginReport?.status = null;
    });
  }

  void showError(String error) {
    final snackBar = SnackBar(content: Text(error));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void dispose() {
    super.dispose();
  }

  login() {
    if (emailController.text.isEmpty) {
      setState(() {
        emailValidate=true;
      });
      return;
    }

    if (emailController.text.isNotEmpty) {
      setState(() {
        emailValidate=false;
      });
    }
    if (passwordController.text.isEmpty) {
      setState(() {
        passwordValidate=true;
      });
      return;
    }
    if (passwordController.text.isNotEmpty) {
      setState(() {
        passwordValidate=false;
      });
    }

    this.widget.viewModel.login(emailController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              ClipPath(
                clipper: LoginBottom(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: GradientView(
                    colors: [Color(0xffE9F5FB), Color(0xffE9F5FB)],
                  ),
                ),
              ),
              ClipPath(
                clipper: LoginBottomTwo(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: GradientView(
                    colors: [Color(0xffE9F1FB), Color(0xffE9d8FB)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/home', (Route<dynamic> route) => false);
                            },
                            child: Text(
                              'Skip',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: 'NotoSansSC',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Image.asset(
                        "assets/images/ecommerce.png",
                        fit: BoxFit.fitHeight,
                        width: 320,
                      ),
                    ),
                    AuthInput(
                      errorText: "error email empty",
                      validate: emailValidate,
                        controller: emailController,
                        suffixIcon: Icon(
                          Icons.email,
                          color: AppTheme().appTheme.primaryColor,
                        ),
                        hint: 'Email',
                        obscureText: false),
                    SizedBox(
                      height: 12.0,
                    ),
                    AuthInput(
                      validate: passwordValidate,
                        controller: passwordController,
                        errorText: "error password empty",
                        suffixIcon: GestureDetector(
                          child: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppTheme().appTheme.primaryColor,
                          ),
                          onTap: () => setState(() {
                            showPassword = !showPassword;
                          }),
                        ),
                        hint: 'Password',
                        obscureText: !showPassword),
                    SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
                      onTap: login,
                      child: Container(
                        height: 50.0,
                        width:
                        MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: AppTheme().appTheme.primaryColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                        child: Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed("/signUp");
                        },
                        child: Text(
                          ' Sign Up ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:AppTheme().appTheme.primaryColor,
                            fontSize: 18.0,
                            fontFamily: 'NotoSansSC',
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
      ),
    );
  }
}

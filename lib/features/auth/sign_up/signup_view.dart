import 'dart:ui';
import 'package:easy_buy/data/model/user_model.dart';
import 'package:easy_buy/features/auth/sign_up/sign_up_view_model.dart';
import 'package:easy_buy/features/settings/theme.dart';
import 'package:easy_buy/features/widget/gradient.dart';
import 'package:easy_buy/features/widget/image_filter.dart';
import 'package:easy_buy/features/widget/wave_clippers.dart';
import 'package:easy_buy/redux/action_report.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../auth_input_widget.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SignUpViewModel>(
      distinct: true,
      converter: (store) => SignUpViewModel.fromStore(store),
      builder: (_, viewModel) => _SignUpViewContent(
        viewModel: viewModel,
      ),
    );
  }
}

class _SignUpViewContent extends StatefulWidget {
  SignUpViewModel viewModel;

  _SignUpViewContent({Key key, this.viewModel}) : super(key: key);

  @override
  _SignUpViewContentState createState() => _SignUpViewContentState();
}

class _SignUpViewContentState extends State<_SignUpViewContent>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool nameValidate=false;
  bool passwordValidate=false;
  bool emailValidate=false;
  bool confirmPasswordValidate=false;
  bool phoneValidate=false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  var lpr;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(_SignUpViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () {
      if (this.widget.viewModel.signupReport?.status == ActionStatus.running) {
        if (lpr == null) {
          lpr = new ProgressDialog(context);
        }
        if (!lpr.isShowing()) {
          lpr.setMessage("loading");
          lpr.show();
        }
      } else if (this.widget.viewModel.signupReport?.status ==
          ActionStatus.error) {
        if (lpr != null && lpr.isShowing()) {
          lpr.hide();
          lpr.setMessage(":)");
          lpr = null;
        }
        showError(this.widget.viewModel.signupReport?.msg.toString());
      } else if (this.widget.viewModel.signupReport?.status ==
          ActionStatus.complete) {
        if (lpr != null && lpr.isShowing()) {
          lpr.hide();
          lpr = null;
        }
        this.widget.viewModel.signupReport?.status = null;
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/home', (Route<dynamic> route) => false);
      } else {
        if (lpr != null && lpr.isShowing()) {
          lpr.hide();
          lpr = null;
        }
      }
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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(children: [
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 22.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Image.asset(
                      "assets/images/ecommerce.png",
                      fit: BoxFit.fitHeight,
                      width: 220,
                    ),
                  ),
                  AuthInput(
                    validate: nameValidate,
                      controller: nameController,
                      errorText: "error name empty",
                      suffixIcon: Icon(
                        Icons.account_box,
                        color: AppTheme().appTheme.primaryColor,
                      ),
                      hint: 'Name',
                      obscureText: false),
                  SizedBox(
                    height: 10.0,
                  ),
                  AuthInput(
                      controller: emailController,
                      suffixIcon: Icon(
                        Icons.email,
                        color:  AppTheme().appTheme.primaryColor,
                      ),
                      hint: 'Email',
                      errorText: "error email empty",
                      obscureText: false,
                    validate: emailValidate,),
                  SizedBox(
                    height: 10.0,
                  ),
                  AuthInput(
                      controller: phoneController,
                      suffixIcon: Icon(
                        Icons.phone,
                        color:AppTheme().appTheme.primaryColor,
                      ),
                      hint: 'Mobile Number',
                      errorText: "error phone empty",
                      obscureText: false,validate: phoneValidate,),
                  SizedBox(
                    height: 10.0,
                  ),
                  AuthInput(
                      controller: passwordController,
                      validate: passwordValidate,
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
                    height: 10.0,
                  ),
                  AuthInput(
                    validate: confirmPasswordValidate,
                      controller: confirmPasswordController,
                      errorText: "error confirm password empty",
                      suffixIcon: GestureDetector(
                        child: Icon(
                          showConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppTheme().appTheme.primaryColor,
                        ),
                        onTap: () => setState(() {
                          showConfirmPassword = !showConfirmPassword;
                        }),
                      ),
                      hint: 'confirm Password',
                      obscureText: !showConfirmPassword),
                  SizedBox(
                    height: 30.0,
                  ),
                  GestureDetector(
                    onTap: signUp,
                    child: Container(
                      height: 50.0,
                      width:
                      MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color:AppTheme().appTheme.primaryColor,
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      child: Center(
                        child: Text(
                          'Sign Up',
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
            )
          ],),
        ),
      ),
    );
  }

  signUp() {
    if (nameController.text.isEmpty) {
      setState(() {
        nameValidate=true;
      });
      return;
    }

    if (nameController.text.isNotEmpty) {
      setState(() {
        nameValidate=false;
      });
    }

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

    if (phoneController.text.isEmpty) {
      setState(() {
        phoneValidate=true;
      });
      return;
    }

    if (phoneController.text.isNotEmpty) {
      setState(() {
        phoneValidate=false;
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

    if (confirmPasswordController.text.isEmpty) {
      setState(() {
        confirmPasswordValidate=true;
      });
      return;
    }

    if (confirmPasswordController.text.isNotEmpty) {
      setState(() {
        confirmPasswordValidate=false;
      });
    }

    if (passwordController.text.length < 6) {
      showError("error password min six");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showError("password and confirm not match");
      return;
    }
    UserModel user = UserModel();
    user.phone = phoneController.text;
    user.email = emailController.text;
    user.name = nameController.text;
    this
        .widget
        .viewModel
        .signUp(emailController.text, passwordController.text, user);
  }
}

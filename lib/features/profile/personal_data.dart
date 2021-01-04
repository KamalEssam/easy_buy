import 'dart:io';
import 'package:easy_buy/features/profile/profile_view_model.dart';
import 'package:easy_buy/features/settings/theme.dart';
import 'package:easy_buy/features/widget/gallary_or_camera_dialog.dart';
import 'package:easy_buy/features/widget/input_widget.dart';
import 'package:easy_buy/redux/action_report.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/utils/animation_utils.dart';
import 'package:easy_buy/utils/progress_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PersonalData extends StatelessWidget {
  const PersonalData({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfileViewModel>(
      distinct: true,
      converter: (store) => ProfileViewModel.fromStore(store),
      builder: (_, viewModel) => PersonalDataContent(
        viewModel: viewModel,
      ),
    );
  }
}

class PersonalDataContent extends StatefulWidget {
  ProfileViewModel viewModel;

  PersonalDataContent({this.viewModel});

  @override
  _PersonalDataContentState createState() => _PersonalDataContentState();
}

class _PersonalDataContentState extends State<PersonalDataContent> {
  File userImage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog progressDialog;
  TextEditingController nameController;
  TextEditingController addressController;
  TextEditingController phoneController;

  @override
  void didUpdateWidget(PersonalDataContent oldWidget) {
    Future.delayed(Duration.zero, ()  {
      if (this.widget.viewModel.editProfileReport?.status ==
          ActionStatus.running) {
        if (progressDialog == null)
          progressDialog = new ProgressDialog(context);

        if (!progressDialog.isShowing()) {
          progressDialog.setMessage("Editing...");
          progressDialog.show();
        }
      } else if (this.widget.viewModel.editProfileReport?.status ==
          ActionStatus.error) {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
        showError(this.widget.viewModel.editProfileReport?.msg.toString());
      } else if (this.widget.viewModel.editProfileReport?.status ==
          ActionStatus.complete) {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
        this.widget.viewModel.editProfileReport?.status = null;
        showError("completed");
      } else {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
      }
      this.widget.viewModel.editProfileReport?.status = null;
    });
    super.didUpdateWidget(oldWidget);
  }

  void showError(String error) {
    final snackBar = SnackBar(content: Text(error));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Edit profile",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Stack(
              children: [
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  height: 140,
                  width: 140,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: CircleAvatar(
                      backgroundImage: userImage != null
                          ? FileImage(
                        userImage,
                      )
                          : NetworkImage(
                        widget.viewModel.user.img,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
//                      shape: BoxShape.circle,
                      border: Border.all(color:AppTheme().appTheme.primaryColor, width: 2)),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            HeroDialogRoute(
                              builder: (BuildContext context) =>
                                  CameraOrGallaryDialog(
                                    onSelectImage: (photo) {
                                      setState(() {
                                        userImage = photo;
                                      });
                                    },
                                  ),
                            ),
                          );
                        },
                        child: Image.asset('assets/images/camera.png',
                            width: 38, color: AppTheme().appTheme.primaryColor)),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16.0, left: 18, right: 18),
            child: Input(
                controller: nameController,
                hint: "name: " +  widget.viewModel.user.name,
                obscureText: false),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 16.0, left: 18, right: 18, bottom: 10),
            child: Input(
                controller: phoneController,
                hint: "phone: " +  widget.viewModel.user.phone,
                obscureText: false),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 16.0, left: 18, right: 18, bottom: 10),
            child: Input(
                controller: addressController,
                hint: "address: " +  widget.viewModel.user.address,
                obscureText: false),
          ),

          GestureDetector(
            onTap: () {
              if (nameController.text.isNotEmpty)
                widget.viewModel.user.name = nameController.text;
              if (phoneController.text.isNotEmpty)
                widget.viewModel.user.phone = phoneController.text;
              if (addressController.text.isNotEmpty)
                widget.viewModel.user.address = addressController.text;
              print( widget.viewModel.user);
              widget.viewModel.editProfile( widget.viewModel.user, userImage);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 48),
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  'Edit data',
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
    );
  }
}
import 'dart:convert';
import 'dart:io';
import 'package:easy_buy/data/model/category_model.dart';
import 'package:easy_buy/features/settings/theme.dart';
import 'package:easy_buy/features/widget/gallary_or_camera_dialog.dart';
import 'package:easy_buy/features/widget/input_widget.dart';
import 'package:easy_buy/redux/action_report.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/utils/animation_utils.dart';
import 'package:easy_buy/utils/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'category_view_model.dart';

class AddSubCategoryView extends StatelessWidget {
  final CategoryModel category;

  const AddSubCategoryView({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CategoryViewModel>(
      distinct: true,
      converter: (store) => CategoryViewModel.fromStore(store),
      builder: (_, viewModel) => _AddSubCategoryViewContent(
        viewModel: viewModel,
        category: category,
      ),
    );
  }
}

class _AddSubCategoryViewContent extends StatefulWidget {
  CategoryViewModel viewModel;
  CategoryModel category;

  _AddSubCategoryViewContent({Key key, this.viewModel, this.category})
      : super(key: key);

  @override
  _AddSubCategoryViewState createState() => _AddSubCategoryViewState();
}

class _AddSubCategoryViewState extends State<_AddSubCategoryViewContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog progressDialog;
  File image;
  TextEditingController nameController;

  @override
  void didUpdateWidget(_AddSubCategoryViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () {
      if (this.widget.viewModel.addSubCategoryReport?.status ==
          ActionStatus.running) {
        if (progressDialog == null)
          progressDialog = new ProgressDialog(context);

        if (!progressDialog.isShowing()) {
          progressDialog.setMessage("Adding subCategory...");
          progressDialog.show();
        }
      } else if (this.widget.viewModel.addSubCategoryReport?.status ==
          ActionStatus.error) {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
        showError(this.widget.viewModel.addSubCategoryReport?.msg.toString());
      } else if (this.widget.viewModel.addSubCategoryReport?.status ==
          ActionStatus.complete) {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
        this.widget.viewModel.addSubCategoryReport?.status = null;
        showError("SubCategory added");
        setState(() {
          image = null;
          nameController.clear();
        });
      } else {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
      }
      this.widget.viewModel.addSubCategoryReport?.status = null;
    });
  }

  void showError(String error) {
    final snackBar = SnackBar(content: Text(error));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppTheme().appTheme.primaryColor,
        title: Align(
          child: Text(
            'Add Category',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontFamily: 'Norican',
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 75,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(16.0),
                    height: 160,
                    width: 160,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: image == null
                          ? Image.network(
                              "https://firebasestorage.googleapis.com/v0/b/easybuy-e7517.appspot.com/o/interface.png?alt=media&token=bfe100ea-71b2-4f50-a3d7-dae35ba5589b")
                          : Image.file(image),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: AppTheme().appTheme.primaryColor, width: 1)),
                  ),
                  Positioned(
                    right: 2,
                    bottom: 2,
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
                                      image = photo;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/camera.png',
                            width: 38,
                            color: Colors.blueAccent,
                          )),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0, left: 18, right: 18),
              child: Input(
                  controller: nameController, hint: "name", obscureText: false),
            ),
            GestureDetector(
              onTap: () {
                addCategory();
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                height: 50.0,
                decoration: BoxDecoration(
                  color: AppTheme().appTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    'Add',
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
    );
  }

  void addCategory() {
    if (nameController.text.isEmpty) {
      showError("name is empty");
      return;
    }
    FocusScope.of(context).unfocus();
    print(widget.category.catId);
    print(jsonEncode(widget.category));
    widget.viewModel.addSubCategory(
        CategoryModel(name: nameController.text, catId: widget.category.catId),
        image,
        widget.category);
  }
}

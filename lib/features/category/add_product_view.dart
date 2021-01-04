import 'dart:io';
import 'package:chips_choice/chips_choice.dart';
import 'package:easy_buy/data/model/category_model.dart';
import 'package:easy_buy/data/model/product_model.dart';
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

class AddProductView extends StatelessWidget {
  final CategoryModel category;

  const AddProductView({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CategoryViewModel>(
      distinct: true,
      converter: (store) => CategoryViewModel.fromStore(store),
      builder: (_, viewModel) => _AddProductViewContent(
        viewModel: viewModel,
        category: category,
      ),
    );
  }
}

class _AddProductViewContent extends StatefulWidget {
  CategoryViewModel viewModel;
  CategoryModel category;

  _AddProductViewContent({Key key, this.viewModel, this.category})
      : super(key: key);

  @override
  _AddProductViewState createState() => _AddProductViewState();
}

class _AddProductViewState extends State<_AddProductViewContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog progressDialog;
  File image;
  TextEditingController nameController;
  TextEditingController priceController;
  TextEditingController qController;
  CategoryModel sCategory;
  int selectedK;

  @override
  void didUpdateWidget(_AddProductViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () {
      if (this.widget.viewModel.addProductReport?.status ==
          ActionStatus.running) {
        if (progressDialog == null)
          progressDialog = new ProgressDialog(context);

        if (!progressDialog.isShowing()) {
          progressDialog.setMessage("Adding Product...");
          progressDialog.show();
        }
      } else if (this.widget.viewModel.addProductReport?.status ==
          ActionStatus.error) {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
        showError(this.widget.viewModel.addProductReport?.msg.toString());
      } else if (this.widget.viewModel.addProductReport?.status ==
          ActionStatus.complete) {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
        this.widget.viewModel.addProductReport?.status = null;
        showError("Product added");
        setState(() {
          image = null;
          nameController.clear();
          qController.clear();
          priceController.clear();
          selectedK=-1;
          sCategory=null;
        });
      } else {
        if (progressDialog != null && progressDialog.isShowing()) {
          progressDialog.hide();
          progressDialog = null;
        }
      }
      this.widget.viewModel.addProductReport?.status = null;
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
    priceController = TextEditingController();
    qController = TextEditingController();
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
                              "https://firebasestorage.googleapis.com/v0/b/easybuy-e7517.appspot.com/o/package.png?alt=media&token=c8677400-8bbf-4d51-b604-17d8cc7d37ab")
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
            Container(
              margin: EdgeInsets.only(top: 16.0, left: 18, right: 18),
              child: Input(
                  controller: priceController,
                  hint: "price",
                  obscureText: false),
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0, left: 18, right: 18),
              child: Input(
                  controller: qController,
                  hint: "quantity",
                  obscureText: false),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 8),
                child: Text("Select subcategory")),
            ChipsChoice<int>.single(
              value: selectedK,
              onChanged: (val) {
                setState(() {
                  sCategory=widget.category.subCategories[val];
                  selectedK=val;
                });
              },
              choiceStyle: const C2ChoiceStyle(
                color: Colors.blueGrey,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                showCheckmark: false,
              ),
              choiceActiveStyle: const C2ChoiceStyle(
                color: Colors.blueGrey,
                brightness: Brightness.dark,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                showCheckmark: false,
              ),
              choiceItems: C2Choice.listFrom<int, CategoryModel>(
                source: widget.category.subCategories,
                value: (i, v) => i,
                label: (i, v) => v.name,
                tooltip: (i, v) => v.name,

              ),
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
    if (priceController.text.isEmpty) {
      showError("price is empty");
      return;
    }
    if (qController.text.isEmpty) {
      showError("quantity is empty");
      return;
    }
    if(sCategory==null){
      showError("select subCategory");
      return;
    }
    FocusScope.of(context).unfocus();
    widget.viewModel.addProduct(
        widget.category,
        image,
        Product(
            name: nameController.text,
            categoryId: widget.category.catId,
            price: num.parse( priceController.text.toString()),
            subCategoryId: sCategory.id,
            quantity:int.parse(  qController.text .toString()),));
  }
}

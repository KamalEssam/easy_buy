import 'package:chips_choice/chips_choice.dart';
import 'package:easy_buy/data/model/category_model.dart';
import 'package:easy_buy/data/model/product_model.dart';
import 'package:easy_buy/features/card/selected_product_bottom_sheet.dart';
import 'package:easy_buy/features/category/add_product_view.dart';
import 'package:easy_buy/features/category/add_subcategory_view.dart';
import 'package:easy_buy/features/settings/theme.dart';
import 'package:easy_buy/features/widget/list_view.dart';
import 'package:easy_buy/redux/action_report.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'category_view_model.dart';

class SubcategoryView extends StatelessWidget {
  final CategoryModel category;

  const SubcategoryView({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CategoryViewModel>(
      distinct: true,
      converter: (store) => CategoryViewModel.fromStore(store),
      builder: (_, viewModel) => _SubcategoryViewContent(
        viewModel: viewModel,
        category: category,
      ),
    );
  }
}

class _SubcategoryViewContent extends StatefulWidget {
  CategoryViewModel viewModel;
  CategoryModel category;

  _SubcategoryViewContent({Key key, this.viewModel, this.category})
      : super(key: key);

  @override
  __SubcategoryViewState createState() => __SubcategoryViewState();
}

class __SubcategoryViewState extends State<_SubcategoryViewContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedK;
  List<Product> productsList = [];

  @override
  void initState() {
    super.initState();
    widget.viewModel.getSubCategory(widget.category);
    widget.viewModel.getProducts(widget.category);
  }

  @override
  void didUpdateWidget(_SubcategoryViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () {
      if (widget.viewModel.getProductsReport.status == ActionStatus.complete) {
        widget.viewModel.getProductsReport.status = null;
        setState(() {
          productsList = widget.category.products;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppTheme().appTheme.primaryColor,
        title: Row(
          children: [
            Image.network(
              widget.category.img,
              height: 32,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              widget.category.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontFamily: 'Norican',
              ),
            )
          ],
        ),
      ),
      body: widget.viewModel.getSubCategoryReport.status == ActionStatus.running
          ? Container(
              child: Center(
                  child: CircularProgressIndicator(
                strokeWidth: 3,
              )),
            )
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.category.subCategories.length != 0
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          height: MediaQuery.of(context).size.height * 0.09,
                          child: ChipsChoice<int>.single(
                            value: selectedK,
                            onChanged: (val) {
                              setState(() {
                                selectedK = val;
                                widget
                                    .category.subCategories[selectedK].products
                                    .clear();
                                widget.category.products.forEach((element) {
                                  if (element.subCategoryId ==
                                      widget.category.subCategories[selectedK]
                                          .id) {
                                    widget.category.subCategories[selectedK]
                                        .products
                                        .add(element);
                                  }
                                });
                                productsList = widget
                                    .category.subCategories[selectedK].products;
                              });
                            },
                            choiceStyle: const C2ChoiceStyle(
                              color: Colors.blueGrey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              showCheckmark: false,
                            ),
                            choiceActiveStyle: const C2ChoiceStyle(
                              color: Colors.blueGrey,
                              brightness: Brightness.dark,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              showCheckmark: false,
                            ),
                            choiceItems: C2Choice.listFrom<int, CategoryModel>(
                              source: widget.category.subCategories,
                              value: (i, v) => i,
                              label: (i, v) => v.name,
                              tooltip: (i, v) => v.name,
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: MyListView(
                      report: this.widget.viewModel.getProductsReport,
                      listSize: productsList.length,
                      listBuilder: GridView.builder(
                        itemCount: productsList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? 2
                                    : 3,childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.9),),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {},
                            child: new Card(
                              elevation: 2,
                              margin: EdgeInsets.all(6.0),
                              color: Colors.white,
                              child: Stack(
                                children: [

                                  Column(
                                    children: [
                                      Image.network(
                                        productsList[index].photo,
                                        height: 120,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment:  MainAxisAlignment.spaceAround,
                                              children: [
                                                FittedBox(
                                                  child: Text(
                                                    productsList[index].name,
                                                    style: TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                                SizedBox(height: 6.0,),
                                                Text(
                                                  productsList[index]
                                                      .price
                                                      .toString()+" LE",
                                                  style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            widget.viewModel.user != null &&
                                                    widget.viewModel.user.role ==
                                                        "admin"
                                                ? InkWell(
                                                    onTap: () {
                                                      showAlertDialog(
                                                          context,
                                                          productsList[index]);
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 22,
                                                    ),
                                                  )
                                                : widget.viewModel.user != null ? InkWell(
                                                    onTap: () {
                                                      print("b");
                                                      showModalBottomSheet(
                                                          backgroundColor: Colors.transparent,
                                                          isScrollControlled: true,
                                                          context: context,
                                                          builder: (context) {
                                                            return   SelectedProductBottomSheet( product: productsList[index],);
                                                          });
                                                    },
                                                    child: Icon(
                                                      Icons.add_shopping_cart,
                                                      color: AppTheme()
                                                          .appTheme
                                                          .primaryColor,
                                                      size: 22,
                                                    ),
                                                  ):Container(),
                                          ],
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                      ),
                                    ],
                                  ),
                                  productsList[index].quantity==0? Positioned(child: Container(
                                    padding: EdgeInsets.all(4.0),
                                    color: AppTheme().appTheme.primaryColor.withOpacity(0.4),
                                    child: Text("Sold out"),
                                  )):Container(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  widget.viewModel.user != null &&
                          widget.viewModel.user.role == "admin"
                      ? Container(
                          height: 55,
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AddProductView(
                                                  category: widget.category)));
                                },
                                child: Container(
                                  height: 45.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                    color: AppTheme().appTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add Product',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AddSubCategoryView(
                                                  category: widget.category)));
                                },
                                child: Container(
                                  height: 45.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  decoration: BoxDecoration(
                                    color: AppTheme().appTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add subCategory',
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
                      : Container()
                ],
              ),
            ),
    );
  }

  showAlertDialog(BuildContext context, Product product) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        widget.viewModel.deleteProduct(product.productId, "products/${product.productId}",product,widget.category);
        Navigator.pop(context);
      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Alert"),
      content: Text("Are you sure you want delete"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

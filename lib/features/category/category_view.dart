import 'package:easy_buy/features/category/subcategory_view.dart';
import 'package:easy_buy/features/settings/theme.dart';
import 'package:easy_buy/features/widget/list_view.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'category_view_model.dart';

class CategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CategoryViewModel>(
      distinct: true,
      converter: (store) => CategoryViewModel.fromStore(store),
      builder: (_, viewModel) => _CategoryViewContent(
        viewModel: viewModel,
      ),
    );
  }
}

class _CategoryViewContent extends StatefulWidget {
  CategoryViewModel viewModel;

  _CategoryViewContent({Key key, this.viewModel}) : super(key: key);

  @override
  _CategoryViewState createState() => _CategoryViewState();
}
class _CategoryViewState extends State<_CategoryViewContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    widget.viewModel.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: MyListView(
        report: this.widget.viewModel.getCategoriesReport,
        listSize: widget.viewModel.categories.length,
        listBuilder: GridView.builder(
          itemCount: widget.viewModel.categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ( MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 3),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap:  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SubcategoryView(category:  widget.viewModel.categories[index])));
              },
              child: new Card(
                elevation: 2,
                margin: EdgeInsets.all(8.0),
                color: Colors.white,
                child: Column(
                  children: [
                    Image.network(
                      widget.viewModel.categories[index].img,
                      height: 120,
                      fit: BoxFit.fitWidth,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.viewModel.categories[index].name,
                            style: TextStyle(fontSize: 16),
                          ),
                          widget.viewModel.user!=null &&widget.viewModel.user.role == "admin"
                              ? InkWell(
                            onTap: () {
                              showAlertDialog(context,
                                  widget.viewModel.categories[index].catId);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 22,
                            ),
                          )
                              : Container(),
                        ],
                      ),
                      margin:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton:widget.viewModel.user!=null && widget.viewModel.user.role == "admin"
          ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/addCategory");
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: AppTheme().appTheme.primaryColor,
      )
          : Container(),
    );
  }
  showAlertDialog(BuildContext context, String id) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        widget.viewModel.deleteCategory(id, "categories/$id");
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
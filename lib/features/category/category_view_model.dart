import 'dart:io';
import 'package:easy_buy/data/model/category_model.dart';
import 'package:easy_buy/data/model/product_model.dart';
import 'package:easy_buy/data/model/user_model.dart';
import 'package:easy_buy/redux/action_report.dart';
import 'package:easy_buy/redux/app/app_state.dart';
import 'package:easy_buy/redux/realtime/realtime_actions.dart';
import 'package:redux/redux.dart';

class CategoryViewModel {
  final UserModel user;
  final Function() getCategories;
  final ActionReport getCategoriesReport;
  final List<CategoryModel> categories;
  final Function(CategoryModel, File) addCategory;
  final Function(String, String) deleteCategory;
  final ActionReport deleteCategoryReport;
  final ActionReport addCategoryReport;

  //Product
  final Function(CategoryModel) getProducts;
  final ActionReport getProductsReport;
  final ActionReport addProductReport;
  final Function(CategoryModel, File, Product) addProduct;
  final Function(String, String, Product, CategoryModel) deleteProduct;
  final ActionReport deleteProductReport;

  //subCategory
  final Function(CategoryModel) getSubCategory;
  final Function(CategoryModel subCat, File, CategoryModel category)
      addSubCategory;
  final ActionReport getSubCategoryReport;
  final ActionReport addSubCategoryReport;

  CategoryViewModel(
      {this.user,
      this.getCategories,
      this.getCategoriesReport,
      this.categories,
      this.addCategory,
      this.addCategoryReport,
      this.deleteCategory,
      this.deleteCategoryReport,
      this.getProducts,
      this.getProductsReport,
      this.getSubCategory,
      this.getSubCategoryReport,
      this.addSubCategory,
      this.addSubCategoryReport,
      this.addProduct,
      this.addProductReport,
      this.deleteProduct,
      this.deleteProductReport});

  static CategoryViewModel fromStore(Store<AppState> store) {
    return CategoryViewModel(
      user: store.state.authState.user,
      categories: store.state.realtimeState.categories.values.toList() ?? [],
      getCategoriesReport:
          store.state.realtimeState.status["GetCategoriesAction"],
      getCategories: () {
        store.dispatch(GetCategoriesAction());
      },
      addCategory: (category, i) {
        store.dispatch(AddCategoryAction(categoryModel: category, img: i));
      },
      addCategoryReport: store.state.realtimeState.status["AddCategoryAction"],
      deleteCategoryReport:
          store.state.realtimeState.status["DeleteCategoryAction"],
      deleteCategory: (id, path) {
        store.dispatch(DeleteCategoryAction(id: id, path: path));
      },
      deleteProductReport:
          store.state.realtimeState.status["DeleteProductAction"],
      deleteProduct: (id, path, product, cat) {
        store.dispatch(DeleteProductAction(
            id: id, path: path, product: product, categoryModel: cat));
      },
      getProductsReport: store.state.realtimeState.status["GetProductsAction"],
      getProducts: (category) {
        store.dispatch(GetProductsAction(category: category));
      },
      getSubCategoryReport:
          store.state.realtimeState.status["GetSubCategoryAction"],
      getSubCategory: (category) {
        store.dispatch(GetSubCategoryAction(category: category));
      },
      addSubCategoryReport:
          store.state.realtimeState.status["AddSubCategoryAction"],
      addSubCategory: (subCat, file, category) {
        store.dispatch(AddSubCategoryAction(
            category: category, file: file, subCat: subCat));
      },
      addProductReport: store.state.realtimeState.status["AddProductAction"],
      addProduct: (category, file, product) {
        store.dispatch(
            AddProductAction(category: category, file: file, product: product));
      },
    );
  }
}

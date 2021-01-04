import 'package:easy_buy/data/model/product_model.dart';

class CategoryModel {
  String name;
  String img;
  String catId;
  String id;
  List<CategoryModel> subCategories = [];
  List<Product> products = [];
  bool isSelected=false;

  CategoryModel(
      {this.name,
      this.catId,
        this.isSelected,
      this.img =
          "https://firebasestorage.googleapis.com/v0/b/easybuy-e7517.appspot.com/o/interface.png?alt=media&token=bfe100ea-71b2-4f50-a3d7-dae35ba5589b"});

  CategoryModel.fromJson(Map<dynamic, dynamic> map)
      : name = map['name'] ?? "",
        img = map['img'] ?? "",
        catId = map['catId'] ?? "";

  Map<String, dynamic> toJson() => {
        'name': name,
        'img': img,
        'catId': catId,
      };
}

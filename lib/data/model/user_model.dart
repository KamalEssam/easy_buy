class UserModel {
  String phone;
  String name;
  String email;
  String img;
  String role;
  String id;
  String address;

  UserModel(
      {
        this.phone = "",
      this.name = "",
      this.email = "",
      this.img = "https://firebasestorage.googleapis.com/v0/b/workers-38e63.appspot.com/o/user.png?alt=media&token=91a2e9af-ccdf-486d-8949-8c5ff2e11cd8",
      this.role = "client",
      this.address,
        this.id});

  UserModel.fromJson(Map<dynamic, dynamic> map)
      :
        phone = map['phone'].toString()??"",
        name = map['name'] ?? "",
        email = map['email'] ?? "",
        img = map['img'] ?? "",
        role = map['role'] ?? "",
        id = map['id'] ?? "",
        address = map['address'] ?? "";

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'name': name,
        'img': img,
        'email': email,
        'role': role,
        'address': address,
        'id': id,
      };
}

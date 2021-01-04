import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_buy/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  const AuthRepository();

  Future <UserModel> login(String email, String password) async {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    ).then((d) async{
      if(!d.user.emailVerified){
        var userReference =await FirebaseDatabase.instance.reference().child("users").child(d.user.uid).once();
        UserModel userData=  UserModel.fromJson(userReference.value);
        userData.id=userReference.key;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final JsonEncoder _encoder = new JsonEncoder();
        prefs.setString("user", _encoder.convert((userData.toJson())));
        prefs.setBool("isLogined", true);
        return userData;
      }
      return null;
    });
  }

  Future <UserModel> signup(String email, String password, UserModel user) async {
    UserModel updatedUser;
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ).then((d) async {
        DatabaseReference databaseReference =
         FirebaseDatabase.instance.reference().child("users").child(d.user.uid);
        await databaseReference.set(user.toJson());
        var userSnapshot = await databaseReference.once();
        updatedUser = UserModel.fromJson(userSnapshot.value);
        updatedUser.id=userSnapshot.key;
        final JsonEncoder _encoder = new JsonEncoder();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("user", _encoder.convert((updatedUser.toJson())));
        return updatedUser;
      });
  }

  Future<UserModel> updateUser(UserModel user ,File img) async {
    String id;
    id=FirebaseAuth.instance.currentUser.uid;
    if (img == null) {
      DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child("users").child(id);
      await databaseReference.update(user.toJson());
      var userSnapshot = await databaseReference.once();
      UserModel updatedUser = UserModel.fromJson(userSnapshot.value);
      final JsonEncoder _encoder = new JsonEncoder();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("user", _encoder.convert((updatedUser.toJson())));
      return UserModel.fromJson(userSnapshot.value);
    } else {
      StorageReference storageReference =
      FirebaseStorage().ref().child(img.toString());
      StorageUploadTask uploadTask = storageReference.putFile(img);
      StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
      user.img = await storageSnapshot.ref.getDownloadURL();
      DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child("users").child(id);
      await databaseReference.update(user.toJson());
      var userSnapshot = await databaseReference.once();
      UserModel updatedUser = UserModel.fromJson(userSnapshot.value);
      final JsonEncoder _encoder = new JsonEncoder();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("user", _encoder.convert((updatedUser.toJson())));
      return UserModel.fromJson(userSnapshot.value);
    }
  }

}


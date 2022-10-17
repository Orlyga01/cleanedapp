import 'dart:convert';

import 'package:cleanedapp/user/be_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharedor/common_functions.dart';

class FirebaseUserRepository {
  late String userid;
  late CollectionReference _userCollection;
  late DocumentReference? _dbUser;
  static final FirebaseUserRepository _dbUserRep =
      new FirebaseUserRepository._internal();
  FirebaseUserRepository._internal();
  factory FirebaseUserRepository({required String userid}) {
    _dbUserRep._userCollection = FirebaseFirestore.instance.collection("users");
    _dbUserRep.userid = userid;
    if (!userid.isEmptyBe) {
      _dbUserRep._dbUser = _dbUserRep._userCollection.doc(userid);
    }
    return _dbUserRep;
  }
  Future<BeUser?> add(BeUser user) async {
    // the user id will be the phone number
    try {
      await _userCollection.doc(user.id).set(user.toJson());
      setUserId = user.id;

      return user;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> delete(String userid) {
    return _userCollection.doc(userid).delete();
  }

  Future<BeUser?> get({String? id}) async {
    if (id == null && userid.isEmptyBe) {
      print("no user id provided");
      throw "error";
    }
    id = id ?? userid;

    try {
      DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        data['id'] = id;
        return BeUser.fromJson(data);
      }
      return null;
    } catch (e) {
      throw e;
    }
  }

  set setUserId(value) {
    userid = value;
    _dbUser = _userCollection.doc(value);
  }

  // Future<BeUser?> get(id) async {
  //   try {
  //     DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
  //     if (documentSnapshot.exists) {
  //       Map<String, dynamic> data =
  //           documentSnapshot.data() as Map<String, dynamic>;
  //       data['id'] = id;
  //       return BeUser.fromJson(data);
  //     }
  //     return null;
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  @override
  Future<void> update(String? id,
      [BeUser? user, String? fieldName, dynamic fieldValue]) {
    if (fieldName != null) {
      if (id == null) {
        print("----------error===========id was not passed to update");
        throw "no user id";
      }

      return _userCollection.doc(id).update({
        fieldName: fieldValue,
        "modifiedAt": DateTime.now().millisecondsSinceEpoch
      });
    } else {
      if (user == null) {
        print("----------error===========no user");
        throw "no user ";
      }

      user.modifiedAt = DateTime.now();
      return _userCollection.doc(user.id).update(user.toJson());
    }
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoreminder/util/appconst.dart';

class FireBase_Helper {

  SharedPreferences prefs;

  FireBase_Helper.initalize( ) {
    init();
  }
  Future init() async {
    prefs = await SharedPreferences.getInstance();
    return null;
  }


  //----------------------------------QUERY IN DB ---------------------------------//

  queryVersion() async
  {
    return await Firestore.instance
        .collection(VERSIONS)
        .document(UPDATEDVERSION)
        .get();
  }

}
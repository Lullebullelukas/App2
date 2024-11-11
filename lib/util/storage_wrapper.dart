import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 FlutterSecureStorage is not implemented for Web so we implement
 a wrapper around SharedPreferences and FlutterSecureStorage
 so we can ignore that in the code.

*/ 

// TODO: SharedPreferences might be deprecated in the future, see:
// https://pub.dev/packages/shared_preferences#sharedpreferences-vs-sharedpreferencesasync-vs-sharedpreferenceswithcache

class TokenStorageWrapper {
  static late FlutterSecureStorage secureStorage;
  static SharedPreferences? prefs;

  TokenStorageWrapper() {
    secureStorage = FlutterSecureStorage();
  }

  void write({String? key, dynamic value}) {
    if(key == null || value == null) {
      print("Cannot store null tokens");
      return;
    }
    if(!kIsWeb) {
      secureStorage.write(key: key, value: value.toString());
    }
    else {
      SharedPreferences.getInstance().then((prefs) => prefs.setString(key, value.toString()));
    }
  }
  
  Future<Map<String, String?>> readAll() async {
    if(!kIsWeb) {
      return secureStorage.readAll();
    }
    else {
      if(prefs == null)
        prefs = await SharedPreferences.getInstance();

      var map = {
        "access_token": prefs!.getString("access_token"),
        "refresh_token": prefs!.getString("refresh_token"),
        "expires": prefs!.getString("expires"),
      };
      return map;
    }
  }

  Future<String?> read(String key) async {
    if(!kIsWeb) {
      return secureStorage.read(key: key);
    }
    else {
      if(prefs == null)
        prefs = await SharedPreferences.getInstance();

      return prefs!.getString(key);
    }
  }

  Future<void> delete({String key = ""}) async {
    if(!kIsWeb) {
      secureStorage.delete(key: key);
    }
    else {
      if(prefs == null)
        prefs = await SharedPreferences.getInstance();

      prefs!.remove(key);
    }
  }

  /*void deleteAll() {
    if(!kIsWeb) {
      secureStorage.deleteAll();
    }
    else {
      SharedPreferences.getInstance().then((prefs) {
        prefs.remove("access_token");
        prefs.remove("refresh_token");
        prefs.remove("expires");
      });
    }
  }*/
}
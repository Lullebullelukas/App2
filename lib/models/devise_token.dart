import 'package:fsek_mobile/util/storage_wrapper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'devise_token.g.dart'; //generated JSON file

@JsonSerializable()
class DeviseToken {
  String? accessToken;
  String? uid;
  String? client;
  DateTime? expires;
  String? error;

  DeviseToken(
      {this.accessToken, this.uid, this.client, this.expires, this.error});

  // Static helper functions
  static void storeToken(TokenStorageWrapper storage, DeviseToken token) {
    storage.write(key: "access-token", value: token.accessToken);
    storage.write(key: "uid", value: token.uid);
    storage.write(key: "client", value: token.client);
    storage.write(key: "expires", value: token.expires.toString());
  }

  static void clearToken(TokenStorageWrapper storage) {
    storage.delete(key: "access-token");
    storage.delete(key: "uid");
    storage.delete(key: "client");
    storage.delete(key: "expires");
  }

  static Future<DeviseToken> getFromStorage(TokenStorageWrapper storage) async {
    DeviseToken token = DeviseToken();
    token.accessToken = await storage.read("access-token");
    if (token.accessToken == null) return DeviseToken();

    token.uid = await storage.read("uid");
    token.client = await storage.read("client");
    String? expires = await storage.read("expires");
    if (expires == null) return DeviseToken();

    token.expires = DateTime.tryParse(expires);
    return token;
  }

  static DeviseToken getFromHeaders(Map<String, String> headers) {
    return DeviseToken(
        accessToken: headers['access-token'],
        uid: headers['uid'],
        client: headers['client'],
        expires: timeConvert(headers["expiry"]));
  }

  static DateTime timeConvert(String? rubytimestring) {
    if (rubytimestring == null) return DateTime.now();

    int? time = int.tryParse(rubytimestring);
    if (time == null) return DateTime.now();

    int rubytime = int.parse(rubytimestring);
    return DateTime.fromMillisecondsSinceEpoch(rubytime * 1000);
  }

  factory DeviseToken.fromJson(Map<String, dynamic> json) =>
      _$DeviseTokenFromJson(json);

  Map<String, dynamic> toJson() => _$DeviseTokenToJson(this);
}

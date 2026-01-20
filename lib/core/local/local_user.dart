
class LocalUser {
  LocalUser({
    String? accessToken,
    String? name,
    String? password
  }) {
    _accessToken = accessToken;
    _name = name;
    _password = password;
  }

  LocalUser.fromJson(dynamic json) {
    _accessToken = json['access_token'];
    _name = json['name'];
    _password = json['password'];
  }

  String? _accessToken;
  String? _name;
  String? _password;

  String? get accessToken => _accessToken;

  String? get name => _name;

  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = _accessToken;
    map['name'] = _name;
    map['password'] = _password;
    return map;
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class AppRepo {
  final AuthManager _authManager;

  AppRepo._(this._authManager);

  static AppRepo? _instance;

  factory AppRepo.getInstance() {
    return _instance ??= AppRepo._(AuthManager.getInstance());
  }

  Future<bool> isLoggedIn() async {
    var id = await _authManager.getId();
    return id != null;
  }

  setId(int id) async {
    await _authManager.saveID(id);
  }

  int? id;
  getID() async {
    id = await _authManager.getId();
    return id;
  }
}

class AuthManager {
  AuthManager._();

  static AuthManager? _instance;

  factory AuthManager.getInstance() {
    return _instance ??= AuthManager._();
  }

  static const _TOKEN_KEY = "_TOKEN_KEY";

  Future<void> saveID(int id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove(_TOKEN_KEY);
    print(">>>>>>>>>>>> saveID $id");
    await sp.setInt(_TOKEN_KEY, id);
  }

  Future<int?> getId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    print(">>>>>>>>>>>> getID ${sp.getInt(_TOKEN_KEY)}");
    return sp.getInt(_TOKEN_KEY);
  }
}

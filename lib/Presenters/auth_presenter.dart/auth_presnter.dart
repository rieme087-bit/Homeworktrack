import '/models/auth_model.dart';

class AuthPresenter {
  final Authmodel _model = Authmodel();

  Future<String?> login(String email, String password) {
    return _model.login(email, password);
  }

  Future<String?> signUp(String email, String password) {
    return _model.signUp(email, password);
  }

  Future<void> logout() => _model.signOut();

  Stream authStateChanges() => _model.authStateChanges();

  String? getcurrentUserEmail() => _model.currentUser?.email;


  }





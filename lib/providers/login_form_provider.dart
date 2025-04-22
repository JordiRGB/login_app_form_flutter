import 'package:flutter/material.dart';

class LoginFormProviderScreen extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  //isLoading is a boolean variable that indicates whether the form is currently loading or not.
  bool _isLoading = false;

  bool get isloading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}

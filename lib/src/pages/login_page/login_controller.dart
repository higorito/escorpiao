import 'package:escorpionico_proj/src/pages/login_page/login_store.dart';
import 'package:flutter/material.dart';

class LoginController {
  final LoginStore _store;

  LoginController(this._store);

  GlobalKey<FormState> get formKey => _store.formKey;
  TextEditingController get emailController => _store.emailController;
  TextEditingController get passwordController => _store.passwordController;

  bool get isFormValid => _store.isFormValid;

  ValueNotifier<bool> get obscurePassword => _store.obscurePasswordNotifier;

  ValueNotifier<bool> get isLoading => _store.isLoadingNotifier;

  Future<void> validateForm() => _store.validateForm();

  void resetForm() => _store.resetForm();

  void dispose() => _store.dispose();

  Future<void> login(String email, String senha) => _store.login(email, senha);

  void register() => _store.register();

  void forgotPassword() => _store.forgotPassword();

  void togglePasswordVisibility() => _store.togglePasswordVisibility();

  


}
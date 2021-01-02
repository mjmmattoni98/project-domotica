import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError { invalid }

class ConfirmedPassword extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPassword.pure() : confPass = '', super.pure('');
  const ConfirmedPassword.dirty({String value = '', String password = ''}) : confPass = password, super.dirty(value);

  final String confPass;

  static final _passwordRegExp =
  RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  ConfirmedPasswordValidationError validator(String value) {
    return _passwordRegExp.hasMatch(value) && confPass == value
        ? null
        : ConfirmedPasswordValidationError.invalid;
  }
}
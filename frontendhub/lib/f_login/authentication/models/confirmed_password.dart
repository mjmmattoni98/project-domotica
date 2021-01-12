import 'package:formz/formz.dart';

enum ConfirmedPasswordValidationError { invalid }

class ConfirmedPassword extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPassword.pure() : password = '', super.pure('');
  const ConfirmedPassword.dirty({String value = '', String password = ''}) : password = password, super.dirty(value);

  final String password;

  @override
  ConfirmedPasswordValidationError validator(String value) {
    return this.password == value
        ? null
        : ConfirmedPasswordValidationError.invalid;
  }
}
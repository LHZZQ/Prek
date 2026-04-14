import 'package:flutter_test/flutter_test.dart';
import 'package:_2025_prek/signup.dart';

void main() {
  final validator = SignUpValidator();

  group('SignUpValidator Logic', () {
    test('validateEmail returns error when email is null', () {
      var result = validator.validateEmail(null);
      expect(result, 'Email is required');
    });

    test('validateEmail returns error when email is empty', () {
      var result = validator.validateEmail('');
      expect(result, 'Email is required');
    });

    test('validateEmail returns error string when format is invalid', () {
      var result = validator.validateEmail('wrongemail');
      expect(result, 'Enter a valid email');
    });

    test('validateEmail returns null when email is valid', () {
      var result = validator.validateEmail('test@gmail.com');
      expect(result, null);
    });

    test('validateEmail trims whitespace and still validates', () {
      var result = validator.validateEmail('  test@gmail.com  ');
      expect(result, null);
    });

    test('validatePassword returns error when password is null', () {
      var result = validator.validatePassword(null);
      expect(result, 'Password is required');
    });

    test('validatePassword returns error when password is empty', () {
      var result = validator.validatePassword('');
      expect(result, 'Password is required');
    });

    test('validatePassword returns error when invalid', () {
      var result = validator.validatePassword('123');
      expect(
        result,
        'Password must have a minimum of 1 lower case letter [a-z], a minimum of 1 upper case letter [A-Z], a minimum of 1 numeric character [0-9], a minimum of 1 special character: ~`!@#%^&*()-_+={}[]|:"<>,./?, and must be at least 10 characters',
      );
    });

    test('validatePassword returns null when valid', () {
      var result = validator.validatePassword('Kitty@5689');
      expect(result, null);
    });

    test('validatePassword returns error when do not haveuppercase', () {
      var result = validator.validatePassword('zzq@56890');
      expect(
        result,
        'Password must have a minimum of 1 lower case letter [a-z], a minimum of 1 upper case letter [A-Z], a minimum of 1 numeric character [0-9], a minimum of 1 special character: ~`!@#%^&*()-_+={}[]|:"<>,./?, and must be at least 10 characters',
      );
    });
  });
}

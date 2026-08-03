import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod_template/core/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    group('validateUsername', () {
      test('should return null for valid username', () {
        expect(Validators.validateUsername('validuser'), isNull);
        expect(Validators.validateUsername('user123'), isNull);
        expect(Validators.validateUsername('user_name'), isNull);
        expect(Validators.validateUsername('user-name'), isNull);
        expect(Validators.validateUsername('abc'), isNull);
      });

      test('should return error for empty username', () {
        expect(Validators.validateUsername(''), isNotNull);
        expect(Validators.validateUsername(null), isNotNull);
      });

      test('should return error for username less than 3 characters', () {
        expect(Validators.validateUsername('ab'), isNotNull);
        expect(Validators.validateUsername('a'), isNotNull);
      });

      test('should return error for username more than 30 characters', () {
        expect(
          Validators.validateUsername('a' * 31),
          isNotNull,
        );
      });

      test('should return error for username with invalid characters', () {
        expect(Validators.validateUsername('user name'), isNotNull);
        expect(Validators.validateUsername('user@name'), isNotNull);
        expect(Validators.validateUsername('user.name'), isNotNull);
        expect(Validators.validateUsername('user#name'), isNotNull);
      });
    });

    group('validatePassword', () {
      test('should return null for valid password', () {
        expect(Validators.validatePassword('Password123'), isNull);
        expect(Validators.validatePassword('MyP@ss123'), isNull);
        expect(Validators.validatePassword('Secure1Pass'), isNull);
      });

      test('should return error for empty password', () {
        expect(Validators.validatePassword(''), isNotNull);
        expect(Validators.validatePassword(null), isNotNull);
      });

      test('should return error for password less than 8 characters', () {
        expect(Validators.validatePassword('Pass1'), isNotNull);
        expect(Validators.validatePassword('Ab1'), isNotNull);
      });

      test('should return error for password without uppercase', () {
        expect(Validators.validatePassword('password123'), isNotNull);
        expect(Validators.validatePassword('mypass123'), isNotNull);
      });

      test('should return error for password without lowercase', () {
        expect(Validators.validatePassword('PASSWORD123'), isNotNull);
        expect(Validators.validatePassword('MYPASS123'), isNotNull);
      });

      test('should return error for password without number', () {
        expect(Validators.validatePassword('Password'), isNotNull);
        expect(Validators.validatePassword('MyPassword'), isNotNull);
      });
    });

    group('validateEmail', () {
      test('should return null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
        expect(Validators.validateEmail('user.name@company.co.uk'), isNull);
        expect(Validators.validateEmail('user+tag@domain.com'), isNull);
      });

      test('should return error for empty email', () {
        expect(Validators.validateEmail(''), isNotNull);
        expect(Validators.validateEmail(null), isNotNull);
      });

      test('should return error for invalid email format', () {
        expect(Validators.validateEmail('notanemail'), isNotNull);
        expect(Validators.validateEmail('missing@domain'), isNotNull);
        expect(Validators.validateEmail('@nodomain.com'), isNotNull);
        expect(Validators.validateEmail('spaces in@email.com'), isNotNull);
      });
    });

    group('validateRequired', () {
      test('should return null for non-empty value', () {
        expect(Validators.validateRequired('some value'), isNull);
        expect(Validators.validateRequired('a'), isNull);
      });

      test('should return error for empty value', () {
        expect(Validators.validateRequired(''), isNotNull);
        expect(Validators.validateRequired(null), isNotNull);
      });

      test('should use custom field name in error message', () {
        final error = Validators.validateRequired('', fieldName: 'Name');
        expect(error, contains('Name'));
      });
    });

    group('validateMinLength', () {
      test('should return null for value meeting minimum length', () {
        expect(Validators.validateMinLength('hello', 5), isNull);
        expect(Validators.validateMinLength('hello world', 5), isNull);
      });

      test('should return error for value below minimum length', () {
        expect(Validators.validateMinLength('hi', 5), isNotNull);
        expect(Validators.validateMinLength('', 5), isNotNull);
      });

      test('should use custom field name in error message', () {
        final error = Validators.validateMinLength('ab', 5, fieldName: 'Title');
        expect(error, contains('Title'));
        expect(error, contains('5'));
      });
    });

    group('validateMaxLength', () {
      test('should return null for value within maximum length', () {
        expect(Validators.validateMaxLength('hello', 10), isNull);
        expect(Validators.validateMaxLength('', 10), isNull);
        expect(Validators.validateMaxLength(null, 10), isNull);
      });

      test('should return error for value exceeding maximum length', () {
        expect(Validators.validateMaxLength('hello world', 5), isNotNull);
      });

      test('should use custom field name in error message', () {
        final error = Validators.validateMaxLength(
          'very long text',
          5,
          fieldName: 'Bio',
        );
        expect(error, contains('Bio'));
        expect(error, contains('5'));
      });
    });

    group('validatePhoneNumber', () {
      test('should return null for valid 10-digit phone number', () {
        expect(Validators.validatePhoneNumber('1234567890'), isNull);
        expect(Validators.validatePhoneNumber('(123) 456-7890'), isNull);
        expect(Validators.validatePhoneNumber('123-456-7890'), isNull);
      });

      test('should return error for empty phone number', () {
        expect(Validators.validatePhoneNumber(''), isNotNull);
        expect(Validators.validatePhoneNumber(null), isNotNull);
      });

      test('should return error for invalid phone number', () {
        expect(Validators.validatePhoneNumber('12345'), isNotNull);
        expect(Validators.validatePhoneNumber('abcdefghij'), isNotNull);
      });
    });

    group('validateUrl', () {
      test('should return null for valid URL', () {
        expect(Validators.validateUrl('https://example.com'), isNull);
        expect(Validators.validateUrl('http://test.com'), isNull);
        expect(Validators.validateUrl('https://sub.domain.com/path'), isNull);
      });

      test('should return error for empty URL', () {
        expect(Validators.validateUrl(''), isNotNull);
        expect(Validators.validateUrl(null), isNotNull);
      });

      test('should return error for invalid URL', () {
        expect(Validators.validateUrl('not a url'), isNotNull);
        expect(Validators.validateUrl('invalid'), isNotNull);
      });
    });

    group('validateConfirmation', () {
      test('should return null when values match', () {
        expect(
          Validators.validateConfirmation('password123', 'password123'),
          isNull,
        );
        expect(
          Validators.validateConfirmation('test@email.com', 'test@email.com'),
          isNull,
        );
      });

      test('should return error when values do not match', () {
        expect(
          Validators.validateConfirmation('password123', 'password456'),
          isNotNull,
        );
        expect(
          Validators.validateConfirmation('test@email.com', 'different@email.com'),
          isNotNull,
        );
      });

      test('should return error for empty confirmation', () {
        expect(
          Validators.validateConfirmation('', 'password123'),
          isNotNull,
        );
        expect(
          Validators.validateConfirmation(null, 'password123'),
          isNotNull,
        );
      });

      test('should use custom field name in error message', () {
        final error = Validators.validateConfirmation(
          'pass1',
          'pass2',
          fieldName: 'Password',
        );
        expect(error, contains('Password'));
      });
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:kataftools/kataftools.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() {
  group('FormValidator', () {
    group('emailValidator', () {
      group('Valid email addresses', () {
        test('accepts standard email format', () {
          final result = FormValidator.emailValidator('user@example.com');
          expect(result, isNull);
        });

        test('accepts email with subdomain', () {
          final result = FormValidator.emailValidator('user@mail.example.com');
          expect(result, isNull);
        });

        test('accepts email with dots in username', () {
          final result = FormValidator.emailValidator('first.last@example.com');
          expect(result, isNull);
        });

        test('accepts email with hyphens in username', () {
          final result = FormValidator.emailValidator('first-last@example.com');
          expect(result, isNull);
        });

        test('accepts email with underscores in username', () {
          final result = FormValidator.emailValidator('first_last@example.com');
          expect(result, isNull);
        });

        test('accepts email with numbers', () {
          final result = FormValidator.emailValidator('user123@example.com');
          expect(result, isNull);
        });

        test('accepts various TLDs', () {
          expect(FormValidator.emailValidator('user@example.co'), isNull);
          expect(FormValidator.emailValidator('user@example.org'), isNull);
          expect(FormValidator.emailValidator('user@example.net'), isNull);
          expect(FormValidator.emailValidator('user@example.io'), isNull);
        });

        test('accepts multiple subdomains', () {
          final result = FormValidator.emailValidator(
            'user@mail.server.example.com',
          );
          expect(result, isNull);
        });
      });

      group('Invalid email addresses', () {
        test('rejects email without @', () {
          final result = FormValidator.emailValidator('userexample.com');
          expect(result, 'Veuillez entrer une adresse e-mail valide.');
        });

        test('rejects email without domain', () {
          final result = FormValidator.emailValidator('user@');
          expect(result, 'Veuillez entrer une adresse e-mail valide.');
        });

        test('rejects email without username', () {
          final result = FormValidator.emailValidator('@example.com');
          expect(result, 'Veuillez entrer une adresse e-mail valide.');
        });

        test('rejects email with spaces', () {
          final result = FormValidator.emailValidator('user name@example.com');
          expect(result, 'Veuillez entrer une adresse e-mail valide.');
        });

        test('rejects email without TLD', () {
          final result = FormValidator.emailValidator('user@example');
          expect(result, 'Veuillez entrer une adresse e-mail valide.');
        });

        test('rejects email with invalid characters', () {
          final result = FormValidator.emailValidator('user#name@example.com');
          expect(result, 'Veuillez entrer une adresse e-mail valide.');
        });

        test('rejects email with double @', () {
          final result = FormValidator.emailValidator('user@@example.com');
          expect(result, 'Veuillez entrer une adresse e-mail valide.');
        });

        test('rejects email with single letter TLD', () {
          final result = FormValidator.emailValidator('user@example.c');
          expect(result, 'Veuillez entrer une adresse e-mail valide.');
        });

        test('rejects email with TLD too long', () {
          final result = FormValidator.emailValidator(
            'user@example.verylongtld',
          );
          expect(result, 'Veuillez entrer une adresse e-mail valide.');
        });
      });

      group('Required validation', () {
        test('returns error for null when isRequired is true', () {
          final result = FormValidator.emailValidator(null, isRequired: true);
          expect(result, '');
        });

        test('returns error for empty string when isRequired is true', () {
          final result = FormValidator.emailValidator('', isRequired: true);
          expect(result, '');
        });

        test('returns null for null when isRequired is false', () {
          final result = FormValidator.emailValidator(null, isRequired: false);
          expect(result, isNull);
        });

        test('returns null for empty string when isRequired is false', () {
          final result = FormValidator.emailValidator('', isRequired: false);
          expect(result, isNull);
        });

        test('validates email format even when isRequired is true', () {
          final result = FormValidator.emailValidator(
            'invalid',
            isRequired: true,
          );
          expect(result, 'Veuillez entrer une adresse e-mail valide.');
        });
      });

      group('Edge cases', () {
        test('handles whitespace-only string', () {
          final result = FormValidator.emailValidator('   ');
          expect(result, 'Veuillez entrer une adresse e-mail valide.');
        });

        test('rejects email starting with dot', () {
          final result = FormValidator.emailValidator('.user@example.com');
          expect(result, 'Veuillez entrer une adresse e-mail valide.');
        });

        test('rejects email ending with dot before @', () {
          final result = FormValidator.emailValidator('user.@example.com');
          expect(result, 'Veuillez entrer une adresse e-mail valide.');
        });
      });
    });

    group('phoneValidator', () {
      group('Valid phone numbers', () {
        test('accepts valid international phone number', () {
          const phone = PhoneNumber(isoCode: IsoCode.US, nsn: '2025550123');
          final result = FormValidator.phoneValidator(phone);
          expect(result, isNull);
        });

        test('accepts valid French phone number', () {
          const phone = PhoneNumber(isoCode: IsoCode.FR, nsn: '612345678');
          final result = FormValidator.phoneValidator(phone);
          expect(result, isNull);
        });

        test('accepts valid UK phone number', () {
          const phone = PhoneNumber(isoCode: IsoCode.GB, nsn: '7400123456');
          final result = FormValidator.phoneValidator(phone);
          expect(result, isNull);
        });

        test('accepts valid German phone number', () {
          const phone = PhoneNumber(isoCode: IsoCode.DE, nsn: '15112345678');
          final result = FormValidator.phoneValidator(phone);
          expect(result, isNull);
        });
      });

      group('Invalid phone numbers', () {
        test('rejects invalid phone number format', () {
          const phone = PhoneNumber(
            isoCode: IsoCode.US,
            nsn: '123', // Too short
          );
          final result = FormValidator.phoneValidator(phone);
          expect(result, 'Veuillez entrer un numéro de téléphone valide.');
        });

        test('rejects phone number with invalid length', () {
          const phone = PhoneNumber(
            isoCode: IsoCode.FR,
            nsn: '12345', // Too short for French number
          );
          final result = FormValidator.phoneValidator(phone);
          expect(result, 'Veuillez entrer un numéro de téléphone valide.');
        });
      });

      group('Required validation', () {
        test('returns error for null when isRequired is true', () {
          final result = FormValidator.phoneValidator(null, isRequired: true);
          expect(result, '');
        });

        test('returns error for empty nsn when isRequired is true', () {
          const phone = PhoneNumber(isoCode: IsoCode.US, nsn: '');
          final result = FormValidator.phoneValidator(phone, isRequired: true);
          expect(result, '');
        });

        test('returns null for null when isRequired is false', () {
          final result = FormValidator.phoneValidator(null, isRequired: false);
          expect(result, isNull);
        });

        test('validates phone format even when isRequired is true', () {
          const phone = PhoneNumber(isoCode: IsoCode.US, nsn: '123');
          final result = FormValidator.phoneValidator(phone, isRequired: true);
          expect(result, 'Veuillez entrer un numéro de téléphone valide.');
        });
      });

      group('Edge cases', () {
        test('handles empty PhoneNumber', () {
          const phone = PhoneNumber(isoCode: IsoCode.US, nsn: '');
          final result = FormValidator.phoneValidator(phone);
          expect(result, isNull);
        });
      });
    });

    group('numberValidator', () {
      group('Valid numbers', () {
        test('accepts valid French decimal with comma', () {
          final result = FormValidator.numberValidator('12,5');
          expect(result, isNull);
        });

        test('accepts integer', () {
          final result = FormValidator.numberValidator('42');
          expect(result, isNull);
        });

        test('accepts English decimal with dot', () {
          final result = FormValidator.numberValidator('12.5');
          expect(result, isNull);
        });

        test('accepts negative numbers', () {
          final result = FormValidator.numberValidator('-12,5');
          expect(result, isNull);
        });

        test('accepts zero', () {
          final result = FormValidator.numberValidator('0');
          expect(result, isNull);
        });

        test('accepts decimal with leading zero', () {
          final result = FormValidator.numberValidator('0,5');
          expect(result, isNull);
        });

        test('accepts large numbers', () {
          final result = FormValidator.numberValidator('999999,99');
          expect(result, isNull);
        });
      });

      group('Invalid numbers', () {
        test('returns error for non-numeric string when required', () {
          final result = FormValidator.numberValidator('abc', isRequired: true);
          expect(result, '');
        });

        test('returns error for text when required', () {
          final result = FormValidator.numberValidator(
            'not a number',
            isRequired: true,
          );
          expect(result, '');
        });

        test('returns null for invalid number when not required', () {
          final result = FormValidator.numberValidator(
            'abc',
            isRequired: false,
          );
          expect(result, isNull);
        });
      });

      group('Required validation', () {
        test('returns error for null when isRequired is true', () {
          final result = FormValidator.numberValidator(null, isRequired: true);
          expect(result, '');
        });

        test('returns error for empty string when isRequired is true', () {
          final result = FormValidator.numberValidator('', isRequired: true);
          expect(result, '');
        });

        test('returns null for null when isRequired is false', () {
          final result = FormValidator.numberValidator(null, isRequired: false);
          expect(result, isNull);
        });

        test('returns null for empty string when isRequired is false', () {
          final result = FormValidator.numberValidator('', isRequired: false);
          expect(result, isNull);
        });
      });

      group('Edge cases', () {
        test('handles whitespace with number', () {
          final result = FormValidator.numberValidator(' 12,5 ');
          expect(result, isNull);
        });

        test('handles whitespace-only when not required', () {
          final result = FormValidator.numberValidator('   ');
          expect(result, isNull);
        });

        test('handles very small decimals', () {
          final result = FormValidator.numberValidator('0,001');
          expect(result, isNull);
        });
      });
    });

    group('intValidator', () {
      group('Valid integers', () {
        test('accepts positive integer', () {
          final result = FormValidator.intValidator('42');
          expect(result, isNull);
        });

        test('accepts negative integer', () {
          final result = FormValidator.intValidator('-42');
          expect(result, isNull);
        });

        test('accepts zero', () {
          final result = FormValidator.intValidator('0');
          expect(result, isNull);
        });

        test('accepts large integer', () {
          final result = FormValidator.intValidator('999999');
          expect(result, isNull);
        });
      });

      group('Invalid integers', () {
        test('returns error for decimal when required', () {
          final result = FormValidator.intValidator('12.5', isRequired: true);
          expect(result, '');
        });

        test('returns error for French decimal when required', () {
          final result = FormValidator.intValidator('12,5', isRequired: true);
          expect(result, '');
        });

        test('returns error for non-numeric string when required', () {
          final result = FormValidator.intValidator('abc', isRequired: true);
          expect(result, '');
        });

        test('returns null for decimal when not required', () {
          final result = FormValidator.intValidator('12.5', isRequired: false);
          expect(result, isNull);
        });

        test('returns null for text when not required', () {
          final result = FormValidator.intValidator('abc', isRequired: false);
          expect(result, isNull);
        });
      });

      group('Required validation', () {
        test('returns error for null when isRequired is true', () {
          final result = FormValidator.intValidator(null, isRequired: true);
          expect(result, '');
        });

        test('returns error for empty string when isRequired is true', () {
          final result = FormValidator.intValidator('', isRequired: true);
          expect(result, '');
        });

        test('returns null for null when isRequired is false', () {
          final result = FormValidator.intValidator(null, isRequired: false);
          expect(result, isNull);
        });

        test('returns null for empty string when isRequired is false', () {
          final result = FormValidator.intValidator('', isRequired: false);
          expect(result, isNull);
        });
      });

      group('Edge cases', () {
        test('handles integer with whitespace', () {
          final result = FormValidator.intValidator(' 42 ');
          expect(result, isNull);
        });

        test('handles whitespace-only when not required', () {
          final result = FormValidator.intValidator('   ');
          expect(result, isNull);
        });

        test('rejects number with comma separator when required', () {
          final result = FormValidator.intValidator('1,234', isRequired: true);
          expect(result, '');
        });
      });
    });

    group('requiredValidator', () {
      test('returns error for null', () {
        final result = FormValidator.requiredValidator(null);
        expect(result, '');
      });

      test('returns error for empty string', () {
        final result = FormValidator.requiredValidator('');
        expect(result, '');
      });

      test('returns null for non-empty string', () {
        final result = FormValidator.requiredValidator('value');
        expect(result, isNull);
      });

      test('returns null for whitespace string', () {
        final result = FormValidator.requiredValidator('   ');
        expect(result, isNull);
      });

      test('returns null for single character', () {
        final result = FormValidator.requiredValidator('a');
        expect(result, isNull);
      });

      test('returns null for number string', () {
        final result = FormValidator.requiredValidator('0');
        expect(result, isNull);
      });

      test('returns null for special characters', () {
        final result = FormValidator.requiredValidator('!@#');
        expect(result, isNull);
      });
    });

    group('requiredDateValidator', () {
      test('returns error for null DateTime', () {
        final result = FormValidator.requiredDateValidator(null);
        expect(result, '');
      });

      test('returns null for valid DateTime', () {
        final date = DateTime(2025, 11, 3);
        final result = FormValidator.requiredDateValidator(date);
        expect(result, isNull);
      });

      test('returns null for past date', () {
        final date = DateTime(2020, 1, 1);
        final result = FormValidator.requiredDateValidator(date);
        expect(result, isNull);
      });

      test('returns null for future date', () {
        final date = DateTime(2030, 12, 31);
        final result = FormValidator.requiredDateValidator(date);
        expect(result, isNull);
      });

      test('returns null for current date', () {
        final date = DateTime.now();
        final result = FormValidator.requiredDateValidator(date);
        expect(result, isNull);
      });

      test('returns null for UTC date', () {
        final date = DateTime.utc(2025, 11, 3);
        final result = FormValidator.requiredDateValidator(date);
        expect(result, isNull);
      });

      test('returns null for midnight', () {
        final date = DateTime(2025, 11, 3, 0, 0, 0);
        final result = FormValidator.requiredDateValidator(date);
        expect(result, isNull);
      });

      test('returns null for end of day', () {
        final date = DateTime(2025, 11, 3, 23, 59, 59);
        final result = FormValidator.requiredDateValidator(date);
        expect(result, isNull);
      });
    });

    group('Integration tests', () {
      test('email validator works with form field pattern', () {
        // Simulate form validation where empty string is acceptable if not required
        String? value = '';
        final result = FormValidator.emailValidator(value, isRequired: false);
        expect(result, isNull);

        value = 'invalid-email';
        final result2 = FormValidator.emailValidator(value, isRequired: false);
        expect(result2, isNotNull);

        value = 'valid@email.com';
        final result3 = FormValidator.emailValidator(value, isRequired: false);
        expect(result3, isNull);
      });

      test('number validator chain with required', () {
        // First check required
        String? value = '';
        var result = FormValidator.requiredValidator(value);
        expect(result, '');

        // Then check number format
        value = '12,5';
        result = FormValidator.requiredValidator(value);
        expect(result, isNull);
        result = FormValidator.numberValidator(value, isRequired: true);
        expect(result, isNull);
      });

      test(
        'int validator rejects decimals but number validator accepts them',
        () {
          const value = '12.5';

          final intResult = FormValidator.intValidator(value, isRequired: true);
          expect(intResult, '');

          final numberResult = FormValidator.numberValidator(
            value,
            isRequired: true,
          );
          expect(numberResult, isNull);
        },
      );
    });
  });
}

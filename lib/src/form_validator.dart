import 'package:kataftools/src/utils.dart';
import 'package:phone_form_field/phone_form_field.dart';

class FormValidator {
  static String? emailValidator(String? value, {bool isRequired = false}) {
    if (isRequired && (value?.isEmpty ?? true)) {
      return 'Ce champ est requis.';
    }

    final regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if ((value ?? "").isNotEmpty && !regex.hasMatch(value!)) {
      return 'Veuillez entrer une adresse e-mail valide.';
    }

    return null;
  }

  static String? phoneValidator(PhoneNumber? value, {bool isRequired = false}) {
    if (isRequired && (value?.nsn.isEmpty ?? true)) {
      return 'Ce champ est requis.';
    }

    if (value != null && value.nsn.isNotEmpty && !value.isValid()) {
      return 'Veuillez entrer un numéro de téléphone valide.';
    }

    return null;
  }

  static String? numberValidator(String? value, {bool isRequired = false}) {
    if (isRequired && (value?.isEmpty ?? true)) {
      return 'Ce champ est requis.';
    }

    if (isRequired && tryParseFrenchDouble(value ?? "") == null) {
      return 'Veuillez entrer un nombre valide.';
    }

    return null;
  }

  static String? intValidator(String? value, {bool isRequired = false}) {
    if (isRequired && (value?.isEmpty ?? true)) {
      return 'Ce champ est requis.';
    }

    if (isRequired && int.tryParse(value ?? "") == null) {
      return 'Veuillez entrer un nombre entier valide.';
    }

    return null;
  }

  static String? requiredValidator(String? value) {
    if (value?.isEmpty ?? true) return 'Ce champ est requis.';
    return null;
  }

  static String? requiredDateValidator(DateTime? value) {
    if (value == null) return 'Ce champ est requis.';
    return null;
  }
}

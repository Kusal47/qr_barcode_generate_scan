import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';

class Validators {
  static String? checkFieldEmpty(String? fieldContent) {
    fieldContent!.trim();
    if (fieldContent.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? checkPhoneNumberField(PhoneNumber? fieldContent) {
    if (fieldContent == null) {
      return 'This field is required';
    } else if (fieldContent != null && fieldContent.number.isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  static String? checkPasswordField(String? fieldContent) {
    fieldContent!.trim();
    if (fieldContent.isEmpty) {
      return 'This field is required';
    } else if (fieldContent.length < 8) {
      return 'The password should be at least 8 digits';
    }

    return null;
  }

  static String? checkSignUpPasswordField(String? fieldContent) {
    if (fieldContent == null || fieldContent.trim().isEmpty) {
      return 'This field is required';
    }

    String password = fieldContent.trim();

    if (password.length < 8) {
      return 'The password should be at least 8 characters';
    } else if (password.length > 15) {
      return 'The password should be at most 15 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'The password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'The password must contain at least one special character';
    }

    return null;
  }

  static String? checkConfirmPassword(String? password, String? fieldContent) {
    var checkPassword = checkPasswordField(fieldContent);
    if (checkPassword != null) {
      return checkPassword;
    }

    if (password != fieldContent!) {
      log("The passwords are  $password ====> $fieldContent");
      return "Password does not match";
    }
    return null;
  }

  static String? checkEmailField(String? fieldContent) {
    fieldContent!.trim();
    if (fieldContent.isEmpty) {
      return 'This field is required';
    } else if (!GetUtils.isEmail(fieldContent.trim())) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? checkDropdownField(String? fieldContent) {
    fieldContent!.trim();
    if (fieldContent.isEmpty) {
      return 'Please select atleast one';
    } else {
      return null;
    }
  }

  static String? checkUrlField(String? fieldContent) {
    if (fieldContent == null || fieldContent.trim().isEmpty) {
      return 'This field is required';
    }

    final trimmed = fieldContent.trim();

    final urlRegex = RegExp(
      r'^(https?:\/\/)?' // optional http/https
      r'([a-zA-Z0-9-]+\.)+' // subdomains
      r'([a-zA-Z]{2,})' // TLD
      r'(\/[^\s]*)?$', // optional path
    );

    if (!urlRegex.hasMatch(trimmed)) {
      return 'Invalid URL address';
    }

    return null;
  }
}

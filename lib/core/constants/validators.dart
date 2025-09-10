import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';

class Validators {
  static String? checkFieldEmpty(String? fieldContent) {
    fieldContent = fieldContent?.trim();
    if (fieldContent == null || fieldContent.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? checkPhoneNumberField(PhoneNumber? fieldContent) {
    if (fieldContent == null || fieldContent.number.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? checkPasswordField(String? fieldContent) {
    fieldContent = fieldContent?.trim();
    if (fieldContent == null || fieldContent.isEmpty) {
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

    if (password != fieldContent) {
      log("The passwords are  $password ====> $fieldContent");
      return "Password does not match";
    }
    return null;
  }

  static String? checkEmailField(String? fieldContent) {
    fieldContent = fieldContent?.trim();
    if (fieldContent == null || fieldContent.isEmpty) {
      return 'This field is required';
    } else if (!GetUtils.isEmail(fieldContent.trim())) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? checkDropdownField(String? fieldContent) {
    fieldContent = fieldContent?.trim();
    if (fieldContent == null || fieldContent.isEmpty) {
      return 'Please select at least one';
    }
    return null;
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

  // ================= Barcode Validations ================= //

  static String? validateCode128(String? val) {
    val = val?.trim();
    if (val == null || val.isEmpty) return "Field cannot be empty";
    if (!RegExp(r'^[\x00-\x7F]*$').hasMatch(val)) return "Invalid characters for Code 128";
    return null;
  }

  static String? validateCode39(String? val) {
    val = val?.trim();
    if (val == null || val.isEmpty) return "Field cannot be empty";
    if (!RegExp(r'^[0-9A-Z \-.\$/\+%]*$').hasMatch(val)) return "Invalid characters for Code 39";
    return null;
  }

  static String? validateCode93(String? val) {
    val = val?.trim();
    if (val == null || val.isEmpty) return "Field cannot be empty";
    if (!RegExp(r'^[\x00-\x7F]*$').hasMatch(val)) return "Invalid characters for Code 93";
    return null;
  }

  static String? validateCodabar(String? val) {
    val = val?.trim();
    if (val == null || val.isEmpty) return "Field cannot be empty";
    if (!RegExp(r'^[0-9A-D\-\$\:/\.\+]*$').hasMatch(val)) return "Invalid characters for Codabar";
    return null;
  }

  static String? validateITF(String? val) {
    val = val?.trim();
    if (val == null || val.isEmpty) return "Field cannot be empty";
    if (!RegExp(r'^\d+$').hasMatch(val)) return "Only digits allowed";
    if (val.length % 2 != 0) return "Please enter an even number of digits";
    return null;
  }

  static String? validateEAN8(String? val) {
    val = val?.trim();
    if (val == null || val.length != 8) return "Enter exactly 8 digits";
    if (!RegExp(r'^\d+$').hasMatch(val)) return "Only digits allowed";
    // checksum
    int sum = 0;
    for (int i = 0; i < 7; i++) {
      int n = int.parse(val[i]);
      sum += (i % 2 == 0) ? n * 3 : n;
    }
    int checksum = (10 - (sum % 10)) % 10;
    if (checksum != int.parse(val[7])) return "Invalid checksum";
    return null;
  }

  static String? validateEAN13(String? val) {
    val = val?.trim();
    if (val == null || val.length != 13) return "Enter exactly 13 digits";
    if (!RegExp(r'^\d+$').hasMatch(val)) return "Only digits allowed";
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      int n = int.parse(val[i]);
      sum += (i % 2 == 0) ? n : n * 3;
    }
    int checksum = (10 - (sum % 10)) % 10;
    if (checksum != int.parse(val[12])) return "Invalid checksum";
    return null;
  }

  static String? validateUPCA(String? val) {
    val = val?.trim();
    if (val == null || val.length != 12) return "Enter exactly 12 digits";
    if (!RegExp(r'^\d+$').hasMatch(val)) return "Only digits allowed";
    int sum = 0;
    for (int i = 0; i < 11; i++) {
      int n = int.parse(val[i]);
      sum += (i % 2 == 0) ? n * 3 : n;
    }
    int checksum = (10 - (sum % 10)) % 10;
    if (checksum != int.parse(val[11])) return "Invalid checksum";
    return null;
  }

  static String? validateUPCE(String? val) {
    val = val?.trim();
    if (val == null || val.length != 8) return "Enter exactly 8 digits";
    if (!RegExp(r'^\d+$').hasMatch(val)) return "Only digits allowed";
    int sum = 0;
    for (int i = 0; i < 6; i++) {
      int n = int.parse(val[i]);
      sum += (i % 2 == 0) ? n * 3 : n;
    }
    int checksum = (10 - (sum % 10)) % 10;
    if (checksum != int.parse(val[7])) return "Invalid checksum";
    return null;
  }
}

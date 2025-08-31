import 'dart:developer';

String extractErrorMessage(Map<String, dynamic> responseData) {
  try {
    // Top-level non_field_errors
    final nonFieldErrors = responseData['non_field_errors'];
    if (nonFieldErrors is List && nonFieldErrors.isNotEmpty) {
      return nonFieldErrors[0].toString();
    } else if (nonFieldErrors is String) {
      return nonFieldErrors;
    }

    // Check under 'errors' object
    final errors = responseData['errors'];
    if (errors is Map<String, dynamic>) {
      final innerNonField = errors['non_field_errors'];
      if (innerNonField is List && innerNonField.isNotEmpty) {
        return innerNonField[0].toString();
      } else if (innerNonField is String) {
        return innerNonField;
      }

      if (errors['username'] is List && errors['username'].isNotEmpty) {
        return errors['username'][0].toString();
      }
      if (errors['email'] is List && errors['email'].isNotEmpty) {
        return errors['email'][0].toString();
      }
      if (errors['phone_number'] is List && errors['phone_number'].isNotEmpty) {
        return errors['phone_number'][0].toString();
      }
    }

    // Top-level password error
    final passwordErrors = responseData['password'];
    if (passwordErrors is List && passwordErrors.isNotEmpty) {
      return passwordErrors[0].toString();
    }

    // Deep nested 'data.message'
    if (responseData['data'] is Map &&
        responseData['data']['message'] != null &&
        responseData['data']['message'].toString().isNotEmpty) {
      return responseData['data']['message'].toString();
    }

    // Fallback to top-level message
    if (responseData['message'] != null) {
      return responseData['message'].toString();
    }
  } catch (e, st) {
    log("Error parsing extractErrorMessage: $e\n$st");
  }

  return 'Something went wrong';
}

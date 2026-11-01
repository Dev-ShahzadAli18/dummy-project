String? emailValidation(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Enter your email";
  }

  if (!value.contains("@gmail.com")) {
    return "Enter a valid email";
  }

  return null;
}

String? passwordValidation(String? value) {
  if (value == null || value.isEmpty) {
    return "Enter your password";
  }

  if (value.length < 6) {
    return "Password must be at least 6 characters";
  }

  return null;
}

String? nameValidation(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Enter your name";
  }

  if (value.trim().length < 3) {
    return "Name must be at least 3 characters";
  }

  return null;
}

String? confirmPasswordValidation(String? value, String? password) {
  if (value == null || value.isEmpty) {
    return "Confirm your password";
  }

  if (value != password) {
    return "Passwords do not match";
  }

  return null;
}

String? phoneValidation(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter phone number';
  }
  if (!RegExp(r'^[0-9]{11}$').hasMatch(value.trim())) {
    return 'Enter a valid 11-digit phone number';
  }
  return null;
}

String? addressValidation(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your address';
  }
  return null;
}

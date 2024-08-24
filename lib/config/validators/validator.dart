class Validators {
  static String? emailUsernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa un correo o nombre de usuario';
    }
    if (value.contains(' ')) {
      return "El correo no debe contener espacios";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Ingresa un correo';
    }
    if (!value.contains('@')) {
      return "Tu correo debe tener '@'";
    }
    if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value)) {
      return "Ingrese un correo válido";
    }
    if (value.contains(' ')) {
      return "El correo no debe contener espacios";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    if (value.contains(' ')) {
      return "La contraseña no debe contener espacios";
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value!.isEmpty) {
      return 'El nombre de usuario es obligatorio';
    }
    if (value.contains(' ')) {
      return "El nombre de usuario no debe contener espacios";
    }
    return null;
  }

  static String? validateBirth(String? value) {
    if (value!.isEmpty) {
      return 'La fecha de nacimiento es obligatoria';
    }
    final dataRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dataRegex.hasMatch(value)) {
      return 'La fecha de nacimiento no es válida';
    }
    final parts = value.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return 'La fecha de nacimiento no es válida';
    }

    if (day < 1 || day > 31) {
      return 'El día debe estar entre 1 y 31';
    }

    if (month < 1 || month > 12) {
      return 'El mes debe estar entre 1 y 12';
    }

    if (year < 1900 || year > DateTime.now().year) {
      return 'El año no es válido';
    }

    if (DateTime(year, month, day).isAfter(DateTime.now())) {
      return 'La fecha de nacimiento no puede ser mayor a la fecha actual';
    }

    if (DateTime(year, month, day).isBefore(DateTime(1900))) {
      return 'La fecha de nacimiento no puede ser menor a 1900';
    }

    final now = DateTime.now();
    final age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      return 'Debes ser mayor de edad';
    }
    if (age < 18) {
      return 'Debes ser mayor de edad';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value!.isEmpty) {
      return 'El teléfono es obligatorio';
    }
    if (value.length < 10) {
      return 'El teléfono debe tener al menos 10 dígitos';
    }
    if (value.contains(' ')) {
      return "El teléfono no debe contener espacios";
    }
    return null;
  }

  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Selecciona tu género';
    }
    return null;
  }

  static String? validateWeightUnit(String? value) {
    if (value == null || value.isEmpty) {
      return 'Selecciona la unidad de peso';
    }
    return null;
  }

  static String? validateHeightUnit(String? value) {
    if (value == null || value.isEmpty) {
      return 'Selecciona la unidad de altura';
    }
    return null;
  }

  static String? validatePrivacyPolicy(bool value) {
    if (!value) {
      return 'Debes aceptar las políticas de privacidad';
    }
    return null;
  }

  static String? validateTermsAndConditions(bool value) {
    if (!value) {
      return 'Debes aceptar los términos y condiciones';
    }
    return null;
  }
}

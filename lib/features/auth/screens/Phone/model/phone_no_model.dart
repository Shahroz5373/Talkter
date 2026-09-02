import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNoModel {
  PhoneNumber number;
  String phone = '';
  bool isValid = false;

  PhoneNoModel({required this.number});

  void onInputChanged(PhoneNumber num) {
    number = num;
    phone = num.phoneNumber ?? '';
  }

  void onInputValidated(bool value) {
    isValid = value;
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number required";
    }
    if (!isValid) {
      return "Invalid phone number";
    }
    return null;
  }

  void onSaved(PhoneNumber num) {
    number = num;
    phone = num.phoneNumber ?? '';
  }

  bool get canSubmit => phone.isNotEmpty && isValid;
}

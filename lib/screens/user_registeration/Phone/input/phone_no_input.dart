import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:talkter/screens/user_registeration/Phone/controller/phone_controller.dart';

class RegisterPhone extends StatefulWidget {
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<bool> onValidationChanged;
  // final ValueChanged<int> numberLength;

  const RegisterPhone({
    super.key,
    required this.onPhoneChanged,
    required this.onValidationChanged,
    // required this.numberLength,
  });

  @override
  State<RegisterPhone> createState() => _RegisterPhoneState();
}

class _RegisterPhoneState extends State<RegisterPhone> {
  final TextEditingController _controller = TextEditingController();

  final PhoneController phoneController = PhoneController(
    number: PhoneNumber(isoCode: 'PK'),
  );

  // cleans the text controller mem
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: phoneController.isValid
              ? const Color.fromARGB(255, 61, 187, 65)
              : Colors.white,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          InternationalPhoneNumberInput(
            initialValue: phoneController.number,
            textFieldController: _controller,

            keyboardType: TextInputType.phone,
            formatInput: true,
            maxLength: 15,
            autoValidateMode: AutovalidateMode.onUnfocus,
            ignoreBlank: false,

            cursorColor: Colors.white.withValues(alpha: 0.6),
            textStyle: const TextStyle(color: Colors.white),

            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              showFlags: true,
              useEmoji: true,
              useBottomSheetSafeArea: true,
            ),

            inputDecoration: const InputDecoration(
              hintText: "Enter phone number",
              hintStyle: TextStyle(color: Color.fromARGB(255, 203, 200, 200)),
              contentPadding: EdgeInsets.only(bottom: 10),
              border: InputBorder.none,
            ),

            onInputChanged: (PhoneNumber phoneNum) {
              phoneController.onInputChanged(phoneNum);
              widget.onPhoneChanged(phoneController.phone);
            },

            onInputValidated: (value) {
              phoneController.onInputValidated(value);
              setState(() => phoneController.isValid = value);
              widget.onValidationChanged(value);
            },

            validator: phoneController.validator,
            onSaved: phoneController.onSaved,
          ),

          Positioned(
            top: 10,
            bottom: 10,
            left: 93,
            child: Container(width: 1.5, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

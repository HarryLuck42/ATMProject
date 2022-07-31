import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hints;
  final TextEditingController textEditingController;
  final TextInputType? inputType;
  final int? maxLength;
  final Function(String)? onChanged;
  final bool isPassword;
  const CustomField(
      {Key? key,
      required this.hints,
      required this.textEditingController,
      this.inputType,
      this.maxLength,
      this.onChanged,
      this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: textEditingController,
      keyboardType: inputType ?? TextInputType.text,
      style: const TextStyle(
        color: Colors.black,
      ),
      maxLength: maxLength,
      obscureText: isPassword,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: Colors.grey, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: Colors.grey, width: 1)),
          hintStyle: const TextStyle(color: Colors.grey),
          hintText: hints,
          filled: true,
          fillColor: Colors.white),
    );
  }
}

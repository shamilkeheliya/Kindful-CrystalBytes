import 'package:flutter/material.dart';

const kMainGreen = Color(0xFF59E287);
const kMainPurple = Color(0xFF4840B8);

const kCardsPadding = EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0);
const kCardsInsidePadding = EdgeInsets.all(15);

const kTextFieldPadding = EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0);

InputDecoration kTextInputDecoration(label, isValidate) {
  return InputDecoration(
    labelText: label,
    errorText: isValidate ? 'Field Cannot Be Empty' : null,
    border: const OutlineInputBorder(),
    floatingLabelStyle: const TextStyle(
      color: kMainPurple,
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: kMainPurple,
      ),
    ),
  );
}

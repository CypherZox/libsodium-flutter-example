import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {super.key, required this.controller, required this.hintText});
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        onFieldSubmitted: (val) async {},
        onChanged: (_) async {},
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        obscureText: false,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          filled: false,
          hintText: hintText,
          hintStyle: GoogleFonts.playfairDisplay(
              fontSize: 12, fontWeight: FontWeight.w200, color: Colors.black38),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 0.5,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
          ),
        ),
        style: GoogleFonts.playfairDisplay(
            fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black));
  }
}

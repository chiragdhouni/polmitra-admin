import 'package:flutter/material.dart';

class TextUtility {
  static TextStyle getBoldStyle(double fontSize, {Color color = Colors.white}) {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize, color: color);
  }

  static TextStyle getStyle(double fontSize, {Color color = Colors.black}) {
    return TextStyle(fontWeight: FontWeight.w500, fontSize: fontSize, color: color);
  }

  static OutlineInputBorder getBorderStyle(){
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Colors.grey));
  }

  static Widget getTextWithBoldAndPlain(String boldText, String plainText,
      {double boldTextSize = 15,
        double plainTextSize = 15,
        Color boldTextColour = Colors.black,
        Color plainTextColour = Colors.black}) {
    return RichText(
        text: TextSpan(children: [
          TextSpan(text: "$boldText:", style: TextUtility.getBoldStyle(boldTextSize, color: boldTextColour)),
          const WidgetSpan(
              child: SizedBox(
                width: 4,
              )),
          TextSpan(
            text: plainText,
            style: TextStyle(color: plainTextColour, fontSize: plainTextSize),
          )
        ]));
  }
}

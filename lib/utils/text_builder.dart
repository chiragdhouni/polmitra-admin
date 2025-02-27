import 'package:flutter/material.dart';
import 'package:polmitra_admin/utils/app_colors.dart';

class TextBuilder {
  static Text getText(
      {required String text,
      double fontSize = 20,
      Color color = AppColors.normalBlack,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.start,
      TextOverflow overflow = TextOverflow.ellipsis,
      int? maxLines}) {
    return Text(text,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          overflow: overflow,
          fontWeight: fontWeight,
        ));
  }

  static TextStyle getTextStyle(
      {double fontSize = 20,
      Color color = AppColors.normalBlack,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.start,
      TextOverflow overflow = TextOverflow.ellipsis}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        overflow: overflow,
        fontWeight: fontWeight);
  }
}

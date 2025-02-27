import 'package:flutter/material.dart';
import 'package:polmitra_admin/utils/app_colors.dart';

class BorderProvider {
  static OutlineInputBorder createBorder(
      {Color color = AppColors.vibrantSaffron, double width = 2.0}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }

  static UnderlineInputBorder createUnderlineBorder(
      {Color color = AppColors.vibrantSaffron, double width = 2.0}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }
}

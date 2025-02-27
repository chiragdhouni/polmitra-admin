import 'package:flutter/material.dart';
import 'package:polmitra_admin/utils/app_colors.dart';

class IconBuilder {
  static IconButton buildButton({
    required IconData icon,
    Color color = AppColors.normalBlack,
    void Function()? onPressed,
    double size = 15,
    ButtonStyle? buttonStyle,
  }) {
    return IconButton(
      style: buttonStyle,
      onPressed: onPressed ?? () {},
      icon: Icon(icon, color: color, size: size),
    );
  }
}

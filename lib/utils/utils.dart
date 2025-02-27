import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:polmitra_admin/utils/text_builder.dart';

import 'app_colors.dart';
import 'text_utility.dart';

showToast({String msg = ""}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      fontSize: 16.0);
}

getBorder() {
  return const BorderSide(width: 0.1, color: Colors.grey);
}

getOutLineBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.greyColor, width: 0.2),
  );
}

commonBtn(
    {String text = "Next",
    Color? bgColor,
    bool isEnable = false,
    required Function calll,
    double width = 140}) {
  bgColor = bgColor ?? AppColors.blueDarkShade;
  return GestureDetector(
    onTap: isEnable
        ? () {
            calll.call();
          }
        : null,
    child: Material(
      elevation: 10,
      child: Container(
          height: 40,
          width: width,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.blueDarkShade, width: 2),
              color: isEnable ? bgColor : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Center(
              child: Text(
            text,
            style: TextUtility.getStyle(14,
                color: isEnable ? Colors.white : Colors.black),
          ))),
    ),
  );
}

commonIconBtn(
    {String text = "Next",
    Icon? icon,
    Color? bgColor,
    bool isEnable = false,
    required Function calll,
    double width = 140}) {
  bgColor = bgColor ?? AppColors.blueDarkShade;
  return GestureDetector(
    onTap: () {
      calll.call();
    },
    child: Container(
        height: 35,
        // width: width,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.blueDarkShade, width: 2),
            color: isEnable ? bgColor : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Center(
            child: Row(
          children: [
            if (icon != null)
              Container(padding: const EdgeInsets.only(right: 8), child: icon),
            Text(
              text,
              style: TextUtility.getStyle(16,
                  color: isEnable ? Colors.white : Colors.black),
            ),
          ],
        ))),
  );
}

commonSearchArea(
    {required String title,
    String hint = "Next",
    required TextEditingController textController,
    required Function onSubmit}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextUtility.getBoldStyle(13, color: Colors.black)),
      Container(
        margin: const EdgeInsets.only(top: 6),
        child: SizedBox.fromSize(
          size: const Size(600, 42),
          child: TextField(
            textAlignVertical: TextAlignVertical.bottom,
            maxLines: 1,
            minLines: 1,
            onChanged: (text) {
              onSubmit.call(textController.text.trim());
            },
            onSubmitted: (text) {
              onSubmit.call(textController.text.trim());
            },
            controller: textController,
            decoration: InputDecoration(
                fillColor: Colors.white,
                border: InputBorder.none,
                focusColor: Colors.white,
                filled: true,
                hintText: hint,
                suffixIcon: InkWell(
                  onTap: () {
                    onSubmit.call(textController.text.trim());
                  },
                  child: const Icon(
                    Icons.search,
                    color: Color(0xFF707070),
                  ),
                ),
                enabledBorder: TextUtility.getBorderStyle(),
                disabledBorder: TextUtility.getBorderStyle(),
                errorBorder: TextUtility.getBorderStyle(),
                focusedBorder: TextUtility.getBorderStyle(),
                focusedErrorBorder: TextUtility.getBorderStyle()),
          ),
        ),
      ),
    ],
  );
}

/// date picker
Widget datePicker(
    {required Function onClick,
    String title = "From Date",
    required TextEditingController datePickerTextController}) {
  String dateText = datePickerTextController.text;

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      TextBuilder.getText(text: "Login"),
      // const SizedBox(height: 10),
      TextFormField(
        controller: datePickerTextController,
        decoration: InputDecoration(
            constraints: const BoxConstraints(
                maxWidth: 200, minWidth: 150, minHeight: 40, maxHeight: 45),
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
            hintText: dateText.isNotEmpty ? dateText : "Select Date"),
        readOnly: true,
        onTap: () {
          onClick.call();
        },
        onChanged: (value) {},
      )
    ],
  );
}

import 'package:flutter/cupertino.dart';

/// DataStore class
/// 1. Used to store static data
class DataStore {

  static const BoxConstraints commonTextFieldConstraints =
  BoxConstraints(maxWidth: 260, minWidth: 180, minHeight: 35, maxHeight: 60);

  static const BoxConstraints commonTextAreaConstaints =
  BoxConstraints(maxWidth: 260, minWidth: 180, minHeight: 70, maxHeight: 100);

  static const BoxConstraints commonDisabledFieldConstraints =
  BoxConstraints(maxWidth: 250, minWidth: 150, minHeight: 40, maxHeight: 45);
}

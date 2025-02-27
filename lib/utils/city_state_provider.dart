import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:polmitra_admin/models/indian_state.dart';

class CityStateProvider {
  static final CityStateProvider _instance = CityStateProvider._internal();
  List<IndianState>? _states;
  bool _isLoading = true;
  String? _error;

  factory CityStateProvider() {
    return _instance;
  }

  CityStateProvider._internal() {
    _loadStates();
  }

  Future<void> _loadStates() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/states_cities.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _states = jsonList
          .map<IndianState>((json) => IndianState.fromJson(json))
          .toList();
    } catch (e) {
      _error = 'Failed to load states: $e';
    } finally {
      _isLoading = false;
    }
  }

  Future<List<IndianState>> get states async {
    if (_isLoading) {
      // Wait until loading completes
      await Future.delayed(const Duration(
          milliseconds: 100)); // Small delay to allow async operation
      return states; // Recursive call to get the states after loading
    } else if (_error != null) {
      throw Exception(_error);
    } else if (_states == null) {
      throw Exception('States not loaded');
    }
    return _states!;
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
}

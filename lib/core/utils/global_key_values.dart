// ignore_for_file: unnecessary_getters_setters

class GlobalKeyValues {
  static Map<String, dynamic>? _settings;

  static Map<String, dynamic>? get settings => _settings;
  static set settings(Map<String, dynamic>? value) {
    _settings = value;
  }
}

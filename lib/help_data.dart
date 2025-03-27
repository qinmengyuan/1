import 'dart:convert';
import 'dart:io';
class HelpDataManager {
  static final Map<int, String> _helpDatabase = {
    1: "I need help. I feel dizzy.",
    2: "I can't talk.",
    3: "I can't walk.",
    4: "I can't hear you.",
    5: "Keep going",
    6: "Back",
    7: "I am fine",
    8: "Normal",
    9: "Info",
    10: "Info",
    11: "Info",
    12: "Info",
  };

  static String getHelpMessage(int number) {
    return _helpDatabase[number] ?? "NULL";
  }

  static void updateHelpMessage(int number, String message) {
    _helpDatabase[number] = message;
  }

  static Future<void> saveToFile() async {
    final file = File('lib/help_data_store.json');
    final Map<String, String> jsonMap =
    _helpDatabase.map((key, value) => MapEntry(key.toString(), value));
    final contents = jsonEncode(jsonMap);
    await file.writeAsString(contents);
  }

  static Future<void> loadFromFile() async {
    final file = File('lib/help_data_store.json');
    if (await file.exists()) {
      final contents = await file.readAsString();
      final Map<String, dynamic> jsonMap = jsonDecode(contents);
      _helpDatabase.clear();
      jsonMap.forEach((key, value) {
        _helpDatabase[int.parse(key)] = value.toString();
      });
    }
  }
}



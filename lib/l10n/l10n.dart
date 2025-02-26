import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('ar'),
  ];

  final Map<String, String> _localizedStrings;

  L10n(this._localizedStrings);

  static Future<L10n> load(Locale locale) async {
    String jsonString = await rootBundle.loadString('lib/l10n/app_${locale.languageCode}.arb');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Cast the values to String
    Map<String, String> stringMap = jsonMap.map((key, value) => MapEntry(key, value.toString()));

    // Debug print to verify the loaded strings
    //print('Loaded strings for ${locale.languageCode}: $stringMap');

    return L10n(stringMap);
  }

  String translate(String key) {
    // Debug print to check if the key exists
    if (!_localizedStrings.containsKey(key)) {
      //print('Key not found: $key');
    }
    return _localizedStrings[key] ?? '**$key**';
  }

  static L10n of(BuildContext context) {
    final l10n = Localizations.of<L10n>(context, L10n);
    if (l10n == null) {
      // Provide a fallback L10n instance with an empty map
      //print('L10n not found in context, returning fallback instance.');
      return L10n({});
    }
    return l10n;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  bool isSupported(Locale locale) => L10n.all.contains(locale);

  @override
  Future<L10n> load(Locale locale) async {
    //print('Loading locale: $locale');
    return L10n.load(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<L10n> old) => false;
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/service_helper.dart';
import '../services/system_navigator/helper/navigator_helper.dart';

class Translations {
  Locale? locale;

  static Translations? _instance;

  Translations._();

  static Translations get getInstance =>
      _instance = _instance ?? Translations._();

  late Map<String, String> _sentences;

  // ignore: use_setters_to_change_properties
  void setLocale(Locale locale) {
    this.locale = locale;
  }

  Future<bool> load() async {
    _sentences = <String, String>{};

    // parse common json data
    await parseJson('${locale?.languageCode}.json');

    // parse all domain specific json data
    for (var domain in getSupportedDomains()) {
      var domainName = ServiceHelper.getInstance.getDomainName(domain);

      if (domainName.isNotEmpty) {
        await parseJson('${domainName}_${locale?.languageCode}.json');
      }
    }

    return true;
  }

  Future<void> parseJson(String fileName) async {
    // reading json
    var data = await _loadAsset('locale/i18n_$fileName');
    if (data != null) {
      Map<String, dynamic> _result = json.decode(data);

      // adding values to [_sentences]
      _result.forEach((String key, dynamic value) {
        _sentences[key] = value.toString();
      });
    }
  }

  Future<String?> _loadAsset(String key) async {
    try {
      return await rootBundle.loadString(key);
    } on FlutterError catch (_) {
      return null;
    }
  }

  String? text(String? key) {
    if (!_sentences.containsKey(key)) return '$key not found';
    return _sentences[key!];
  }
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) async {
    var localizations = Translations.getInstance;
    localizations.setLocale(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}

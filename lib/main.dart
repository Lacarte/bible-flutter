import 'package:bible/application.dart';
import 'package:bible/localization.dart';
import 'package:bible/pages/home.dart';
import 'package:bible/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  final Brightness brightness;

  const MyApp({Key key, this.brightness}) : super(key: key);

  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  AppLocalizationsDelegate _appLocaleDelegate;
  Brightness brightness;

  @override
  void initState() {
    super.initState();
    _appLocaleDelegate = AppLocalizationsDelegate(newLocale: Locale('sn', ''));
    application.onLocaleChanged = onLocaleChange;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadPreferences(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return new MaterialApp(
            title: '',
            theme: getAppTheme(brightness),
            home: new HomePage(),
            localizationsDelegates: [
              _appLocaleDelegate,
              const AppLocalizationsDelegate(),
              //provides localised strings
              GlobalMaterialLocalizations.delegate,
              //provides RTL support
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: application.supportedLocales(),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  void onLocaleChange(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', locale.languageCode);
    setState(() {
      _appLocaleDelegate = AppLocalizationsDelegate(newLocale: locale);
    });
  }

  Future loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('auto_dark') ?? true) {
      this.brightness = DateTime.now().hour < 18 && DateTime.now().hour > 5
          ? Brightness.light
          : Brightness.dark;
    }

    String language = prefs.getString('lang') ?? 'sn';
    _appLocaleDelegate = AppLocalizationsDelegate(
      newLocale: Locale(language, ''),
    );

    return true;
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'l10n/l10n.dart'; // Import your localization class
import 'providers/locale_provider.dart'; // Import your locale provider
import 'pages/products_page.dart'; // Import your ProductsPage

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final localeController = ref.read(localeProvider.notifier);

    return FutureBuilder(
      future: L10n.load(locale),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading localizations');
        } else {
          return MaterialApp(
            locale: locale,
            supportedLocales: L10n.all,
            localizationsDelegates: [
              L10n.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily:
                  GoogleFonts.tajawal()
                      .fontFamily, // Set Tajawal as the default font
              textTheme: TextTheme(
                titleSmall: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                ),
                titleMedium: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                ),
                titleLarge: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                ),
                bodySmall: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                ),
                bodyMedium: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                ),
                bodyLarge: TextStyle(
                  fontFamily: GoogleFonts.tajawal().fontFamily,
                ),
                // Customize other text styles as needed
              ),
            ),
            home: Scaffold(
              appBar: AppBar(
                toolbarHeight: 40, // Reduce the height of the AppBar
                backgroundColor: Colors.amberAccent,
                actions: [
                  DropdownButton<Locale>(
                    value: locale,
                    onChanged: (Locale? newLocale) {
                      if (newLocale != null) {
                        localeController.setLocale(newLocale);
                      }
                    },
                    items: L10n.all.map<DropdownMenuItem<Locale>>((Locale locale) {
                      return DropdownMenuItem<Locale>(
                        value: locale,
                        child: Text(
                          locale.languageCode == 'en' ? 'English' : 'العربية',
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    icon: Icon(Icons.language, color: Colors.black),
                    underline: Container(), // Remove the underline
                  ),
                ],
              ),
              body: ProductsPage(),
            ),
          );
        }
      },
    );
  }
}

import 'package:app4training/routes/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app4training/data/globals.dart';
import 'package:app4training/routes/settings_page.dart';
import 'package:app4training/routes/startup_page.dart';
import 'package:app4training/routes/view_page.dart';

Route<Object?> generateRoutes(RouteSettings settings, WidgetRef ref) {
  debugPrint('Handling route "${settings.name}"');
  if ((settings.name == null) || (settings.name == '/')) {
    String page = ref.read(sharedPrefsProvider).getString('recentPage') ?? '';
    String lang = ref.read(sharedPrefsProvider).getString('recentLang') ?? '';
    String navigateTo = '/view';
    if ((page != '') &&
        (lang != '') &&
        ref.read(availableLanguagesProvider).contains(lang)) {
      navigateTo = '/view/$page/$lang';
    }
    return MaterialPageRoute<void>(
      settings: settings, // Necessary for the NavigatorObserver while testing
      builder: (_) => StartupPage(navigateTo: navigateTo),
    );
  } else if (settings.name!.startsWith('/view')) {
    // route should be /view/pageName/langCode - deep linking is possible
    final List<String> parts = settings.name!.split('/');
    String page = Globals.defaultPage;
    String langCode = 'en';
    if ((parts.length > 2) && (parts[2] != '')) page = parts[2];
    if ((parts.length > 3) && (parts[3] != '')) langCode = parts[3];
    // Save the selected page to the SharedPreferences to continue here
    // in case the user closes the app
    ref.read(sharedPrefsProvider).setString('recentPage', page);
    ref.read(sharedPrefsProvider).setString('recentLang', langCode);
    return MaterialPageRoute<void>(
        settings: settings, builder: (_) => ViewPage(page, langCode));
  } else if (settings.name == '/settings') {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => const SettingsPage(),
    );
  }

  return MaterialPageRoute<void>(
    settings: settings,
    builder: (_) => ErrorPage('Unknown route ${settings.name}'),
  );
}

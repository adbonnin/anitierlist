import 'dart:ui';

import 'package:anitierlist/firebase_options.dart';
import 'package:anitierlist/src/features/anime/presentation/tierlist/anime_tierlist_screen.dart';
import 'package:anitierlist/src/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final packageInfo = await PackageInfo.fromPlatform();

  runApp(
    ProviderScope(
      child: MyApp(
        version: packageInfo.version,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.version = '',
  });

  final String version;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AnimeTierListScreen(),
      onGenerateTitle: (context) => context.loc.app_title(version),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

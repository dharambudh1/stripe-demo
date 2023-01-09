import "package:flutter/material.dart";
import "package:flutter_stripe/flutter_stripe.dart";
import "package:flutter_stripe_demo/constant/string_constants.dart";
import "package:flutter_stripe_demo/screen/home_screen.dart";
import "package:flutter_stripe_demo/singletons/dio_singleton.dart";
import "package:keyboard_dismisser/keyboard_dismisser.dart";

/*
Account credential:
Website: dashboard.stripe.com
Username: dbuddh921@rku.ac.in
Password: A****i*********3
*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = StringConstants().publishableKey;
  Stripe.merchantIdentifier = "merchant.flutter.stripe.test";
  Stripe.urlScheme = "flutterstripe";
  await Stripe.instance.applySettings();
  await DioSingleton().addPrettyDioLoggerInterceptor();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: MaterialApp(
        title: "Stripe Demo",
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: Colors.blue,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

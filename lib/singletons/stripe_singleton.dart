import "dart:developer";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_stripe/flutter_stripe.dart" as stripe;
import "package:flutter_stripe_demo/singletons/dio_singleton.dart";
import "package:intl/intl.dart";

class StripeSingleton {
  factory StripeSingleton() {
    return _singleton;
  }

  StripeSingleton._internal();
  static final StripeSingleton _singleton = StripeSingleton._internal();

  Future<void> makePayment({
    required double amount,
    required Function(String) successAcknowledgement,
    required Function(String) errorAcknowledgement,
  }) async {
    final Locale locale = WidgetsBinding.instance.window.locale;
    final String countryCode = locale.countryCode ?? "US";
    final String currencyName = NumberFormat.simpleCurrency(
          locale: locale.toString(),
        ).currencyName ??
        "USD";
    String errorMessage = "";
    Map<String, dynamic> paymentIntent = <String, dynamic>{};
    paymentIntent = await DioSingleton().makePaymentIntent(
      amount: amount,
      currency: currencyName,
      errorMessageFunction: (String error) {
        errorMessage = error;
      },
    );
    if (errorMessage == "") {
      try {
        await stripe.Stripe.instance.initPaymentSheet(
          paymentSheetParameters: stripe.SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent["client_secret"],
            merchantDisplayName: "Flutter Stripe Store Demo",
            customerId: paymentIntent["customer"],
            customerEphemeralKeySecret: paymentIntent["ephemeralKey"],
            style: ThemeMode.system,
            applePay: stripe.PaymentSheetApplePay(
              merchantCountryCode: countryCode,
              paymentSummaryItems: <stripe.ApplePayCartSummaryItem>[
                stripe.ApplePayCartSummaryItem.immediate(
                  label: "for Books",
                  isPending: false,
                  amount: amount.toString(),
                ),
              ],
            ),
            googlePay: stripe.PaymentSheetGooglePay(
              merchantCountryCode: countryCode,
              testEnv: kDebugMode,
              currencyCode: currencyName,
            ),
            billingDetails: const stripe.BillingDetails(
              name: "Flutter Stripe",
              email: "email@stripe.com",
              phone: "+48888000888",
              address: stripe.Address(
                city: "Houston",
                country: "US",
                line1: "1459  Circle Drive",
                line2: "",
                state: "Texas",
                postalCode: "77063",
              ),
            ),
          ),
        );
        await makePaymentDisplay(
          successAcknowledgement: successAcknowledgement,
          errorAcknowledgement: errorAcknowledgement,
        );
      } on stripe.StripeException catch (error) {
        final String errorResponse = error.error.message ?? "";
        log("makePayment() : error : $errorResponse");
        errorAcknowledgement(errorResponse);
      }
    } else {
      errorAcknowledgement(errorMessage);
    }
    return Future<void>.value();
  }

  Future<void> makePaymentDisplay({
    required Function(String) successAcknowledgement,
    required Function(String) errorAcknowledgement,
  }) async {
    try {
      await stripe.Stripe.instance.presentPaymentSheet();
      successAcknowledgement("Order placed successfully");
    } on stripe.StripeException catch (error) {
      final String errorResponse = error.error.message ?? "";
      log("makePaymentDisplay() : error : $errorResponse");
      errorAcknowledgement(errorResponse);
    }
    return Future<void>.value();
  }
}

class StringConstants {
  factory StringConstants() {
    return _singleton;
  }

  StringConstants._internal();
  static final StringConstants _singleton = StringConstants._internal();

  String publishableKey =
      "pk_test_51LLLqhSFGBCzf0KqJlVlhU63NulHlsDLo7sp8tLyMT6fcmqB2xeQdkAMvcnSuIjGLC6uzbyLALYO2Pd35XwfGPVN00ONxmym3A";

  String secretKey =
      "sk_test_51LLLqhSFGBCzf0KqBv2ZHZeYvtQPB18vwPtRaQD4Xqd25lh9GWeWrNgSBl3J6wDj6U6oggyAAiGaWlZr3Xuw7ko500tRlLFTE4";
}

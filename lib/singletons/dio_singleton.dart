import "package:dio/dio.dart";
import "package:flutter_stripe_demo/constant/string_constants.dart";
import "package:flutter_stripe_demo/model/books_model.dart";
import "package:flutter_stripe_demo/model/stripe_error_model.dart";
import "package:pretty_dio_logger/pretty_dio_logger.dart";

class DioSingleton {
  factory DioSingleton() {
    return _singleton;
  }

  DioSingleton._internal();
  static final DioSingleton _singleton = DioSingleton._internal();

  final Dio dio = Dio();
  final String stripeBaseURL = "https://api.stripe.com/";
  final String stripeBaseVer = "v1/";
  final String stripeBaseEnd = "payment_intents";
  final String booksListLink = "https://www.jsonkeeper.com/b/6K25";

  Future<void> addPrettyDioLoggerInterceptor() {
    dio.interceptors.add(
      PrettyDioLogger(),
    );
    return Future<void>.value();
  }

  Future<Map<String, dynamic>> makePaymentIntent({
    required double amount,
    required String currency,
    required void Function(String) errorMessageFunction,
  }) async {
    final Map<String, dynamic> tempPaymentIntent = <String, dynamic>{};
    Response<dynamic> response = Response<dynamic>(
      requestOptions: RequestOptions(path: ""),
    );
    try {
      response = await dio.post(
        stripeBaseURL + stripeBaseVer + stripeBaseEnd,
        queryParameters: <String, dynamic>{
          "amount": amount.toInt() * 100,
          "currency": "INR",
          "payment_method_types[]": "card",
          "receipt_email": "johncena@yopmail.com",
          "description": "sample description",
          "shipping": <String, dynamic>{
            "name": "John Cena",
            "phone": "+919090909090",
            "tracking_number": "0123456789",
            "address": <String, dynamic>{
              "line1": "ABC line1",
              "line2": "ABC line2",
              "city": "ABC city",
              "state": "ABC state",
              "country": "ABC country",
              "postal_code": "ABC postal_code",
            }
          }
        },
        options: Options(
          headers: <String, dynamic>{
            "Content-Type": "application/json",
            "Authorization": "Bearer ${StringConstants().secretKey}",
          },
        ),
      );
      tempPaymentIntent.addAll(response.data);
    } on DioError catch (error) {
      StripeErrorModel stripeErrorModel = StripeErrorModel();
      stripeErrorModel = StripeErrorModel.fromJson(error.response?.data);
      errorMessageFunction(stripeErrorModel.error?.message ?? "Unknown Error");
    }
    return Future<Map<String, dynamic>>.value(tempPaymentIntent);
  }

  Future<BooksModel> bookListAPI({
    required void Function(String) errorMessageFunction,
  }) async {
    BooksModel newModel = BooksModel();
    Response<dynamic> response = Response<dynamic>(
      requestOptions: RequestOptions(path: ""),
    );
    try {
      response = await dio.get(
        booksListLink,
        options: Options(
          headers: <String, dynamic>{
            "Content-Type": "application/json",
          },
        ),
      );
      newModel = BooksModel.fromJson(response.data);
    } on DioError catch (error) {
      errorMessageFunction(error.response?.statusMessage ?? "Unknown Error");
    }
    return Future<BooksModel>.value(newModel);
  }
}

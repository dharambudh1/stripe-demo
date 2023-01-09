import "package:flutter/widgets.dart";
import "package:flutter_stripe_demo/model/books_model.dart";
import "package:flutter_stripe_demo/singletons/dio_singleton.dart";

class CRUDOperationsController extends ChangeNotifier {
  factory CRUDOperationsController() {
    return _singleton;
  }

  CRUDOperationsController._internal();
  static final CRUDOperationsController _singleton =
      CRUDOperationsController._internal();

  BooksModel newModel = BooksModel();
  String errorMessage = "";
  int currentIndex = 0;

  Future<void> fillDataToModel() async {
    newModel = await DioSingleton().bookListAPI(
      errorMessageFunction: (String error) {
        errorMessage = error;
      },
    );
    notifyListeners();
    return Future<void>.value();
  }

  void updateCurrentIndex(int value) {
    currentIndex = value;
    notifyListeners();
    return;
  }

  List<Data> bookListFunction() {
    return newModel.data ?? <Data>[];
  }

  List<Data> cartListFunction() {
    final List<Data> cartList = <Data>[];
    final Iterable<Data> index = bookListFunction().where(
      (Data element) {
        return element.bookQty > 0;
      },
    );
    cartList.addAll(index);
    return cartList;
  }

  void addOrRemoveCartItem({
    required Data item,
    required bool isForAddToCart,
  }) {
    final int index = bookListFunction().indexWhere(
      (Data element) {
        return element.bookId == item.bookId;
      },
    );
    isForAddToCart
        ? bookListFunction()[index].bookQty =
            bookListFunction()[index].bookQty + 1
        : bookListFunction()[index].bookQty =
            bookListFunction()[index].bookQty - 1;
    notifyListeners();
    return;
  }

  double totalAmount() {
    double totalAmount = 0;
    cartListFunction().forEach(
      (Data element) {
        totalAmount = totalAmount + (element.bookQty * element.bookPrice);
      },
    );
    return totalAmount;
  }

  void makeCartEmptyFunction() {
    final Iterable<Data> iterableBooks = bookListFunction().where(
      (Data element) {
        return element.bookQty > 0;
      },
    );
    iterableBooks.toList().forEach(
      (Data element) {
        element.bookQty = 0;
      },
    );
    bookListFunction().addAll(iterableBooks);
    return;
  }
}

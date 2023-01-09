class BooksModel {
  BooksModel({
    this.data,
  });

  BooksModel.fromJson(Map<String, dynamic> json) {
    if (json["data"] != null) {
      data = <Data>[];
      json["data"].forEach((dynamic v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  List<Data>? data;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (data != null) {
      map["data"] = data?.map((Data v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  Data({
    required this.bookId,
    required this.bookImage,
    required this.bookName,
    required this.bookAuthor,
    required this.bookPrice,
  });

  Data.fromJson(Map<String, dynamic> json) {
    bookId = json["bookId"];
    bookImage = json["bookImage"];
    bookName = json["bookName"];
    bookAuthor = json["bookAuthor"];
    bookPrice = json["bookPrice"];
  }

  String bookId = "";
  String bookImage = "";
  String bookName = "";
  String bookAuthor = "";
  double bookPrice = 0;
  int bookQty = 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["bookId"] = bookId;
    map["bookImage"] = bookImage;
    map["bookName"] = bookName;
    map["bookAuthor"] = bookAuthor;
    map["bookPrice"] = bookPrice;
    return map;
  }
}

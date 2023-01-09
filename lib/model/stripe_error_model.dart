class StripeErrorModel {
  StripeErrorModel({this.error});

  StripeErrorModel.fromJson(Map<String, dynamic> json) {
    error = json["error"] != null ? Error.fromJson(json["error"]) : null;
  }

  Error? error;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (error != null) {
      data["error"] = error!.toJson();
    }
    return data;
  }
}

class Error {
  Error({
    this.code,
    this.docUrl,
    this.message,
    this.param,
    this.requestLogUrl,
    this.type,
  });

  Error.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    docUrl = json["doc_url"];
    message = json["message"];
    param = json["param"];
    requestLogUrl = json["request_log_url"];
    type = json["type"];
  }

  String? code;
  String? docUrl;
  String? message;
  String? param;
  String? requestLogUrl;
  String? type;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["code"] = code;
    data["doc_url"] = docUrl;
    data["message"] = message;
    data["param"] = param;
    data["request_log_url"] = requestLogUrl;
    data["type"] = type;
    return data;
  }
}

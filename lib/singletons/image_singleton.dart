import "package:flutter/material.dart";

class ImageSingleton {
  factory ImageSingleton() {
    return _singleton;
  }

  ImageSingleton._internal();
  static final ImageSingleton _singleton = ImageSingleton._internal();

  Widget imageWidget(String url) {
    return Image.network(
      url,
      fit: BoxFit.fill,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
    );
  }

  Widget loadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? progress,
  ) {
    return (progress == null)
        ? child
        : Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                      (progress.expectedTotalBytes ?? 0.0)
                  : 0.0,
            ),
          );
  }

  Widget errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return const Icon(
      Icons.error_outline,
    );
  }
}

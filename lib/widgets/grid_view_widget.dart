import "dart:io";

import "package:dynamic_height_grid_view/dynamic_height_grid_view.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_stripe_demo/crud_operations/crud_operations.dart";
import "package:flutter_stripe_demo/model/books_model.dart";
import "package:flutter_stripe_demo/singletons/image_singleton.dart";

class GridViewWidget extends StatelessWidget {
  const GridViewWidget({required this.animateToCallback, super.key});

  final void Function() animateToCallback;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CRUDOperationsController(),
      builder: (BuildContext context, Widget? child) {
        return CRUDOperationsController().errorMessage == "" &&
                CRUDOperationsController().bookListFunction().isEmpty
            ? Center(
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    if (Platform.isIOS)
                      const CupertinoActivityIndicator()
                    else
                      const CircularProgressIndicator(),
                    const Spacer(),
                  ],
                ),
              )
            : CRUDOperationsController().errorMessage != "" &&
                    CRUDOperationsController().bookListFunction().isEmpty
                ? Center(
                    child: Text(CRUDOperationsController().errorMessage),
                  )
                : DynamicHeightGridView(
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    crossAxisCount: 2,
                    itemCount:
                        CRUDOperationsController().bookListFunction().length,
                    builder: (BuildContext context, int index) {
                      final Data item =
                          CRUDOperationsController().bookListFunction()[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ImageSingleton().imageWidget(
                            item.bookImage,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            item.bookName,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "By: ${item.bookAuthor}",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "₹: ${item.bookPrice}",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () async {
                                item.bookQty == 0
                                    ? CRUDOperationsController()
                                        .addOrRemoveCartItem(
                                        item: item,
                                        isForAddToCart: true,
                                      )
                                    : animateToCallback();
                              },
                              child: Text(
                                item.bookQty == 0
                                    ? "Add to Cart"
                                    : "Modify Qty.",
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
      },
    );
  }
}

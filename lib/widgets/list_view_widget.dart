import "package:flutter/material.dart";
import "package:flutter_stripe_demo/crud_operations/crud_operations.dart";
import "package:flutter_stripe_demo/model/books_model.dart";
import "package:flutter_stripe_demo/singletons/image_singleton.dart";

class ListViewWidget extends StatelessWidget {
  const ListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CRUDOperationsController(),
      builder: (BuildContext context, Widget? child) {
        return CRUDOperationsController().cartListFunction().isEmpty
            ? const Center(
                child: Text("Your Cart List is Empty."),
              )
            : ListView.builder(
                itemCount: CRUDOperationsController().cartListFunction().length,
                itemBuilder: (BuildContext context, int index) {
                  final Data cartItem =
                      CRUDOperationsController().cartListFunction()[index];
                  final double price = cartItem.bookPrice;
                  final int qty = cartItem.bookQty;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      child: Row(
                        children: <Widget>[
                          const Spacer(),
                          Expanded(
                            flex: 2,
                            child: ImageSingleton().imageWidget(
                              cartItem.bookImage,
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  cartItem.bookName,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "By: ${cartItem.bookAuthor}",
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Qty.: $qty * ₹: $price = ${qty * price}",
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    CRUDOperationsController()
                                        .addOrRemoveCartItem(
                                      item: cartItem,
                                      isForAddToCart: true,
                                    );
                                  },
                                ),
                                Text("${cartItem.bookQty}"),
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    CRUDOperationsController()
                                        .addOrRemoveCartItem(
                                      item: cartItem,
                                      isForAddToCart: false,
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          // const Spacer(),
                        ],
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}

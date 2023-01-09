import "dart:async";

import "package:after_layout/after_layout.dart";
import "package:badges/badges.dart";
import "package:flutter/material.dart";
import "package:flutter_stripe_demo/crud_operations/crud_operations.dart";
import "package:flutter_stripe_demo/singletons/stripe_singleton.dart";
import "package:flutter_stripe_demo/widgets/grid_view_widget.dart";
import "package:flutter_stripe_demo/widgets/list_view_widget.dart";
import "package:status_alert/status_alert.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomeScreen>
    with AfterLayoutMixin<HomeScreen> {
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CRUDOperationsController(),
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Stripe Demo"),
            leading: leadingAndActionWidget(isLeading: true),
            actions: <Widget>[
              leadingAndActionWidget(isLeading: false),
            ],
          ),
          floatingActionButtonLocation: floatingActionButtonLocation(),
          floatingActionButton: floatingActionButton(),
          body: SafeArea(
            child: PageView.builder(
              itemCount: 2,
              controller: pageController,
              onPageChanged: CRUDOperationsController().updateCurrentIndex,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: index == 0
                      ? GridViewWidget(
                          animateToCallback: () async {
                            await animateTo(1);
                          },
                        )
                      : const ListViewWidget(),
                );
              },
            ),
          ),
        );
      },
    );
  }

  FloatingActionButtonLocation floatingActionButtonLocation() {
    return FloatingActionButtonLocation.centerFloat;
  }

  Widget floatingActionButton() {
    return CRUDOperationsController().cartListFunction().isNotEmpty &&
            CRUDOperationsController().currentIndex == 1
        ? FloatingActionButton.extended(
            onPressed: () async {
              await StripeSingleton().makePayment(
                amount: CRUDOperationsController().totalAmount(),
                successAcknowledgement: (String acknowledgement) async {
                  showStatusAlert(
                    isSuccess: true,
                    acknowledgement: acknowledgement,
                  );
                  CRUDOperationsController().makeCartEmptyFunction();
                  await animateTo(0);
                },
                errorAcknowledgement: (String acknowledgement) {
                  showStatusAlert(
                    isSuccess: false,
                    acknowledgement: acknowledgement,
                  );
                },
              );
            },
            label: Text(
              "Checkout ₹: ${CRUDOperationsController().totalAmount()}",
            ),
          )
        : const SizedBox();
  }

  Widget leadingAndActionWidget({required bool isLeading}) {
    return (isLeading == true && CRUDOperationsController().currentIndex == 1)
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () async {
                await animateTo(0);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
          )
        : (isLeading == false && CRUDOperationsController().currentIndex == 0)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () async {
                    await animateTo(1);
                  },
                  icon: Badge(
                    badgeColor: Theme.of(context).colorScheme.primary,
                    badgeContent: Text(
                      CRUDOperationsController()
                          .cartListFunction()
                          .length
                          .toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                    ),
                  ),
                ),
              )
            : const SizedBox();
  }

  Future<void> animateTo(int pageNo) async {
    await pageController.animateToPage(
      pageNo,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
    return Future<void>.value();
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String errorResponse,
  ) {
    final SnackBar snackBar = SnackBar(
      content: Text(errorResponse),
      behavior: SnackBarBehavior.floating,
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showStatusAlert({
    required bool isSuccess,
    required String acknowledgement,
  }) {
    return StatusAlert.show(
      context,
      duration: const Duration(seconds: 4),
      title: isSuccess ? "Purchased successfully" : "Purchase failed",
      subtitle: acknowledgement,
      configuration: isSuccess
          ? const IconConfiguration()
          : const IconConfiguration(icon: Icons.clear),
      maxWidth: MediaQuery.of(context).size.width,
      titleOptions: StatusAlertTextConfiguration(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      subtitleOptions: StatusAlertTextConfiguration(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await CRUDOperationsController().fillDataToModel();
    return Future<void>.value();
  }
}

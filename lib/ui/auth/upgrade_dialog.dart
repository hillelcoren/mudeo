/*
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/web_client.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/ui/app/dialogs/error_dialog.dart';
import 'package:mudeo/ui/app/app_button.dart';
import 'package:mudeo/ui/app/loading_indicator.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crypto/crypto.dart';

class UpgradeDialog extends StatefulWidget {
  @override
  _UpgradeDialogState createState() => _UpgradeDialogState();
}

class _UpgradeDialogState extends State<UpgradeDialog> {
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products;
  List<PurchaseDetails> _purchases;
  bool _showPastPurchases = false;

  Future<void> loadPurchases() async {
    InAppPurchaseConnection.instance
        .queryPastPurchases()
        .then((response) async {
      if (response.pastPurchases != null && response.pastPurchases.isNotEmpty) {
        setState(() {
          _purchases = response.pastPurchases;
        });
      }
    });
  }

  Future<void> redeemPurchase(PurchaseDetails purchase) async {
    if (purchase.error != null || purchase.purchaseID == null) {
      return null;
    }

    //Navigator.pop(context);

    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final webClient = WebClient();
    final data = {
      'order_id': purchase.purchaseID,
      'timestamp': (int.parse(purchase.transactionDate) / 1000).floor(),
      'length':
          purchase.productID == kProductYearDownloads ? 'year' : 'lifetime',
    };

    try {
      final dynamic response = await webClient.post(
          '${state.apiUrl}/upgrade', state.authState.artist.token,
          data: json.encode(data));

      final String message = response['message'];

      if (message == 'SUCCESS') {
        store.dispatch(EnablePrivateStorage(expires: response['expires']));
        showDialog<AlertDialog>(
            context: context,
            builder: (BuildContext context) {
              final localization = AppLocalization.of(context);
              return AlertDialog(
                content: Text(localization.thankYouForYourPurchase),
                actions: <Widget>[
                  TextButton(
  
                    child: Text(localization.dismiss.toUpperCase()),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        if (Platform.isIOS) {
          InAppPurchaseConnection.instance.completePurchase(purchase);
        }
      } else {
        showDialog<ErrorDialog>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(message);
            });
      }
    } catch (error) {
      showDialog<ErrorDialog>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(error);
          });
    }
  }

  @override
  void initState() {
    super.initState();

    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;

    _subscription = purchaseUpdates.listen((dynamic purchases) {
      (purchases as List<PurchaseDetails>).forEach((purchase) async {
        await redeemPurchase(purchase);
      });
    }, onDone: () {
      _subscription.cancel();
      _subscription = null;
    }, onError: (dynamic error) {
      showDialog<ErrorDialog>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(error);
          });
    });

    initStore();
  }

  void initStore() async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();

    if (!available) {
      Navigator.of(context).pop();
      showDialog<ErrorDialog>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog('Store is not available');
          });
      return;
    }

    final productIds =
        Set<String>.from([kProductYearDownloads, kProductLifetimeDownloads]);
    final ProductDetailsResponse response =
        await InAppPurchaseConnection.instance.queryProductDetails(productIds);

    await loadPurchases();

    setState(() {
      _products = response.productDetails;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void upgrade(BuildContext context, ProductDetails productDetails) {
    final store = StoreProvider.of<AppState>(context);

    var bytes = utf8.encode(store.state.authState.artist.id.toString());
    Digest md5Result = md5.convert(bytes);

    InAppPurchaseConnection.instance.buyNonConsumable(
        purchaseParam: PurchaseParam(
      productDetails: productDetails,
      applicationUserName: md5Result.toString(),
      sandboxTesting: false,
    ));
  }

  String convertPlanToString(String plan) {
    switch (plan) {
      //case kProductPrivateStorage:
      //  return 'Private Storage';
      case kProductLifetimeDownloads:
        return 'Video Download [Lifetime]';
      case kProductYearDownloads:
        return 'Video Download [One Year]';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);

    if (_products == null) {
      return LoadingIndicator(height: 50);
    }

    return SimpleDialog(
      title: Column(
        children: <Widget>[
          Text(localization.enableDownloads),
          SizedBox(height: 15),
          if (Platform.isIOS)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Payment will be charged to iTunes Account at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user\'s Account Settings after purchase.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
  
                child: Text('Terms', style: TextStyle(fontSize: 12)),
                onPressed: () => launch(store.state.termsUrl),
              ),
              TextButton(
  
                child: Text('Privacy', style: TextStyle(fontSize: 12)),
                onPressed: () => launch(store.state.privacyUrl),
              ),
            ],
          )
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      children: [
        if (_showPastPurchases)
          ..._purchases.map((purchase) => ListTile(
                title: Text(purchase.purchaseID),
                subtitle: Text(DateTime.fromMillisecondsSinceEpoch(
                        int.tryParse(purchase.transactionDate))
                    .toString()),
                onTap: () => redeemPurchase(purchase),
              )),
        if (_purchases != null)
          AppButton(
            label: _showPastPurchases
                ? localization.back
                : localization.pastPurchases,
            onPressed: () {
              setState(() {
                _showPastPurchases = !_showPastPurchases;

                if (_showPastPurchases) {
                  loadPurchases();
                }
              });
            },
          ),
        if (!_showPastPurchases)
          ..._products
              .map((productDetails) => ListTile(
                    title: Text(productDetails.title ??
                        convertPlanToString(productDetails.id)),
                    subtitle: Text(productDetails.description ?? ''),
                    trailing: Text(productDetails.price ?? '',
                        style: TextStyle(fontSize: 18)),
                    onTap: () => upgrade(context, productDetails),
                  ))
              .toList()
      ],
    );
  }
}
*/
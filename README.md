# NepalPay Flutter [![Share on Twitter](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=Flutter%20NepalPayPayment%20plugin!&url=https://github.com/iamnabink/nepalpay_flutter&hashtags=flutter,flutterio,dart,wallet,nepalpay,paymentgateway) [![Share on Facebook](https://img.shields.io/badge/share-facebook-blue.svg?longCache=true&style=flat&colorB=%234267b2)](https://www.facebook.com/sharer/sharer.php?u=https%3A//github.com/iamnabink/nepalpay_flutter)

[![Pub Version](https://img.shields.io/pub/v/nepalpay_flutter.svg)](https://pub.dev/packages/nepalpay_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An un-official Flutter plugin for NepalPay Payment Gateway. With this plugin, you can easily
integrate NepalPay Payment Gateway into your Flutter app and start accepting payments from your
customers. Whether you're building an eCommerce app or any other type of app that requires payments,
this plugin makes the integration process simple and straightforward.

# Note

This package doesn't use any plugin or native APIs for payment initialization. Instead, it is based
on the Flutter InAppWebView package. A shoutout to the developer
of [InAppWebView](https://pub.dev/packages/flutter_inappwebview)
package for providing such a useful package.

## Features

- Easy integration
- No complex setup
- Pure Dart code
- Simple to use

## Requirements

* Android: `minSdkVersion 17` and add support for `androidx` (
  see [AndroidX Migration](https://flutter.dev/docs/development/androidx-migration))
* iOS: `--ios-language swift`, Xcode version `>= 11`

## Setup

| Platform | Configuration                                                                                                                                                                   |
|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| iOS      | No Configuration Needed. For more info, [see here](https://pub.dev/packages/flutter_inappwebview#important-note-for-ios)                                                        |
| Android  | Set `minSdkVersion` of your `android/app/build.gradle` file to at least 17. For more info, [see here](https://pub.dev/packages/flutter_inappwebview#important-note-for-android) |

# Usage

1. Add `nepalpay_flutter` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  nepalpay_flutter: ^1.0.0
```

2. Import the package in your Dart code:

```import 'package:nepalpay_flutter/nepalpay_flutter.dart';```

3. Create an instance of `NepalPayConfig` with your payment information:

The `NepalPayConfig` class holds the configuration details for the payment gateway. Pass an instance
of
`NepalPayConfig` to the init() method of the `NepalPay` class to initiate the payment process.

```dart

final config = NepalPayConfig.dev(
  amount: 100.0,
  instrumentCode: 'dummy_instrument',
  merchantName: 'Dummy Merchant',
  merchantTxnId: 'dummy_txn_id',
  processId: 'dummy_process_id',
  transactionRemarks: 'Dummy transaction',
);
```

4. Initialize the payment by calling `NepalPay.init()` method:

```
final result = await NepalPay.i.init(
  context: context,
  nepalPayConfig: config,
);
```
part of nepalpay_flutter;

// Holds NepalPay page's content widget
class NepalPayPageContent {
  /// Page appbar
  final AppBar? appBar;

  /// Page custom loader
  final Widget? progressLoader;

  NepalPayPageContent({this.appBar, this.progressLoader});
}

class NepalPayPage extends StatefulWidget {
  /// The NepalPayConfig configuration object.
  final NepalPayConfig nepalPayConfig;

  final NepalPayPageContent? content;

  /// NepalPayConfig page's content widget
  const NepalPayPage(this.nepalPayConfig, {this.content, Key? key})
      : super(key: key);

  @override
  State<NepalPayPage> createState() => _NepalPayPageState();
}

class _NepalPayPageState extends State<NepalPayPage> {
  late NepalPayConfig nepalPayConfig;

  /// Generate the URLRequest object from the NepalPay configuration parameters.
  late URLRequest paymentRequest;

  /// NepalPayPage page's content widget
  late final NepalPayPageContent? content;

  @override
  void initState() {
    content = widget.content;
    nepalPayConfig = widget.nepalPayConfig;
    paymentRequest = getURLRequest();
    super.initState();
  }

  bool _isLoading = true;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  // Generates the URLRequest object for the NepalPay payment page.
  URLRequest getURLRequest() {
    var url = "${nepalPayConfig.serverUrl}";
    final uri = Uri.parse(url);
    var params =
        "MerchantTxnId=${nepalPayConfig.merchantTxnId}&ProcessId=${nepalPayConfig.processId}&Amount=${nepalPayConfig.amount}&TransactionRemarks=${nepalPayConfig.transactionRemarks}&InstrumentCode=${nepalPayConfig.instrumentCode}&MerchantName=${nepalPayConfig.merchantName}&MerchantId=${nepalPayConfig.merchantId}";
    var urlRequest = URLRequest(
      url: Uri.https(uri.host, uri.path),
      body: Uint8List.fromList(utf8.encode(params)),
      method: 'POST',
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );
    // print('URL ${uri.toString()}');
    // print('Params ${params}');
    return urlRequest;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: content?.appBar ??
          AppBar(
            backgroundColor: Colors.blue,
            title: const Text("Pay Via NepalPay"),
          ),
      body: Stack(
        children: [
          InAppWebView(
            initialOptions: options,
            initialUrlRequest: paymentRequest,
            onWebViewCreated: (webViewController) {
              setState(() {
                _isLoading = false;
              });
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });
              print('url: ${url?.path ?? ''}');
              // if (url!.path == '/' ||
              //     url.path == '/BankResponse/TIIEBANK/CaptureRequest') {
              //   // Navigator.pop(context, NepalPayPaymentResult(error: 'Payment Cancelled'));
              // }

            },
            onLoadStop: (controller, url) async {
              setState(() {
                _isLoading = false;
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var url = navigationAction.request.url!;
              if (![
                "http",
                "https",
                "file",
                "chrome",
                "data",
                "javascript",
                "about"
              ].contains(url.scheme)) {
                return NavigationActionPolicy.CANCEL;
              }

              // https://gatewaysandbox.nepalpayment.com/BankResponse/TMBANK/CaptureRequest?BID=341694769&ITC=100000030262&PRN=100000030262&PAID=Y
              // https://dev.salesberry.com.np/confirmation/nepalPay?MerchantTxnId=AD13CZCQKB&GatewayTxnId=100000030262

              // check status code
              // if (response?.status >= 200 && response?.status <= 204) true, else false
              try {
                // print('URLLLL ${url.toString()}');
                var result = Uri.parse(url.toString());
                var body = result.queryParameters;
                if (body['GatewayTxnId'] != null &&
                    body['MerchantTxnId'] != null) {
                  await createPaymentResponse(body).then((value) {
                    Navigator.pop(context, NepalPayPaymentResult(data: value));
                  });
                }
              } catch (e) {
                Navigator.pop(context, NepalPayPaymentResult(error: 'Payment failed'));
              }

              return NavigationActionPolicy.ALLOW;
            },
            onLoadError: (controller, url, code, message) {},
            onConsoleMessage: (controller, consoleMessage) {},
          ),
          if (_isLoading)
            content?.progressLoader ??
                const Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }

  Future<NepalPayResponse> createPaymentResponse(
      Map<String, dynamic> body) async {
    final params = NepalPayResponse(
      gatewayTxnId: body['GatewayTxnId'],
      merchantTxnId: body['MerchantTxnId'],
    );
    return params;
  }
}

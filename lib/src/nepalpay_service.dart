part of nepalpay_flutter;

class _NepalPayService {
  _NepalPayService._(); // private constructor for singletons
  /// return the same instance of PaymentService
  static _NepalPayService i = _NepalPayService._();

  Future<NepalPayPaymentResult> init(
      {required BuildContext context,
      required NepalPayConfig nepalPayConfig,
      NepalPayPageContent? pageContent}) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NepalPayPage(
                  nepalPayConfig,
                  content: pageContent,
                )),
      );
      // Wait for the user to return from the nepalPay payment screen before closing any dialogs
      // This delay should give enough time for the success/failure dialog (if any) to appear and prevent it from closing prematurely.
      return await Future.delayed(const Duration(milliseconds: 500), () => result);
    } catch (e) {
      return NepalPayPaymentResult(error: 'Payment Failed or Cancelled!');
    }
  }
}

class NepalPay {
  NepalPay._(); // private constructor for singletons
  /// return the same instance of PaymentService
  static NepalPay instance = NepalPay._();

  /// you can use PaymentService.instance or PaymentService.i
  static NepalPay get i => instance;

  final _NepalPayService _payment = _NepalPayService.i;

  /// return a new instance of PaymentService for testing
  @visibleForTesting
  static NepalPay getInstance() => NepalPay._();

  /// like webview, native app, or a dialog.
  Future<NepalPayPaymentResult> init(
          {required BuildContext context,
          required NepalPayConfig nepalPayConfig,
          NepalPayPageContent? pageContent}) =>
      _payment.init(
          context: context,
          nepalPayConfig: nepalPayConfig,
          pageContent: pageContent);
}

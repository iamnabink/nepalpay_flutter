part of nepalpay_flutter;

class NepalPayResponse {
  NepalPayResponse({
    required this.merchantTxnId,
    required this.gatewayTxnId,
  });

  final String merchantTxnId;
  final String gatewayTxnId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MerchantTxnId'] = merchantTxnId;
    map['GatewayTxnId'] = gatewayTxnId;
    return map;
  }
}

class Payment {
  final String? paymentId;
  final String? executeUrl;
  final String? approvalUrl;
  final bool status;

  Payment({
    this.paymentId,
    this.executeUrl,
    this.approvalUrl,
    required this.status,
  });
}

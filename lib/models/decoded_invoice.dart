class DecodedInvoice {
  final String bolt11;
  final int amount;
  final String description;

  DecodedInvoice({
    required this.bolt11,
    required this.amount,
    required this.description,
  });

  @override
  String toString() {
    return "{invoice: $bolt11,amount: $amount, description: $description}";
  }
}

class Transfer {
  final double value;
  final int sender;

  Transfer(this.value, this.sender);

  @override
  String toString() {
    return 'Transfer{value : $value, sender: $sender}';
  }
}

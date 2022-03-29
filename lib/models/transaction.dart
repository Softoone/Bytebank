import 'contact.dart';

class Transaction {
  final double? value;
  final Contact contact;
  final String id;

  Transaction(this.value, this.contact,this.id);

  Transaction.fromJson(Map<String,dynamic> json):
      value = json['value'],
      contact = Contact.fromJson(json['contact']),
      id = json['id'];

  Map<String, dynamic> toJson() =>
      {
        'value': value,
        'contact': contact.toJson(),
      };

  @override
  String toString() {
    return value != null ?'Transaction{value: $value, contact: $contact}': 'Valor nulo';
  }
}
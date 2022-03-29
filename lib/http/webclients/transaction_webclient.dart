import 'dart:convert';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';
import '../web_client.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response data =
        await client.get(Uri.parse(url));
    List<Transaction> transactions = _toTransactions(data);
    return transactions;
    // final List<dynamic> decodedJson = jsonDecode(data.body);
    // print(decodedJson);
    // return decodedJson
    //     .map((dynamic json) => Transaction.fromJson(json))
    //     .toList();
  }

  Future<int> save(Transaction transaction, String password) async {

    await Future.delayed(const Duration(seconds: 3));

    final String dataEncode = jsonEncode(transaction.toJson());
    final Response response = await client.post(Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'password': password,
        },
        body: dataEncode);

    _throwHttpErrors(response);
    return response.statusCode;
  }
  
  void _throwHttpErrors(Response response) {
    switch (response.statusCode) {
      case 200:
        break;

      case 400:
        throw HttpException('Error on submit transaction!');

      case 401:
        throw HttpException('Authentication Failed!');

      default:
        throw HttpException('An unknown error has occurred!');
    }
  }

  // List<Transaction> _toTransactions(Response response) {
  //   final List<dynamic> decodedJson = jsonDecode(response.body);
  //   final List<Transaction> transactions = [];
  //   print(decodedJson);
  //   for (Map<String, dynamic> transactionJson in decodedJson) {
  //     print('executando...');
  //     transactions.add(Transaction.fromJson(transactionJson));
  //   }
  //   print('Lista: ' + transactions.toList().toString());
  //   return transactions.toList();
  // }

  List<Transaction> _toTransactions(Response response) {
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = [];
    for (Map<String, dynamic> transactionJson in decodedJson) {
      final Map<String, dynamic> contactJson = transactionJson['contact'];
      final Transaction transaction = Transaction(
        transactionJson['value'],
        Contact(
          contactJson['name'],
          contactJson['accountNumber'],
          0
        ),
        transactionJson['id']
      );
      transactions.add(transaction);
    }
    return transactions;
  }
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}
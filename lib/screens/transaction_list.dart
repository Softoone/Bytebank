import 'package:bytebank/components/centered_message.dart';
import 'package:bytebank/components/loadingWidget.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class TransactionsList extends StatelessWidget {

  final TransactionWebClient _webClient = TransactionWebClient();

  TransactionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Transactions'),
        ),
        body: FutureBuilder<List<Transaction>>(
            future: Future.delayed(const Duration(milliseconds: 750))
                .then((value) => _webClient.findAll()),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  FirebaseCrashlytics.instance.recordError(snapshot.error, snapshot.stackTrace);
                  break;

                case ConnectionState.waiting:
                  return  const Loading(message:'Loading...');

                case ConnectionState.active:
                  break;

                case ConnectionState.done:
                  List<Transaction>? transactions = snapshot.data;
                  if (transactions != null) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final Transaction transaction = transactions[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.monetization_on),
                            title: Text(transaction.value.toString(),
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            subtitle: Text(
                              transaction.contact.accountNumber.toString(),
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        );
                      },
                      itemCount: transactions.length,
                    );
                  }
                  FirebaseCrashlytics.instance.recordError(snapshot.error, snapshot.stackTrace);
                  return const CenteredMessage("No transactions found", icon: Icons.warning);
              }
              FirebaseCrashlytics.instance.recordError(snapshot.error, snapshot.stackTrace);
              return const CenteredMessage('Unexpected Error');
            }));
  }
}

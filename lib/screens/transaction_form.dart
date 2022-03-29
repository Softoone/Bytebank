import 'dart:async';

import 'package:bytebank/components/loadingWidget.dart';
import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  const TransactionForm(this.contact, {Key? key}) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String transactionId = const Uuid().v4();

  bool _setLoading = false;

  bool _switchButtonOff = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               Visibility(
                visible: _setLoading,
                  child: const Loading(message: 'Sending...',),
              ),
              Text(
                widget.contact.name,
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: const TextStyle(fontSize: 24.0),
                  decoration: const InputDecoration(labelText: 'Value'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      child: const Text('Transfer'),
                      onPressed: _switchButtonOff? null : () {
                        final double? value =
                            double.tryParse(_valueController.text);
                        final newTransaction =
                            Transaction(value, widget.contact,transactionId);
                        showDialog(
                          context: context,
                          builder: (contextDialog) {
                            return TransactionAuthDialog(
                                onConfirm: (String password) {
                                  _save(newTransaction, password, context);
                            });
                          },
                        );
                      },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(
      Transaction newTransaction,
      String password,
      BuildContext context) async {

    setState(() {
      _setLoading = true;
      _switchButtonOff = true;
    });
    final int transactionCode =
        await _webClient.save(newTransaction, password)
            .catchError((e) {
          setState(() {
            _setLoading = false;
            _switchButtonOff = false;
          });
          FirebaseCrashlytics.instance.recordError(e, null);
          _failureMessage(context,message: 'Exceeded time on submit');
              },
            test: (e) => e is TimeoutException)

            .catchError((e) {
          setState(() {
            _setLoading = false;
            _switchButtonOff = false;
          });
          FirebaseCrashlytics.instance.recordError(e, null);
          _failureMessage(context,message: e.message);
        }, test: (e) => e is HttpException)

            .whenComplete(() {
          setState(() {
            _setLoading = false;
          });
        });

        //     .catchError((e) {
        //       _failureMessage(context);
        // });



    _successMessage(transactionCode, context);
  }

  void _failureMessage(BuildContext context, {String message = 'Unknown Error'}) {
    showDialog(
        context: context,
        builder: (contextDialog) => FailureDialog(message));
  }

  Future<void> _successMessage(int transactionCode, BuildContext context) async {
    if (transactionCode == 200) {
      await showDialog(
        context: context,
        builder: (contextDialog) =>
            const SuccessDialog('Transaction submitted with success!'),
      );
      Navigator.pop(context);
    }
  }
}

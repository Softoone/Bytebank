import 'package:bytebank/components/only_number_fields.dart';
import 'package:bytebank/models/transfer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _pageTitle = "Adding Transfers";

const _labelValueField = "Value";
const _hintValueField = "0.00";

const _labelIdField = "ID";
const _hintIdField = "0000";

const _buttonText = "Submit";

class TransferForm extends StatefulWidget {
  const TransferForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TransferFormState();
  }
}

class TransferFormState extends State<TransferForm> {
  final TextEditingController _controllerInputId = TextEditingController();
  final TextEditingController _controllerInputValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(_pageTitle),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              NumberTextFields(
                controller: _controllerInputId,
                labelText: _labelIdField,
                hintText: _hintIdField,
                nameIcon: Icons.person_rounded,
              ),
              NumberTextFields(
                controller: _controllerInputValue,
                labelText: _labelValueField,
                hintText: _hintValueField,
                nameIcon: Icons.monetization_on_sharp,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.cyanAccent[700], onPrimary: Colors.white),
                onPressed: () {
                  String bothInfo = createTransfer(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 1, milliseconds: 500),
                      content: Text(bothInfo),
                  ),
                  );
                },
                child: const Text(_buttonText),
              )
            ],
          ),
        ),
    );
  }

// Função Criar Transferência

  String createTransfer(BuildContext context) {
    final int? transferId = int.tryParse(_controllerInputId.text);
    final double? transferValue = double.tryParse(_controllerInputValue.text);
    final String bothInfo =
        "ID: " '$transferId' " / " " Value: " '$transferValue';
    if (transferId != null && transferValue != null) {
      final transferCreation = Transfer(transferValue, transferId);
      Navigator.pop(context, transferCreation);
    }
    return bothInfo;
  }
}

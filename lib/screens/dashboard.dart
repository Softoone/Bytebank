import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/bytebank_logo.png'),
          ),
          Row(
            children: [
              _FeatureItem("Transfer", Icons.monetization_on,
                  onTapAction: () => _showContactsList(context)),
              _FeatureItem("Transaction Feed", Icons.description,
                  onTapAction: () => _showTransactionsList(context)),
            ],
          ),
        ],
      ),
    );
  }

}

void _showTransactionsList(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder:
        (context) => TransactionsList(),),);
}

void _showContactsList(BuildContext context) {
  Navigator.of(context).
  push    (
    MaterialPageRoute
      (
      builder: (context) =>

          ContactsList(),
    ),
  );
}

class _FeatureItem extends StatelessWidget {

  final String _featureName;
  final IconData _iconType;
  final Function onTapAction;

  const _FeatureItem(this._featureName, this._iconType, {required this.onTapAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme
            .of(context)
            .colorScheme
            .primary,
        child: InkWell(
          onTap: () => onTapAction(),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            height: 100,
            width: 150,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_iconType, color: Colors.white),
                Text(
                  _featureName,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

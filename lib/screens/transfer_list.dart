import 'package:bytebank/models/transfer.dart';
import 'package:bytebank/screens/transfer_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Montagem da Lista de Transferências

class TransfersList extends StatefulWidget {
  final List<Transfer> _transfersList = [];

  TransfersList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TransfersListState();
  }
}

class _TransfersListState extends State<TransfersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transfers"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final transfer00 = widget._transfersList[index];
          return ContactItem(transfer00);
        },
        itemCount: widget._transfersList.length,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent[700],
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return const TransferForm();
          })).then((transferReceived) =>
            _alterState(transferReceived)
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _alterState(transferReceived) {
               if (transferReceived != null){
      setState(() {
        widget._transfersList.add(transferReceived);
      });
    }

  }
}

// Criação do Item Transferência

class ContactItem extends StatelessWidget {
  final Transfer _newTransfer;

  const ContactItem(this._newTransfer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text(_newTransfer.value.toString()),
        subtitle: Text(_newTransfer.sender.toString()),
        trailing: const Icon(Icons.more_horiz),
      ),
    );
  }
}
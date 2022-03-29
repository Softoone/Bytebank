// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bytebank/components/loadingWidget.dart';
import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatefulWidget {
  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transfer"),
      ),
      body: FutureBuilder<List<Contact>>(
          initialData: [],
          future: Future.delayed(Duration(milliseconds: 750))
              .then((value) => _dao.findAll()),
          builder: (context, snapshot) {

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                // Exemplo de uso da coleta de dados em produção
                if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled){
                  FirebaseCrashlytics.instance.recordError(snapshot.error, snapshot.stackTrace);
                }
                break;

              case ConnectionState.waiting:
                return Loading(message: 'Loading...',);

              case ConnectionState.active:
                // TODO: Handle this case.
                break;

              case ConnectionState.done:
                final List<Contact>? contacts = snapshot.data;
                if (contacts != null) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final Contact contact = contacts[index];
                      return _ContactItem(contact,quickTransfer: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransactionForm(contact)));
                      });
                    },
                    itemCount: contacts.length,
                  );
                }else{
                  FirebaseCrashlytics.instance.recordError(snapshot.error, snapshot.stackTrace);
                }
                break;
            }

            FirebaseCrashlytics.instance.recordError(snapshot.error, snapshot.stackTrace);
            return Text("Erro Inesperado");
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ContactForm(),
            ),
          ).then((value) => setState((){}));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function quickTransfer;

  const _ContactItem(this.contact,{required this.quickTransfer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => quickTransfer(),
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text(contact.accountNumber.toString(),
            style: TextStyle(fontSize: 14)),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TransactionAuthDialog extends StatefulWidget {

  final Function(String password) onConfirm;
  const TransactionAuthDialog({Key? key, required this.onConfirm}) : super(key: key);

  @override
  State<TransactionAuthDialog> createState() => _TransactionAuthDialogState();
}

class _TransactionAuthDialogState extends State<TransactionAuthDialog> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: const Text("Authenticate"),
      content:  TextField(
        controller: _passwordController,
        maxLength: 4,
        obscureText: true,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: OutlineInputBorder()
        ),
        style: const TextStyle(
          letterSpacing: 24,
          fontSize: 56,
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(onPressed: () {
          widget.onConfirm(_passwordController.text);
          Navigator.pop(context);
        }, child: const Text("Confirm"))
      ],
    );
  }
}

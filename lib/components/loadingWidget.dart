// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, required this.message}) : super(key: key);

  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              const CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text(message,
                  style: const TextStyle(fontSize: 16,)
                  ,)
                ,)
            ]
        )
    );
  }
}

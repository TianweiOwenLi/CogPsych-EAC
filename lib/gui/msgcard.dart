import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {

  final String _message;

  const MessageCard(this._message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color.fromRGBO(200, 240, 200, 0.8),
      ),
      child: SizedBox(
          width: 1000,
          height: 1000,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _message,
                  style: const TextStyle(fontSize: 24),
                ),
              ]
          )
      ),
    );
  }
}
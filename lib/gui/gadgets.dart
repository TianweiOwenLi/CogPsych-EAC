
import 'package:flutter/material.dart';

class SizedText extends StatelessWidget {
  final String _txt;
  final double _size;

  const SizedText(this._txt, this._size, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      _txt,
      style: TextStyle(fontSize: _size)
    );
  }

}

class UtilButton extends StatelessWidget {
  final String _message;
  final void Function()? action;

  const UtilButton(this._message, this.action, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size.fromHeight(40),
            padding: const EdgeInsets.all(10)
        ),
        child: Text(
            _message,
            style: const TextStyle(fontSize: 20)
        )
    );
  }
}
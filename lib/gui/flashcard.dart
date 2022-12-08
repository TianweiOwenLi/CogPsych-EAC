import 'package:flutter/material.dart';
import 'confidence.dart';

class FlashcardRender extends StatefulWidget {

  final String _word;
  final String _meaning;
  final void Function(int) _reflect;
  final void Function() _nextCard;

  const FlashcardRender(this._word, this._meaning, this._reflect,
      this._nextCard, {super.key});

  @override
  State<StatefulWidget> createState() => _FlashcardRenderState();
}

// can flip back and forth via clicking.
class _FlashcardRenderState extends State<FlashcardRender> {
  bool _reveal = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ElevatedButton(
          onPressed: _reveal? null : (){
            if (!_reveal) {
              _reveal = true;
              setState(() {});
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(255, 255, 210, 0.8),
              disabledBackgroundColor: const Color.fromRGBO(230, 230, 210, 0.8),
              foregroundColor: Colors.grey[700],
              disabledForegroundColor: Colors.grey[700]
          ),
          child: SizedBox(
              width: 1000,
              height: 1000,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _reveal? <Widget>[
                    const SizedBox(height: 20),
                    Text(
                      widget._word,
                      style: const TextStyle(fontSize: 30),
                    ),
                    Expanded(child: Container()),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget._meaning,
                          style: const TextStyle(fontSize: 20),
                        )
                    ),
                    Expanded(child: Container()),
                    ConfidenceRow((int n){
                      _reveal = !_reveal;
                      setState(() {});
                      widget._reflect(n);
                      widget._nextCard();
                    }),
                  ] : <Widget>[
                    Text(
                      widget._word,
                      style: const TextStyle(fontSize: 30),
                    )
                  ]
              )
          ),
        )
    );
  }
}
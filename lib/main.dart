import 'package:flutter/material.dart';

void main() {
  runApp(const FlashcardWrapperApp());
}

class Flashcard {
  String _word;
  String _meaning;
  DateTime lastLearned = DateTime.now();

  Flashcard(this._word, this._meaning);

  void learn() => lastLearned = DateTime.now();

  int hoursSinceLearned() => DateTime.now().difference(lastLearned).inHours;

  void editMeaning(String s) => _meaning = s;

  void editWord(String s) => _word = s;

  String getMeaning() => _meaning;

  String getWord() => _word;
}

class ConfidenceButton extends StatelessWidget {
  final void Function(int) reflect;
  final int confidence;

  const ConfidenceButton(this.reflect, this.confidence, {super.key});

  int pow4(int n) => n * n * n * n;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () => reflect(confidence),
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(
                  240 - pow4(confidence) * 15,
                  240 - pow4(2 - confidence) * 15, 0, 0.8),
              minimumSize: const Size.square(40),
              padding: const EdgeInsets.all(10)
          ),
          child: null,
        ),
      ),
    );
  }
}

class ConfidenceRow extends StatelessWidget {
  final void Function(int) reflect;

  const ConfidenceRow(this.reflect, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          "Are you familiar with this? ",
          style: TextStyle(
            fontSize: 20
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ConfidenceButton(reflect, 0),
            ConfidenceButton(reflect, 1),
            ConfidenceButton(reflect, 2)
          ],
        )
      ],
    );
  }
}

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

class FlashcardRender extends StatefulWidget {

  final String _word;
  final String _meaning;
  final void Function(int) _reflect;

  const FlashcardRender(this._word, this._meaning, this._reflect, {super.key});

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
        onPressed: (){
          _reveal = !_reveal;
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(255, 255, 210, 0.8),
            foregroundColor: Colors.black,
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
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 50),
              Center(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget._meaning,
                        style: const TextStyle(fontSize: 20),
                      )
                  )
              ),
              Expanded(
                flex: 1,
                child: Container(

                )
              ),
              ConfidenceRow(widget._reflect),
            ] : <Widget>[
              Text(
                widget._word,
                style: const TextStyle(fontSize: 40),
              )
            ]
          )
      ),
      )
    );
  }
}

class FlashcardWrapperApp extends StatelessWidget {
  const FlashcardWrapperApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcards',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const FlashcardHomepage(title: 'Flashcard Module with HLR'),
    );
  }
}

class FlashcardHomepage extends StatefulWidget {
  final String title;

  const FlashcardHomepage({Key? key, required this.title}) : super(key: key);

  @override
  State<FlashcardHomepage> createState() => _FlashcardHomepageState();
}

class _FlashcardHomepageState extends State<FlashcardHomepage> {
  String _word = "", _meaning = "";
  final List<Flashcard> _flashcards = [];
  int _cursor = 0;
  String _counter = "No flashcard exists yet";
  String nextCardStr = "Next Card";

  addFlashcard(String w, String m) {
    Navigator.pop(context);
    _flashcards.add(Flashcard(_word, _meaning));
    _counter = "Flashcard no. ${1 + _cursor} / ${_flashcards.length}";
    setState((){});
  }

  nextFlashcard() {
    _cursor++;
    if (_cursor > _flashcards.length) _cursor = 0;
    _counter = (_cursor == _flashcards.length)?
      "Press \"Next Cart\" to restart" :
      "Flashcard no. ${1 + _cursor} / ${_flashcards.length}";
    setState((){});
  }

  void reflect(int confidence) {
    // TODO update the learning history of _flashcard[_cursor]
    print(confidence);
  }

  void createFlashcard() {
    _word = "";
    _meaning = "";

    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        content: Column(

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                "Create your new flashcard",
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextField(
              style: const TextStyle(fontSize: 16, height: 1.0),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                hintText: "Terminology",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0))
                ),
              ),
              onChanged: (String s) => _word = s,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: TextField(
                  minLines: 3,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 16, height: 1.0),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: "Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0))
                      )
                  ),
                  onChanged: (String s) => _meaning = s,
                ),
            ),
            ElevatedButton(
                onPressed: () => addFlashcard(_word, _meaning),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size.fromHeight(40),
                    padding: const EdgeInsets.all(10)
                ),
                child: const Text(
                    "Confirm",
                    style: TextStyle(fontSize: 20)
                )
            ),
          ],
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // avoid keyboard interference
      appBar: AppBar(
        toolbarHeight: 30,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _flashcards.isEmpty?
                    const MessageCard("No flashcards created") :
                    _cursor < _flashcards.length?
                      FlashcardRender(_flashcards[_cursor].getWord(),
                        _flashcards[_cursor].getMeaning(), reflect) :
                      const MessageCard("Congrats on finishing")
                )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  _counter,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                    child: ElevatedButton(
                        onPressed: createFlashcard,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size.square(40),
                            padding: const EdgeInsets.all(10)
                        ),
                        child: const Text(
                            "Add Flashcard",
                            style: TextStyle(fontSize: 20)
                        )
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                    child: ElevatedButton(
                        onPressed: nextFlashcard,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size.square(40),
                            padding: const EdgeInsets.all(10)
                        ),
                        child: Text(
                            nextCardStr,
                            style: const TextStyle(fontSize: 20)
                        )
                    ),
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}



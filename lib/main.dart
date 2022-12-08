import 'package:flutter/material.dart';
import 'gui/flashcard.dart';
import 'gui/msgcard.dart';
import 'gui/gadgets.dart';
import 'algorithm/leitner.dart';
import 'algorithm/hlr.dart';
import 'dart:math';

void main() {
  runApp(const FlashcardWrapperApp());
}

class Flashcard {
  String _word;
  String _meaning;
  DateTime lastLearned = DateTime.now();
  List<int> recallTime = [];
  List<int> recallRate = [];
  double halfLifeMinute = 30.0;

  Flashcard(this._word, this._meaning);

  void learn(int result) {
    recallTime.add(minutesSinceLearned() + halfLifeMinute.toInt()); // experiment
    recallRate.add(result);
    if (recallTime.length > 3) {
      recallTime.removeAt(0);
      recallRate.removeAt(0);
    }
    halfLifeMinute = hlr(recallTime, recallRate, halfLifeMinute);
  }

  int minutesSinceLearned() => DateTime.now().difference(lastLearned).inMinutes; // experiment

  void editMeaning(String s) => _meaning = s;

  void editWord(String s) => _word = s;

  String getMeaning() => _meaning;

  String getWord() => _word;
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
  // TODO implement restart lock when cards flipped

  addFlashcard(String w, String m) {
    Navigator.pop(context);
    _flashcards.add(Flashcard(_word, _meaning));
    _counter = "Flashcard no. ${1 + _cursor} / ${_flashcards.length}";
    setState((){});
  }

  nextFlashcard() {
    _cursor++;
    if (_cursor > _flashcards.length) _cursor = 0;
    _counter = (_cursor == _flashcards.length) && _flashcards.isNotEmpty?
      "All done" :
      "Flashcard no. ${1 + _cursor} / ${_flashcards.length}";
    setState((){});
  }

  restart() {
    _cursor = 0;
    _counter = "Flashcard no. ${1 + _cursor} / ${_flashcards.length}";
    setState(() {});
  }

  void reflect(int confidence) {
    assert(_cursor < _flashcards.length && _cursor >= 0);
    _flashcards[_cursor].learn(confidence);
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
              child: SizedText("Create Your new flashcard", 20)
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
            UtilButton("Confirm", () => addFlashcard(_word, _meaning)),
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
                        _flashcards[_cursor].getMeaning(),
                          reflect, nextFlashcard) :
                      const MessageCard("Congrats on finishing")
                )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedText(_counter, 24)
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                    child: UtilButton("Add Flashcard", createFlashcard)
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                    child: UtilButton("Restart", _flashcards.isEmpty? null : restart),
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



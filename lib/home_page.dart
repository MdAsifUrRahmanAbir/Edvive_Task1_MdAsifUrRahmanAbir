import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // SpeechToText _speech = SpeechToText();
  late stt.SpeechToText _speech;
  bool _speechEnabled = false;
  bool _isListening = false;
  String _text = '';

  @override
  void initState(){
    super.initState();
    // _initSpeech();
    _speech = stt.SpeechToText();
  }


  String fromLang = "English";
  String toLang = "Bengali";
  List <String> availableLang =  <String>['English', 'Arabic', 'Hindi', 'Bengali'];
  List <String> languageCode =  <String>['en', 'ar', 'hi', 'bn'];
  String userInput = "";
  String result = "";


  resultTranslate() async {
    final translator = GoogleTranslator();
    translator.translate(userInput, from: 'en', to: languageCode[availableLang.indexOf(toLang)]).then(print);
    var translation = await translator.translate(userInput, to: languageCode[availableLang.indexOf(toLang)]);
    setState(() {
      result = translation.text;
      String code = languageCode[availableLang.indexOf(toLang)];
          speach(result.toString(), code);
    });
    // prints exemplo
  }


  final TextEditingController _textEditingController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  speach(String text, String language) async{
    await _flutterTts.setLanguage(language);
    await _flutterTts.setPitch(1);
    await _flutterTts.speak(text);
    _isListening = false;
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edvive Task1', style: TextStyle(color: Colors.grey),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(40),
        child: ListView(
          children: [

            // First Row
            Row(
              children: const [
                Expanded(flex: 1, child: Text('From:  ')),
                Expanded(
                  child: Text('English'),
                  flex: 5,
                  // child: DropdownButton<String>(
                  //   value: fromLang,
                  //   icon: const Icon(Icons.arrow_downward),
                  //   iconSize: 24,
                  //   elevation: 16,
                  //   style: const TextStyle(color: Colors.deepPurple),
                  //   underline: Container(
                  //     height: 2,
                  //     color: Colors.deepPurpleAccent,
                  //   ),
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       fromLang = newValue!;
                  //     });
                  //   },
                  //   items: availableLang
                  //       .map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value),
                  //     );
                  //   }).toList(),
                  // ),
                ),
              ],
            ),
            // Second Row
            Row(
              children: [
                const Expanded(flex: 1, child: Text('To:  ')),
                Expanded(
                  flex: 5,
                  child: DropdownButton<String>(
                    value: toLang,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        toLang = newValue!;
                      });
                    },
                    items: availableLang
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),

            // voice input button
            FloatingActionButton(
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_off),
            ),
            const SizedBox(height: 10,),

            // TextFeild
            TextField(
              controller: _textEditingController,
              maxLines: 5,
              onChanged: (val) {
                setState(() {
                  userInput = val;
                });
              },
              decoration: const InputDecoration(
                  hintText: 'Press the button and start speaking',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
            ),
            const SizedBox(height: 10,),

            // translate button
            MaterialButton(
                height: 50,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.blue,)
                ),
                child: const Text('Translate', style: TextStyle(color: Colors.white, fontSize: 20 )),
                onPressed: (){
                  resultTranslate();
                }),

            // Result
            const SizedBox(height: 10,),
            Center(child: Text('Result: $result', style: const TextStyle(color: Colors.black, fontSize: 20 ))),
          ],
        ),
      ),
    );
  }

  void _listen() async {
    print('floating pressed and go to _listen');
    _textEditingController.text = '';
    result = '';
    userInput = '';
    if (_isListening== false) {
      print('A');
      bool available = await _speech.initialize(
        onStatus: (val) => print('*** onStatus: $val'),
        onError: (val) =>  print('### onError: $val'),
      );
      print('1');
      if (available) {
        print('2');
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            print('3');
            _textEditingController.text = val.recognizedWords.toString();
            userInput = val.recognizedWords.toString();
          }),
        );
      }
    }
    else {
      print('0000');
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

}

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:texttospeechapp/speech.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
 State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final String defaultLanguage = 'en-US';

  TextToSpeech tts = TextToSpeech();

  String text = '';
  double volume = 1; // Range: 0-1

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = text;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLanguages();
    });
  }

  Future<void> initLanguages() async {
    /// populate lang code (i.e. en-US)
    ///
    /// String language = 'en-US';
    String language = 'en-US';
    tts.setLanguage(language);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: textEditingController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter some text here...'),
                        onChanged: (String newText) {
                          setState(() {
                            text = newText;
                          });
                        },
                      ),
                      Row(
                        children: <Widget>[
                          const Text('Volume'),
                          Expanded(
                            child: Slider(
                              value: volume,
                              min: 0,
                              max: 1,
                              label: volume.round().toString(),
                              onChanged: (double value) {
                                initLanguages();
                                setState(() {
                                  volume = value;
                                });
                              },
                            ),
                          ),
                          Text('(${volume.toStringAsFixed(2)})'),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10),
                              child: ElevatedButton(
                                child: const Text('Stop'),
                                onPressed: () {
                                  tts.stop();
                                },
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            child: ElevatedButton(
                              child: const Text('Speak'),
                              onPressed: () {
                                speak();
                              },
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: ElevatedButton(
                  child: Text('SpeechToText'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SpeechConverter()),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  bool get supportPause => defaultTargetPlatform != TargetPlatform.android;

  bool get supportResume => defaultTargetPlatform != TargetPlatform.android;

  void speak() {
    tts.setVolume(volume);

    tts.speak(text);
  }
}

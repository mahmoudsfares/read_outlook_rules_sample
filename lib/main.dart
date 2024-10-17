import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _readRules() async {
    try {
      final byteData = await rootBundle.load('assets/Rules.rwz');
      final buffer = byteData.buffer.asUint8List();
      // Get the temporary directory
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/Rules.rwz';
      const platform = MethodChannel('outlook_rules_reader_channel');
      final rules = await platform.invokeMethod('parseRules', filePath);
      Fluttertoast.showToast(msg: "SUCCESS");
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: "FAIL: ${e.toString}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _readRules,
        tooltip: 'Read rules',
        child: const Icon(Icons.read_more),
      ),
    );
  }
}

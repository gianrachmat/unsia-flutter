import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTS UNSIA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'UTS Mobile Unsia'),
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
  final List<String> _radioItems = [
    'Sistem Informasi',
    'Informatika',
  ];
  late String _selectedRadio;

  @override
  void initState() {
    super.initState();
    _selectedRadio = _radioItems.first;
  }

  List<InputModel> _generateModel() {
    return [
      InputModel('Program Hitung Nilai Akhir UNSIA', InputType.title),
      InputModel('Nama', InputType.text),
      InputModel('NIM', InputType.text),
      InputModel(
        'Prodi',
        InputType.radio,
        radioItem: _radioItems,
      ),
      InputModel('Nilai Absen', InputType.text),
      InputModel('Nilai Tugas/Praktikum', InputType.text),
      InputModel('Nilai UTS', InputType.text),
      InputModel('Nilai UAS', InputType.text),
      InputModel(
        '',
        InputType.button,
        buttons: ['Hitung', 'Bersihkan'],
      ),
    ];
  }

  Widget _buildItem() {
    List<Widget> model = _generateModel().map((InputModel e) {
      Widget item = Container();
      switch (e.type) {
        case InputType.title:
          item = Center(
            child: Text(
              e.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          );
          break;
        case InputType.text:
          item = TextField(
            key: Key(e.title),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          );
          break;
        case InputType.radio:
          if (e.radioItem.isNotEmpty) {
            List<Widget> radios = [];
            for (var element in e.radioItem) {
              radios.add(
                Row(
                  children: [
                    Radio<String>(
                      value: element,
                      groupValue: _selectedRadio,
                      onChanged: (selected) {
                        setState(() {
                          _selectedRadio = selected ?? '';
                        });
                      },
                    ),
                    Text(element),
                  ],
                ),
              );
            }
            item = Column(children: radios);
          }
          break;
        case InputType.button:
          if (e.buttons.isNotEmpty) {
            List<Widget> buttons = [];
            for (var element in e.buttons) {
              buttons.add(OutlinedButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: Text(element),
              ));
            }
            item = Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: buttons,
              ),
            );
          }
          break;
        default:
          item = Container();
          break;
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            if (e.title != '' && e.type != InputType.title)
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Text(e.title),
              ),
            Flexible(
              fit: FlexFit.tight,
              flex: 3,
              child: item,
            ),
          ],
        ),
      );
    }).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        children: model,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: _buildItem(),
      ),
    );
  }
}

enum InputType { title, text, radio, button }

class InputModel {
  String title;
  InputType type;
  List<String> radioItem;
  List<String> buttons;

  InputModel(
    this.title,
    this.type, {
    this.radioItem = const [],
    this.buttons = const [],
  });
}

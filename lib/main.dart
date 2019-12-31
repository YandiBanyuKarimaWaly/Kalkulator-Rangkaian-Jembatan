import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    final appTitle = 'Kalkulator Rangkaian Jembatan';

    return MaterialApp(
      title: appTitle,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  MyHome({Key key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _selectedIndex = 0;

  static const List<Text> pageTitle = <Text>[
    Text("Wheatstone"),
    Text("Maxwell-Wien")
  ];

  static const List<Widget> _widgetOptions = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: pageTitle.elementAt(_selectedIndex),
      ),
      body: Padding(padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 32.0), child: (_selectedIndex == 0) ? MyCustomForm() : MyMaxwellForm(),),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.unfold_more),
            title: Text('Wheatstone'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.unfold_more),
            title: Text('Maxwell-Wien'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

String validateInput(String value) {
  if (value.isEmpty) {
    return null;
    // return 'Nilai harus di isi';
  }

  if (value.contains(".") ||
      value.contains(",") ||
      value.contains(" ") ||
      value.contains("-")) {
    return 'Nilai resistor harus bilangan bulat positif';
  }
  return null;
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyMaxwellForm extends StatefulWidget {
  @override
  MyMaxwellFormState createState() {
    return MyMaxwellFormState();
  }
}

class MyMaxwellFormState extends State<MyMaxwellForm> {
  final _formKey = GlobalKey<FormState>();

  final r1Controller = TextEditingController();
  final r2Controller = TextEditingController();
  final r3Controller = TextEditingController();
  final r4Controller = TextEditingController();

  final formatter = <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly];

  int hasilHitungan = 0;
  int hitungan2 = 0;

  void hitung()
  {
    int r2 = 0;
    int r3 = 0;
    int r4 = 0;
    int c4 = 0;

    (r1Controller.text.isEmpty) ? r2 = 0 : r2 = int.parse(r1Controller.text);
    (r2Controller.text.isEmpty) ? r3 = 0 : r3 = int.parse(r2Controller.text);
    (r3Controller.text.isEmpty) ? r4 = 0 : r4 = int.parse(r3Controller.text);
    (r4Controller.text.isEmpty) ? c4 = 0 : c4 = int.parse(r4Controller.text);

    setState(() {
      (r4 == 0) ? hasilHitungan = 0 : hasilHitungan = (r2/r4*r3).round();
      hitungan2 = c4*r2*r3;
    });
  }

  @override
  void dispose() {
    r1Controller.dispose();
    r2Controller.dispose();
    r3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () => hitung(),
      child: ListView(
        children: <Widget>[
          SvgPicture.asset(
            'images/maxwell-wien-bridge.svg',
            semanticsLabel: 'Jembatan Maxwell-Wien',
            width: MediaQuery.of(context).size.width * 0.8,
          ),
          TextFormField(
            controller: r1Controller,
            validator: validateInput,
            keyboardType: TextInputType.number,
            inputFormatters: formatter,
            decoration: InputDecoration(
                labelText: "Nilai R2 (Konstan)",
                hintText: "100",
                icon: Icon(Icons.broken_image)),
            onChanged: (text) {
              hitung();
            },
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 5.0)),
          TextFormField(
              controller: r2Controller,
              validator: validateInput,
              keyboardType: TextInputType.number,
              inputFormatters: formatter,
              decoration: InputDecoration(
                  labelText: "Nilai R3 (Konstan)",
                  hintText: "100",
                  icon: Icon(Icons.broken_image)),
              onChanged: (text) {
                hitung();
              }),
          Padding(padding: const EdgeInsets.symmetric(vertical: 5.0)),
          TextFormField(
              controller: r3Controller,
              validator: validateInput,
              keyboardType: TextInputType.number,
              inputFormatters: formatter,
              decoration: InputDecoration(
                  labelText: "Nilai C4 (Variable)",
                  hintText: "100",
                  icon: Icon(Icons.pause)),
              onChanged: (text) {
                hitung();
              }),
          Padding(padding: const EdgeInsets.symmetric(vertical: 5.0),),
          TextFormField(
              controller: r4Controller,
              validator: validateInput,
              keyboardType: TextInputType.number,
              inputFormatters: formatter,
              decoration: InputDecoration(
                  labelText: "Nilai R4 (Variable)",
                  hintText: "100",
                  icon: Icon(Icons.broken_image)),
              onChanged: (text) {
                hitung();
              }),
          Padding(padding: const EdgeInsets.symmetric(vertical: 5.0),),
          Text("R1: $hasilHitungan  -  L1: $hitungan2", style: TextStyle(fontSize: 26),)
        ],
      ),
    );
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  final r1Controller = TextEditingController();
  final r2Controller = TextEditingController();
  final r3Controller = TextEditingController();

  final formatter = <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly];

  int hasilHitungan = 0;

  void hitung()
  {
    int l2 = 0;
    int rv = 0;
    int r1 = 0;

    (r1Controller.text.isEmpty) ? l2 = 0 : l2 = int.parse(r1Controller.text);
    (r2Controller.text.isEmpty) ? rv = 0 : rv = int.parse(r2Controller.text);
    (r3Controller.text.isEmpty) ? r1 = 0 : r1 = int.parse(r3Controller.text);

    setState(() {
      (r1 == 0) ? hasilHitungan = 0 : hasilHitungan = (l2/r1*rv).round();
    });
  }

  @override
  void dispose() {
    r1Controller.dispose();
    r2Controller.dispose();
    r3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () => hitung(),
      child: ListView(
        children: <Widget>[
          SvgPicture.asset(
            'images/wheatstone-bridge.svg',
            semanticsLabel: 'Jembatan Wheatstone',
            width: MediaQuery.of(context).size.width * 0.8,
          ),
          TextFormField(
            controller: r1Controller,
            validator: validateInput,
            keyboardType: TextInputType.number,
            inputFormatters: formatter,
            decoration: InputDecoration(
                labelText: "Nilai L2 (Panjang)",
                hintText: "100",
                icon: Icon(Icons.linear_scale)),
            onChanged: (text) {
              hitung();
            },
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 5.0)),
          TextFormField(
              controller: r2Controller,
              validator: validateInput,
              keyboardType: TextInputType.number,
              inputFormatters: formatter,
              decoration: InputDecoration(
                  labelText: "Nilai Rv (Variable)",
                  hintText: "100",
                  icon: Icon(Icons.broken_image)),
              onChanged: (text) {
                hitung();
              }),
          Padding(padding: const EdgeInsets.symmetric(vertical: 5.0)),
          TextFormField(
              controller: r3Controller,
              validator: validateInput,
              keyboardType: TextInputType.number,
              inputFormatters: formatter,
              decoration: InputDecoration(
                  labelText: "Nilai R1 (Konstan)",
                  hintText: "100",
                  icon: Icon(Icons.broken_image)),
              onChanged: (text) {
                hitung();
              }),
          Padding(padding: const EdgeInsets.symmetric(vertical: 5.0),),
          Text("L1: $hasilHitungan", style: TextStyle(fontSize: 26),)
        ],
      ),
    );
  }
}

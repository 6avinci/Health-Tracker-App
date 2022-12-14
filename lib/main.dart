import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF292929),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          reverse: true,
          controller: controller,
          children: const [
            DetailPage(headline: 'Heute', daysInPast: 0),
            DetailPage(headline: 'Gestern', daysInPast: 1),
            DetailPage(headline: 'Vorgestern', daysInPast: 2),
            DetailPage(headline: 'Vor 3 Tagen', daysInPast: 3),
            DetailPage(headline: 'Vor 4 Tagen', daysInPast: 4),
            DetailPage(headline: 'Vor 5 Tagen', daysInPast: 5),
          ],
        )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.headline, required this.daysInPast})
      : super(key: key);

  final String headline;
  final int daysInPast;

  @override
  _DetailPageState createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends State<DetailPage> {
  late int page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 48, 0.0, 32.0),
      child: Column(
        children: <Widget>[
          Text(widget.headline,
              style: const TextStyle(fontSize: 48.0, color: Colors.white)),
          TrackingElement(
              color: const Color(0xFF8BEF11),
              iconData: Icons.directions_run,
              unit: 'm',
              max: 5000,
              daysInPast: widget.daysInPast),
          TrackingElement(
              color: const Color(0xFF3B53EA),
              iconData: Icons.local_drink,
              unit: 'ml',
              max: 3000,
              daysInPast: widget.daysInPast),
          TrackingElement(
              color: const Color(0xFFC42541),
              iconData: Icons.fastfood,
              unit: 'kcal',
              max: 1800,
              daysInPast: widget.daysInPast),
        ],
      ),
    );
  }
}

class TrackingElement extends StatefulWidget {
  const TrackingElement(
      {Key? key,
        required this.color,
        required this.iconData,
        required this.unit,
        required this.max,
        required this.daysInPast})
      : super(key: key);

  final Color color;
  final IconData iconData;
  final String unit;
  final double max;
  final int daysInPast;

  @override
  _TrackingElementState createState() => _TrackingElementState();
}

class _TrackingElementState extends State<TrackingElement> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int _counter = 0;
//  int _interv = 200;
  double _progress = 0;
  var now = DateTime.now();
  String _storageKey = '';

  void _incrementCounter() async {
    setState(() {
      _counter += _value;
      _progress = _counter / widget.max;
    });
    (await _prefs).setInt(_storageKey, _counter);
  }

  @override
  void initState() {
    super.initState();
    _storageKey =
    '${now.year}-${now.month}-${now.day - widget.daysInPast}_${widget.unit}';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _prefs.then((prefs) {
      setState(() {
        _counter = prefs.getInt(_storageKey) ?? 0;
        _progress = _counter / widget.max;
      });
    });
  }

  int _value = 100;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _incrementCounter,
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(32.0, 48.0, 32.0, 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                widget.iconData,
                color: Colors.white70,
                size: 50,
              ),
              Text('$_counter / ${widget.max.toInt()} ${widget.unit}',
                  style: const TextStyle(color: Colors.white70, fontSize: 32)),
            ],
          ),
        ),
        LinearProgressIndicator(
          value: _progress.toDouble(),
          color: widget.color,
          backgroundColor: const Color(0x40FFFFFF),
          minHeight: 12.0,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(25, 5, 25, 2.5),
          child: Slider(
            min: 100,
            max: 900,
            inactiveColor: const Color(0xFF00AF32),
            activeColor: Colors.teal,
            divisions: 8,
            label: _value.toString() + widget.unit,
            value: _value.toDouble(),
            onChanged: (value) {
              setState(() {
                _value = value.toInt();
              });
            },
          ),
        )
      ]),

      /*  child: TextFormField(
              decoration: InputDecoration(
                labelText: _value,
                labelStyle: TextStyle(color: Colors.black,
                                      fontSize: 10),
                filled: true,
                fillColor: Colors.lightGreenAccent.shade100,
              ),
              scrollPadding: const EdgeInsets.symmetric(),
              onChanged: (String txt) => _interv = int.parse(txt),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.5,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ), */
    );
  }
}

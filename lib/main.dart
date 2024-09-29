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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
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
  var _isCelsius = true;
  var results = [];

  void _changeMode(index) {
    setState(() {
      _isCelsius = index == 0;
    });
  }

  void _calculateTemperature() {
    final temperature = double.parse(_temperatureController.text);

    final result =
        _isCelsius ? (temperature * 9 / 5) + 32 : (temperature - 32) * 5 / 9;

    setState(() {
      results.insert(0,
          "$temperature ${_isCelsius ? '°C' : '°F'} = ${result.toStringAsFixed(2)} ${_isCelsius ? '°F' : '°C'}");
    });
  }

  final TextEditingController _temperatureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Center(
            child: Column(
              children: [
                ToggleButtons(
                  isSelected: [_isCelsius, !_isCelsius],
                  onPressed: _changeMode,
                  children: const [
                    Text('°C'),
                    Text('°F'),
                  ],
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _temperatureController,
                  decoration: InputDecoration(
                    labelText: 'Temperature',
                    hintText: 'Enter temperature',
                    suffix: Text(_isCelsius ? '°C' : '°F'),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (_temperatureController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text('Error'),
                            content: Text('Please enter a number'),
                          );
                        },
                      );
                      return;
                    }
                    _calculateTemperature();
                  },
                  child: const Text('Convert'),
                ),
                const SizedBox(height: 20.0),
                const Flex(
                  direction: Axis.horizontal,
                  children: [
                    Text(
                      'History',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 1.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          child: Text(results[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

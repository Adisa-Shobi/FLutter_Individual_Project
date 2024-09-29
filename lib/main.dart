// Main application entry point
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Main page of the application
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isCelsius = true;
  var results = [];
  final TextEditingController _temperatureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTemperatureModeToggle(),
                const SizedBox(height: 20.0),
                _buildTemperatureInput(),
                const SizedBox(height: 20.0),
                _buildConvertButton(),
                const SizedBox(height: 20.0),
                _buildHistorySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds the temperature mode toggle (Celsius/Fahrenheit)
  Widget _buildTemperatureModeToggle() {
    return Center(
      child: ToggleButtons(
        isSelected: [_isCelsius, !_isCelsius],
        onPressed: _changeMode,
        children: const [
          Text('°C'),
          Text('°F'),
        ],
      ),
    );
  }

  // Builds the temperature input field
  Widget _buildTemperatureInput() {
    return TextFormField(
      controller: _temperatureController,
      decoration: InputDecoration(
        labelText: 'Temperature',
        hintText: 'Enter temperature',
        suffix: Text(_isCelsius ? '°C' : '°F'),
      ),
      keyboardType: TextInputType.number,
    );
  }

  // Builds the convert button
  Widget _buildConvertButton() {
    return ElevatedButton(
      onPressed: _handleConvert,
      child: const Text('Convert'),
    );
  }

  // Builds the history section
  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'History',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 20.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
      ],
    );
  }

  // Handles the temperature mode change
  void _changeMode(int index) {
    setState(() {
      _isCelsius = index == 0;
    });
  }

  // Handles the convert button press
  void _handleConvert() {
    if (_temperatureController.text.isEmpty) {
      _showErrorDialog();
      return;
    }
    _calculateTemperature();
  }

  // Shows an error dialog when input is empty
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Error'),
          content: Text('Please enter a number'),
        );
      },
    );
  }

  // Calculates the temperature conversion
  void _calculateTemperature() {
    final temperature = double.parse(_temperatureController.text);
    final result = _isCelsius
        ? _celsiusToFahrenheit(temperature)
        : _fahrenheitToCelsius(temperature);

    setState(() {
      results.insert(0,
          "${_isCelsius ? 'C to F' : 'F to C'}: $temperature => ${result.toStringAsFixed(2)}");
    });
  }

  // Converts Celsius to Fahrenheit
  double _celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  // Converts Fahrenheit to Celsius
  double _fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }
}

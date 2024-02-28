import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bouncing Ball App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double _currentSpeedValue = 1;
  int _currentColorValue = 0;
  double _ballPosition = 0; // Initial position of the ball

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000 ~/ _currentSpeedValue.toInt()),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          // Update ball position to bounce within the container
          _ballPosition = 250 * _animation.value;
        });
      });

    _controller.repeat(reverse: true);
    _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.repeat(reverse: true);
  }

  void _stopAnimation() {
    _controller.stop();
  }

  // Get color label based on current color division
  String _getColorLabel(int value) {
    switch (value) {
      case 0:
        return 'Black';
      case 20:
        return 'Red';
      case 40:
        return 'Orange';
      case 60:
        return 'Green';
      case 80:
        return 'Blue';
      case 100:
        return 'Purple';
      default:
        return '';
    }
  }

  // Get color based on current color division
  Color _getColorFromDivision(int value) {
    switch (value) {
      case 0:
        return Colors.black;
      case 20:
        return Colors.red;
      case 40:
        return Colors.orange;
      case 60:
        return Colors.green;
      case 80:
        return Colors.blue;
      case 100:
        return Colors.purple;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 3,
        title: const Text('Bouncing Ball App'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 5,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: _ballPosition,
                    left: 125, // Center the ball horizontally
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: _getColorFromDivision(_currentColorValue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  onPressed: _startAnimation,
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: _stopAnimation,
                  child: const Text(
                    'Stop',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'Speed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Slider(
                  value: _currentSpeedValue,
                  min: 1,
                  max: 5,
                  label: _currentSpeedValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSpeedValue = value;
                      _controller.duration =
                          Duration(milliseconds: 1000 ~/ value.toInt());
                      if (_controller.isAnimating) {
                        _controller.repeat(reverse: true);
                      }
                    });
                  },
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'Color',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Slider(
                  value: _currentColorValue.toDouble(),
                  max: 100,
                  divisions:
                      5, // Divisions for Black, Red, Orange, Green, Blue, and Purple
                  label: _getColorLabel(_currentColorValue),
                  onChanged: (double value) {
                    setState(() {
                      _currentColorValue = value.toInt();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

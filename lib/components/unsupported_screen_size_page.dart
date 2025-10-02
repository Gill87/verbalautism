import 'package:flutter/material.dart';

class UnsupportedScreenSizePage extends StatelessWidget {
  const UnsupportedScreenSizePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 150, 243),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              const Text(
                'Unsupported Screen Size',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'This application is not optimized for small screen sizes. Please use a device with a larger screen for the best experience.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Optionally, you can add functionality to close the app or navigate elsewhere
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
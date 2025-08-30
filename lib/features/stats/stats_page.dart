import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Stats Overview', style: GoogleFonts.ubuntu()),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Stats Page Content Here'),
      ),
    );
  }
}
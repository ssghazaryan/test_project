import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllertScreen extends StatelessWidget {
  final String allert;
  const AllertScreen({
    super.key,
    this.allert = 'For the application of the application you need the Internet',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            allert,
            textAlign: TextAlign.center,
            style: GoogleFonts.ubuntu(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ),
      ),
    );
  }
}

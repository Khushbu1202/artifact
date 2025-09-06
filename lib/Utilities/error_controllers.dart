import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';

class ErrorControllers extends StatelessWidget {
  final String error;

  const ErrorControllers({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Text(error,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                color: ColorX.pinkX
            )));
  }
}


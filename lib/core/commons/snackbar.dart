import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/palette.dart';
import 'global_variables/global_variables.dart';

void showPrimarySnackBar(
  BuildContext context,
  String text,
) {
  if (context.mounted) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Palette.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(width * 0.04),
              topRight: Radius.circular(width * 0.04),
            ),
          ),
          content: Text(
            text,
            style: GoogleFonts.urbanist(
              color: Palette.blackColor,
              fontWeight: FontWeight.w600,
              fontSize: width * 0.04,
            ),
          ),
        ),
      );
  }
}

Future<bool?> confirmQuitDialog(BuildContext context) => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Palette.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(
          'Do You want to Quit?',
          style: GoogleFonts.urbanist(
            fontSize: 17,
            color: Colors.white,

            // color: Colors.white
          ), // Set title text color to white
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Container(
              height: height * 0.04,
              width: width * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Palette.secondaryColor,
              ),
              child: Center(
                child: Text(
                  'No',
                  style: GoogleFonts.urbanist(color: Palette.whiteColor),
                ),
              ),
            ), // Set button text color to white
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Container(
              height: height * 0.04,
              width: width * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Palette.secondaryColor,
              ),
              child: Center(
                child: Text(
                  'Yes',
                  style: GoogleFonts.urbanist(color: Palette.whiteColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );

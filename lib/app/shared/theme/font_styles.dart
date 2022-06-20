import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

lightStyle({required double? fontSize, required Color? color, double? height}) {
  return GoogleFonts.openSans(
      fontSize: fontSize,
      color: color,
      height: height ?? height,
      fontWeight: FontWeight.w200);
}

regularStyle(
    {required double? fontSize, required Color? color, double? height}) {
  return GoogleFonts.openSans(
      fontSize: fontSize,
      color: color,
      height: height ?? height,
      fontWeight: FontWeight.w400);
}

TextStyle boldStyle(
    {required double? fontSize, required Color? color, double? height}) {
  return GoogleFonts.openSans(
      fontSize: fontSize,
      color: color,
      height: height ?? height,
      fontWeight: FontWeight.bold);
}

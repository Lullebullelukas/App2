import 'package:flutter/material.dart';

// Deprecated: Define in theme.dart instead. Kept since the colors might be useful
// final ThemeData dsekTheme = ThemeData(
//   brightness: Brightness.light,
//   primaryColor: Color(0xFFF17F9F),
//   colorScheme:
//       ThemeData().colorScheme.copyWith(primary: Color(0xFFF17F9F), secondary: Color.fromARGB(255, 236, 148, 173)),
//   textButtonTheme: TextButtonThemeData(
//       style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF17F9F)),
//           foregroundColor: MaterialStateProperty.all<Color>(Colors.white))),
//   bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFFCF6D89)),
//   inputDecorationTheme: InputDecorationTheme(
//     focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFF17F9F))),
//     labelStyle: TextStyle(color: Color(0xFFF17F9F)),
//     hintStyle: TextStyle(color: Colors.grey[600]),
//   ),
// );

// final List<Color> dsekBackground = [
//   Color(0xFFF17F9F),
//   Color(0xFFCF6D89),
// ];

final bool isAprilFools = (DateTime(2024, 4, 1, 0, 0).compareTo(DateTime.now()) < 0 &&
    DateTime(2024, 4, 2, 0, 0).compareTo(DateTime.now()) > 0);

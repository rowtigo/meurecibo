import 'package:flutter/material.dart';
import 'package:meu_recibo/ui/Darshboard.dart';
import 'package:meu_recibo/ui/VendaPage.dart';
import 'package:splashscreen/splashscreen.dart';

import 'model/venda_helper.dart';

void main() {
  VendasHelper helper = VendasHelper();
  helper.getTotalVendas();
  runApp(MaterialApp(

    home: Dashboard(),
    theme: ThemeData(
      accentColor: Colors.pinkAccent[400],
      primaryColor: Colors.pink,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      accentColor: Colors.pinkAccent[400],
      primaryColor: Colors.pink,
    ),
    themeMode: ThemeMode.dark,
  ));
}

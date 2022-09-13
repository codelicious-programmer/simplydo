import 'package:flutter/material.dart';

class Constants {
  static const accent1 = Color.fromRGBO(178, 164, 255, 1.0);
  static const accent2 = Color.fromRGBO(255, 180, 180, 1.0);
  static const accent3 = Color.fromRGBO(255, 222, 180, 1.0);
  static const accent4 = Color.fromRGBO(255, 249, 202, 1.0);

  static splashscreentext(String text) {
    return Text(
      "Simply Do",
      style: TextStyle(
        fontFamily: 'Pacifico',
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      
      textAlign: TextAlign.start,
    );
  }

  


  

  static disptitle(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline1,
      textAlign: TextAlign.center,
    );
  }

  static displabel(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium,
      textAlign: TextAlign.left,
    );
  }

  static disptodoitem(String text) {
    var fintext = text[0].toUpperCase() + text.substring(1, text.length);

    return Text(
      fintext,
      style: const TextStyle(fontSize: 25, fontFamily: 'Arima'),
    );
  }
}

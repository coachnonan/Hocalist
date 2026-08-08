import 'package:flutter/services.dart';

Future<void> loadHocalistTestFonts() async {
  final fonts = <String, List<String>>{
    'Nunito': ['assets/fonts/nunito/Nunito-Variable.ttf'],
    'Lexend': ['assets/fonts/lexend/Lexend[wght].ttf'],
    'Archivo': ['assets/fonts/archivo/Archivo-Variable.ttf'],
  };

  for (final entry in fonts.entries) {
    final loader = FontLoader(entry.key);
    for (final asset in entry.value) {
      loader.addFont(rootBundle.load(asset));
    }
    await loader.load();
  }
}

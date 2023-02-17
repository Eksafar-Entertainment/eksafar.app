import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:google_fonts/google_fonts.dart';

 const MaterialColor primarycolor = MaterialColor(_primarycolorPrimaryValue, <int, Color>{
  50: Color(0xFFF7E6E7),
  100: Color(0xFFEBC0C4),
  200: Color(0xFFDD969D),
  300: Color(0xFFCF6B75),
  400: Color(0xFFC54C58),
  500: Color(_primarycolorPrimaryValue),
  600: Color(0xFFB52734),
  700: Color(0xFFAC212C),
  800: Color(0xFFA41B25),
  900: Color(0xFF961018),
});
 const int _primarycolorPrimaryValue = 0xFFBB2C3A;

class App extends StatelessWidget {
  final Store<AppState> store;
  const App({super.key, required this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child:MaterialApp(
          title: 'Eksafar',
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: primarycolor,
            primaryColor: primarycolor,
              useMaterial3: true,
              fontFamily: GoogleFonts.outfit().fontFamily,
              appBarTheme: const AppBarTheme(
                  backgroundColor: primarycolor
              ),
            cardColor: Colors.white.withOpacity(0.03),
            cardTheme: CardTheme(
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: Colors.white.withOpacity(0.03))
              )
            )
          ),
          themeMode: ThemeMode.dark,
          home: const MainScreen(),
        )
    );
  }
}

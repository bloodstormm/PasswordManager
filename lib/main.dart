import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'paginas/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Teste app",
        theme: ThemeData(primarySwatch: Colors.orange),
        initialRoute: HomePage.tag,
        routes: {
          HomePage.tag: (context) => HomePage(),
        });
  }
}

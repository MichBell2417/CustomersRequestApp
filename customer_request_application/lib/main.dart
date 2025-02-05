import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( HelloWorld() );
}

class StatoSaluto extends ChangeNotifier {
  String testo = "decir hola!";
  void cambiaTesto(String t) {
    testo = t;
    notifyListeners();
  }
}

class HelloWorld extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(

      create: (context) => StatoSaluto(),
      child: MaterialApp(
        home: SchermataPrincipale(),
      ),
    );
  }
}

class SchermataPrincipale extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var statoApplicazione = context.watch<StatoSaluto>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Me primera aplicación '),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
             statoApplicazione.cambiaTesto("Hola mundo!");
          },
          child: Text( statoApplicazione.testo ),
        ),
      ),
    );
  }
}
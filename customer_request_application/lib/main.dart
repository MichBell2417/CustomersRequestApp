import 'package:customer_request_application/classes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(PrincipalPage());
}

class PrincipalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => applicationController(),
      child: MaterialApp(
        home: FirstScreen(),
      ),
    );
  }
}
//
enum SingingCharacter { casa, tienda }
//Here you write the interface
class FirstScreen extends StatelessWidget {
  var sectionTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final nombreController = TextEditingController();
  final numeroDeTelefonoController = TextEditingController();
  final emailController = TextEditingController();
  final customerNumberController = TextEditingController();
  SingingCharacter? radioButtonSelection;
  @override
  Widget build(BuildContext context) {
    var customersController = context.watch<applicationController>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Control del cliente'),
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Informationes de cliente",
                    style: sectionTitle,
                  ),
                  Row(children: [
                    Text("nombre: "),
                    Expanded(
                      child: TextFormField(
                        controller: nombreController,
                      ),
                    ),
                  ]),
                  Row(children: [
                    Text("número telefónico: "),
                    Expanded(
                      child: TextFormField(
                        controller: numeroDeTelefonoController,
                      ),
                    ),
                  ]),
                  Row(children: [
                    Text("e-Mail: "),
                    Expanded(
                      child: TextFormField(
                        controller: emailController,
                      ),
                    ),
                  ]),
                  ElevatedButton(
                      onPressed: () {
                        print("salvataggio cliente");
                      },
                      child: Text("SAVE"))
                ],
              ),
            )),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "contrato de cliente",
                    style: sectionTitle,
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Número de cliente")),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: customerNumberController,
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              print("ricerca persona");
                            },
                            child: Text("search")),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(child: Text("tipo de contrato: ")),
                        Expanded(child: Text("horas restantes: ")),
                      ],
                    ),
                  ),
                  Text("tipo de asistencia"),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: Text("En casa del cliente"),
                            value: SingingCharacter.casa,
                            groupValue: radioButtonSelection,
                            onChanged: (SingingCharacter? value) {
                              radioButtonSelection = value!;
                            }),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: Text("En la tienda"),
                            value: SingingCharacter.tienda,
                            groupValue: radioButtonSelection,
                            onChanged: (SingingCharacter? value) {
                              radioButtonSelection = value!;
                            }),
                      ),
                    ],
                  )
                ],
              ),
            ))
          ],
        ));
  }
}

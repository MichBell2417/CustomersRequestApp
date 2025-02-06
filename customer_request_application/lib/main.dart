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
      create: (context) => ApplicationController(),
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
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  SingingCharacter? radioButtonSelection;
  @override
  Widget build(BuildContext context) {
    var customersController = context.watch<ApplicationController>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Control del cliente'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 400,
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
              Container(
                  height: 400,
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
                                    if (customersController.findNumberCustomer(
                                        customerNumberController.text)) {
                                      nombreController.text =
                                          customersController.customer!.name;
                                      emailController.text =
                                          customersController.customer!.eMail;
                                      numeroDeTelefonoController.text =
                                          customersController
                                              .customer!.phoneNumber
                                              .toString();
                                    } else {
                                      customerNumberController.text =
                                          "Error con cliente";
                                    }
                                  },
                                  child: Text("search")),
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      "tipo de contrato: ${customersController.customer != null ? customersController.customer!.contractType : ""}")),
                              Expanded(
                                  child: Text(
                                      "horas restantes: ${customersController.customer != null ? customersController.customer!.remainingContractTimeStr() : ""}")),
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
                                    customersController.serviceInShop(false);
                                  }),
                            ),
                            Expanded(
                              child: RadioListTile(
                                  title: Text("En la tienda"),
                                  value: SingingCharacter.tienda,
                                  groupValue: radioButtonSelection,
                                  onChanged: (SingingCharacter? value) {
                                    radioButtonSelection = value!;
                                    customersController.serviceInShop(true);
                                  }),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      customersController.selectTime(
                                          context, true);
                                    },
                                    child: Text("Hora de inicio")),
                                Text("Inicio: ${customersController.startTime}")
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      customersController.selectTime(
                                          context, false);
                                    },
                                    child: Text("Hora de fin")),
                                Text("Fin: ${customersController.endTime}")
                              ],
                            )),
                            Expanded(
                                child: Column(children: [
                              Text(
                                  "horas de trabajo reales: ${customersController.workHoursString()}"),
                              Text(
                                  "horas de trabajo contadas: ${customersController.workHoursStringContadas()}")
                            ]))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: ElevatedButton(onPressed: (){
                              if(customersController.customer!=null){
                                customersController.removeHours();
                              }else{
                                customerNumberController.text="introduzca un número de cliente";
                              }
                            }, child: Text("Save"))),
                            Expanded(child: ElevatedButton(onPressed: (){}, child: Text("View Data"))),
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}

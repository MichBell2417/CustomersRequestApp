import 'package:customer_request_application/classes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

/*
import 'package:mysql_client/mysql_client.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';*/

void main() {
  /*final conn = ConnectionSettings(
      host: "192.168.0.211", // Add your host IP address or server name
      port: 3306, // Add the port the server is running on
      user: "tablet", // Your username
      password: "123456", // Your password
      db: "divermatica", // Your DataBase name
    );

  final database = await MySqlConnection.connect(conn);
  */
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
  var signTextSyle = TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
  final nombreController = TextEditingController();
  final numeroDeTelefonoController = TextEditingController();
  final emailController = TextEditingController();
  final customerNumberController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final streetController = TextEditingController();
  SingingCharacter? radioButtonSelection;

  @override
  Widget build(BuildContext context) {
    var customersController = context.watch<ApplicationController>();
    Widget graphicPartContract = Row(children: [
      Expanded(child: Text("seleccione un tipo de contrato: ")),
      Expanded(
        child: DropdownMenu<String>(
          initialSelection: "-------",
          onSelected: (String? value) {
            customersController.selectedContract = value!;
          },
          dropdownMenuEntries: customersController.contractTypes
              .map<DropdownMenuEntry<String>>((ContractType value) {
            return DropdownMenuEntry<String>(
                value: value.name, label: value.name);
          }).toList(),
        ),
      ),
    ]);

    final SignatureController controllerCustomers = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
    var signatureCanvasCustomers = Signature(
      controller: controllerCustomers,
      width: 500,
      height: 250,
      backgroundColor: Colors.white,
    );

    final SignatureController controllerSAT = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
    var signatureCanvasSAT = Signature(
      controller: controllerSAT,
      width: 500,
      height: 250,
      backgroundColor: Colors.white,
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Control del cliente'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  color: const Color.fromARGB(255, 123, 168, 204),
                  height: 400,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Row(children: [
                          Text("Calle: "),
                          Expanded(
                            child: TextFormField(
                              controller: streetController,
                            ),
                          ),
                        ]),
                        Container(
                            child: customersController.customer == null
                                ? graphicPartContract
                                : null),
                        ElevatedButton(
                            onPressed: () {
                              if (customersController.customer != null) {
                                try {
                                  if (!customersController.upgradeData(
                                      int.parse(customerNumberController.text),
                                      nombreController.text,
                                      emailController.text,
                                      numeroDeTelefonoController.text,
                                      streetController.text)) {
                                    customersController.alert(
                                        context, "Error", "Not upgraded");
                                  } else {
                                    customersController.alert(
                                        context,
                                        "Upgraded",
                                        "The customer has been upgraded");
                                  }
                                } catch (e) {
                                  customersController.alert(
                                        context,
                                        "Error",
                                        "check if the data are correct");
                                }
                              } else {
                                if (customersController.addCustomer(
                                    nombreController.text,
                                    emailController.text,
                                    numeroDeTelefonoController.text,
                                    streetController.text)) {
                                  nombreController.text = "";
                                  emailController.text = "";
                                  numeroDeTelefonoController.text = "";
                                  streetController.text = "";
                                  customersController.alert(context, "Saved",
                                      "the customer has been saved");
                                } else {
                                  customersController.alert(
                                      context,
                                      "Not saved",
                                      "the customer hasn't been saved");
                                }
                              }
                            },
                            child: Text(customersController.customer != null
                                ? "UPGRADE"
                                : "SAVE")),
                      ],
                    ),
                  )),
              Container(
                  color: const Color.fromARGB(255, 123, 168, 204),
                  height: 350,
                  child: Container(
                    padding: EdgeInsets.all(10),
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
                                              .customer!.phoneNumber;
                                      streetController.text =
                                          customersController.customer!.street;
                                    } else {
                                      customersController.alert(
                                          context,
                                          "Error",
                                          "The customer doesn't exist. To create it fill the information and save.");
                                      nombreController.text = "";
                                      emailController.text = "";
                                      numeroDeTelefonoController.text = "";
                                      streetController.text = "";
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
                                      "tipo de contrato: ${customersController.customer != null ? customersController.customer!.contractType.name : ""}")),
                              Expanded(
                                child: Text(
                                  "horas restantes: ${customersController.customer != null ? customersController.customer!.remainingContractTimeStr() : ""}",
                                  style: customersController.customer != null &&
                                          customersController.customer!
                                                  .remainingContractTime.hour ==
                                              0 &&
                                          customersController
                                                  .customer!
                                                  .remainingContractTime
                                                  .minute ==
                                              0
                                      ? TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text("tipo de asistencia"),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                  title: Text(
                                    "En casa del cliente",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  value: SingingCharacter.casa,
                                  groupValue: radioButtonSelection,
                                  onChanged: (SingingCharacter? value) {
                                    radioButtonSelection = value!;
                                    customersController.serviceInShop(false);
                                  }),
                            ),
                            Expanded(
                              child: RadioListTile(
                                  title: Text("En la tienda",
                                      style: TextStyle(fontSize: 15)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (customersController.customer !=
                                          null) {
                                        if (customersController.removeHours()) {
                                          customersController.alert(context,
                                              "Saved", "tiempo ahorrado");
                                        } else {
                                          customersController.alert(context,
                                              "Error", "error al quitar horas");
                                        }
                                      } else {
                                        customersController.alert(
                                            context,
                                            "Error",
                                            "introduzca un numero de cliente");
                                      }
                                    },
                                    child: Text("Save"))),
                            Spacer(),
                            Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text("View Data"))),
                          ],
                        )
                      ],
                    ),
                  )),
              Container(
                color: const Color.fromARGB(255, 123, 168, 204),
                height: 650,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Firma SAT",
                          style: signTextSyle,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              controllerSAT.clear();
                            },
                            child: Text("clean"))
                      ],
                    ),
                    signatureCanvasSAT,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Firma Cliente",
                          style: signTextSyle,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              controllerCustomers.clear();
                            },
                            child: Text("clean")),
                      ],
                    ),
                    signatureCanvasCustomers,
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

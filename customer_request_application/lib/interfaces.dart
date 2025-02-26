import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:customer_request_application/classes.dart';
import 'package:signature/signature.dart';

late ApplicationController customersController;
///-------------------------------- class with the interface for the menu
class Menu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    customersController = context.watch<ApplicationController>();
    if (!customersController.connectionStatus) {
      customersController.classContext = context;
      customersController.connectionDb();
    }
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: 
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            tileMode: TileMode.clamp,
            colors: <Color>[Color.fromARGB(0, 255, 255, 255), Color.fromARGB(63, 123, 168, 204), Color.fromARGB(255, 123, 168, 204),Color.fromARGB(255, 123, 168, 204)]),
          ),
        ),
        leading: Image.asset("resources/image/DivermaticaLogo.jpg", ),
        title: Text('Divermatica', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
      ),
      body: Stack(
        children: [
           Center(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 300,
                height: 75,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return customerView();
                    }));
                  }, child: Text("Lista de cliente")
                ),
              ),
              SizedBox(
                width: 300,
                height: 75,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return BuenoDeHoras();
                    }));
                  }, child: Text("Bonus de horas")
                ),
              ),
              SizedBox(
                width: 300,
                height: 75,
                child: ElevatedButton(
                  onPressed: (){
                    // the interface have to be done 
                    //Navigator.push(context, null);
                  }, child: Text("Resguardo de deposito")
                ),
              ),
            ],
          ),
        ),
        if(!customersController.connectionStatus)
        Opacity(
            opacity: 0.8,
            child: Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Connection to database with IP address: ${customersController.IPaddress}", 
                      style: TextStyle(color: Colors.blueAccent, fontSize: 20,),),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///-------------------------------- class with the interface to control the customers
class customerView extends StatelessWidget{
  final customerSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: 
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            tileMode: TileMode.clamp,
            colors: <Color>[Color.fromARGB(0, 255, 255, 255), Color.fromARGB(63, 123, 168, 204), Color.fromARGB(255, 123, 168, 204),Color.fromARGB(255, 123, 168, 204)]),
          ),
        ),
        leading: Image.asset("resources/image/DivermaticaLogo.jpg", ),
        title: Text('Divermatica', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextFormField(controller: customerSearchController,),
              ElevatedButton.icon(onPressed: () async {
                  try {
                    if (await customersController.findCustomerFromNumberdb(int.parse(customerSearchController.text))) {
                      /*nombreController.text = customersController.customer!.name;
                      emailController.text = customersController.customer!.eMail;
                      numeroDeTelefonoController.text = customersController.customer!.phoneNumber;
                      streetController.text = customersController.customer!.street;
                      cpController.text = customersController.customer!.cp;
                      dniController.text = customersController.customer!.dni;*/
                    } else {
                      customersController.customer = null;
                      customersController.alert(
                          context,
                          "Error",
                          "The customer doesn't exist. To create it fill the information and save or update data. Remember the client number is composed just by number.");
                      nombreController.text = "";
                      emailController.text = "";
                      numeroDeTelefonoController.text = "";
                      streetController.text = "";
                    }
                  } catch (e) {
                    customerNumberController.text="write customer number";
                    customersController.notifyListenersLocal();
                  }
              }, label: Icon(Icons.search))
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index){
                return Card(
                  child: ListTile(
                    tileColor: const Color.fromARGB(255, 184, 223, 255),
                    title: Text(customersController.customers[index].name),
                    subtitle: Text(customersController.customers[index].dni),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),//Icons.arrow_circle_right_outlined
                    onTap:() {
                      showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Cliente n. ${customersController.customers[index].id}"), TextButton.icon(onPressed: (){Navigator.pop(context);}, label: Icon(Icons.close, size: 20,)), ],),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(children: [
                              Text("Nombre: ",style: TextStyle(fontWeight: FontWeight.bold),),
                              Text(customersController.customers[index].name),
                            ],),
                            Row(
                              children: [
                                Text("Numero telefonico: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("${customersController.customers[index].phoneNumber}"),
                              ],
                            ),
                            Row(
                              children: [
                                Text("eMail: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("${customersController.customers[index].eMail}"),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Direccion: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("${customersController.customers[index].street}"),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Codigo postal: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(customersController.customers[index].cp),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Tipo de contrato: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("${customersController.customers[index].contractType.name}"),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Tiempo restante: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(customersController.customers[index].remainingContractTimeStr()),
                              ],
                            ),
                            Row(
                              children: [
                                Text("DNI: ", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(customersController.customers[index].dni),
                              ],
                            ),
                            ElevatedButton(onPressed: ()async{  
                              if (await customersController.findCustomerFromNumberdb(
                                customersController.customers[index].id)) {
                                nombreController.text =
                                    customersController.customer!.name;
                                emailController.text =
                                    customersController.customer!.eMail;
                                numeroDeTelefonoController.text =
                                    customersController.customer!.phoneNumber;
                                streetController.text =
                                    customersController.customer!.street;
                                cpController.text =
                                    customersController.customer!.cp;
                                dniController.text =
                                    customersController.customer!.dni;
                              }
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Editor"), TextButton.icon(onPressed: (){Navigator.pop(context);}, label: Icon(Icons.close, size: 20,)), ],),
                                  content: SingleChildScrollView(
                                    child:Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [ 
                                      textfieldCustomer,
                                      Container(
                                        padding: EdgeInsets.fromLTRB(0,10,0,0),
                                        child: ElevatedButton(onPressed: (){
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          customersController.upgradeData(
                                          customersController.customers[index].id,
                                          nombreController.text,
                                          emailController.text,
                                          numeroDeTelefonoController.text,
                                          streetController.text, cpController.text, dniController.text);
                                        }, child: Icon(Icons.save)),
                                      )
                                    ],
                                  ),
                                )));
                            }, child: Icon(Icons.edit_document))
                          ],
                        )
                        ),
                      );
                    },
                  ),
                );
              },
              itemCount: customersController.customers.length),
          )
        ],
      ),
    );
  }
}

final customerNumberController = TextEditingController();
final streetController = TextEditingController();
final nombreController = TextEditingController();
final numeroDeTelefonoController = TextEditingController();
final emailController = TextEditingController();
final cpController = TextEditingController();
final dniController = TextEditingController();
/// this variable contains the graphic part of the textField
Widget textfieldCustomer = 
            Column(
              children: [
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
                  Text("Direccion: "),
                  Expanded(
                    child: TextFormField(
                      controller: streetController,
                    ),
                  ),
                ]),
                Row(children: [
                  Text("Còdigo Postal: "),
                  Expanded(
                    child: TextFormField(
                      controller: cpController,
                    ),
                  ),
                ]),
                Row(children: [
                  Text("DNI: "),
                  Expanded(
                    child: TextFormField(
                      controller: dniController,
                    ),
                  ),
                ]),
              ],
            );
              
class addCustomer extends StatelessWidget{
  var sectionTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

   Widget build(BuildContext context) {
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
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: 
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            tileMode: TileMode.clamp,
            colors: <Color>[Color.fromARGB(0, 255, 255, 255), Color.fromARGB(63, 123, 168, 204), Color.fromARGB(255, 123, 168, 204),Color.fromARGB(255, 123, 168, 204)]),
          ),
        ),
        leading: Image.asset("resources/image/DivermaticaLogo.jpg", ),
        title: Text('Divermatica', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
      ),
      body: Container(
        color: const Color.fromARGB(255, 123, 168, 204),
        height: 500,
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
              textfieldCustomer,
              Container(
                  child: customersController.customer == null
                      ? graphicPartContract
                      : null),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (customersController.customer != null) {
                        customersController.upgradeData(
                          int.parse(customerNumberController.text),
                          nombreController.text,
                          emailController.text,
                          numeroDeTelefonoController.text,
                          streetController.text,cpController.text,dniController.text);
                      } else{
                        if(await customersController.addCustomer(
                          nombreController.text,
                          emailController.text,
                          numeroDeTelefonoController.text,
                          streetController.text,cpController.text,dniController.text)){
                            nombreController.text = "";
                            emailController.text = "";
                            numeroDeTelefonoController.text = "";
                            streetController.text = "";
                            cpController.text = "";
                            dniController.text = "";
                          }
                      }
                    },
                    child: Text(customersController.customer != null
                        ? "UPGRADE"
                        : "SAVE")
                    ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10,0,0,0),
                  child:
                  customersController.customer != null ? 
                  ElevatedButton(
                    onPressed: (){
                      customersController.customer=null;
                      nombreController.text = "";
                      emailController.text = "";
                      numeroDeTelefonoController.text = "";
                      streetController.text = "";
                      cpController.text = "";
                      dniController.text = "";
                      customersController.notifyListenersLocal();
                    }, 
                    child: Icon(
                      Icons.add_circle_outline_sharp,
                      color: Colors.blueGrey,
                      size: 24.0,
                      semanticLabel: 'add a new customers',
                    ),
                  ) : null
                ),
              ],
              ),
            ],
          ),
        )
      ),
    );
   }
}

///-------------------------------- class with the interface to manage the hours
enum SingingCharacter { casa, tienda }
class BuenoDeHoras extends StatelessWidget {
  var sectionTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  var signTextSyle = TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
  final customerNumberController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final streetController = TextEditingController();
  final nombreController = TextEditingController();
  final numeroDeTelefonoController = TextEditingController();
  final emailController = TextEditingController();
  TextStyle styleTextSearchField=TextStyle(color: Colors.black);
  SingingCharacter? radioButtonSelection;

  @override
  Widget build(BuildContext context) {
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
          flexibleSpace: 
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                tileMode: TileMode.clamp,
                colors: <Color>[Color.fromARGB(0, 255, 255, 255), Color.fromARGB(63, 123, 168, 204), Color.fromARGB(255, 123, 168, 204),Color.fromARGB(255, 123, 168, 204)]),
              ),
            ),
          leading: Image.asset("resources/image/DivermaticaLogo.jpg", ),
          title: Text('Divermatica', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                                style: styleTextSearchField,
                                controller: customerNumberController,
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      styleTextSearchField=TextStyle(color: Colors.black);
                                      if (await customersController.findCustomerFromNumberdb(
                                        int.parse(customerNumberController.text))) {
                                        nombreController.text =
                                            customersController.customer!.name;
                                        emailController.text =
                                            customersController.customer!.eMail;
                                        numeroDeTelefonoController.text =
                                            customersController
                                                .customer!.phoneNumber;
                                        streetController.text =
                                            customersController
                                                .customer!.street;
                                      } else {
                                        customersController.customer = null;
                                        customersController.alert(
                                            context,
                                            "Error",
                                            "The customer doesn't exist. To create it fill the information and save or update data. Remember the client number is composed just by number.");
                                        nombreController.text = "";
                                        emailController.text = "";
                                        numeroDeTelefonoController.text = "";
                                        streetController.text = "";
                                      }
                                    } catch (e) {
                                      styleTextSearchField=TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
                                      customerNumberController.text="write customer number";
                                      customersController.notifyListenersLocal();
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
                                  style: customersController.customer != null && customersController.customer!.remainingContractTime.hour == 0 && customersController.customer!.remainingContractTime.minute == 0
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
                                    onPressed: () async {
                                      if (customersController.customer !=
                                          null) {
                                        if (await customersController
                                            .removeHours(int.parse(
                                                customerNumberController
                                                    .text))) {
                                          customersController.alert(context,
                                              "Saved", "tiempo ahorrado");
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

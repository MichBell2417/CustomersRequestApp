import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:customer_request_application/classes.dart';
import 'package:signature/signature.dart';

late ApplicationController customersController;
///--------------------------------Class with the interface for the menu
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
    customersController = context.watch<ApplicationController>();
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
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: ElevatedButton(onPressed: (){
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Nuevo cliente"), TextButton.icon(onPressed: (){Navigator.pop(context);}, label: Icon(Icons.close, size: 20,)), ],),
                      content: SingleChildScrollView(
                        child:Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [ 
                          textfieldCustomer,
                          Row(children: [
                            Expanded(child: Text("Tipo de contrato: ", style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(
                              child: 
                              Padding(padding: EdgeInsets.all(10),child: DropdownMenu<String>(
                                initialSelection: "-------",
                                onSelected: (String? value) {
                                  customersController.selectedContract = value!;
                                },
                                dropdownMenuEntries: customersController.contractTypes
                                    .map<DropdownMenuEntry<String>>((ContractType value) {
                                  return DropdownMenuEntry<String>(
                                      value: value.name, label: value.name);
                                }).toList(),
                              ),)
                              
                            ),
                          ]),
                          Container(
                            padding: EdgeInsets.fromLTRB(0,10,0,0),
                            child: ElevatedButton(onPressed: (){
                              Navigator.pop(context);
                              customersController.addCustomer(
                              nombreController.text,
                              emailController.text,
                              numeroDeTelefonoController.text,
                              streetController.text, cpController.text, dniController.text);
                              customersController.selectedContract = "";
                            }, child: Icon(Icons.save)),
                          )
                        ],
                      ),
                    )));
                }, child: Icon(Icons.add_box_outlined)),),
                
                Expanded(flex: 3,child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: customerSearchController,
                    decoration: InputDecoration(
                        hintText: 'Buscar por nombre o numero telefonico...',
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic, //Italic style
                        ),
                    ),
                  ),
                )),
                ElevatedButton.icon(onPressed: () async {
                  var tmp = false;
                  if(customerSearchController.text.contains(RegExp(r'\d'))){
                    tmp = await customersController.pullCustomersFromPhoneNumber(customerSearchController.text);
                  }else if(customerSearchController.text.contains(RegExp(r'[a-zA-Z]'))){
                    tmp = await customersController.pullCustomersFromName(customerSearchController.text);
                  }else{
                    customersController.pullCustomers();
                    tmp=true;
                  }
                  if(!tmp){
                    customersController.alert(
                      // ignore: use_build_context_synchronously
                      context,
                      "Error",
                      "The customer doesn't exist. Check the data you inserted. "
                    );
                    customerSearchController.text = "";
                    customersController.pullCustomers();
                  }
                }, label: Icon(Icons.search))
              ],
            ),
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
                                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Editar cliente"), TextButton.icon(onPressed: (){Navigator.pop(context);cleanTextField();}, label: Icon(Icons.close, size: 20,)), ],),
                                  content: SingleChildScrollView(
                                    child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [ 
                                      textfieldCustomer,
                                      Container(
                                        padding: EdgeInsets.fromLTRB(0,10,0,0),
                                        child: ElevatedButton(onPressed: (){
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          customersController.upgradeData(
                                          customersController.customers[index].id,
                                          nombreController.text,
                                          emailController.text,
                                          numeroDeTelefonoController.text,
                                          streetController.text, cpController.text, dniController.text);
                                          cleanTextField();
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

final customerSearchController = TextEditingController();
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
        Text("nombre: ", style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: TextFormField(
            controller: nombreController,
          ),
        ),
      ]),
      Row(children: [
        Text("número telefónico: ", style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.phone,
            controller: numeroDeTelefonoController,
          ),
        ),
      ]),
      Row(children: [
        Text("e-Mail: ", style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
          ),
        ),
      ]),
      Row(children: [
        Text("Direccion: ", style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: TextFormField(
            controller: streetController,
          ),
        ),
      ]),
      Row(children: [
        Text("Còdigo Postal: ", style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: cpController,
          ),
        ),
      ]),
      Row(children: [
        Text("DNI: ", style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: TextFormField(
            controller: dniController,
          ),
        ),
      ]),
    ],
  );

void cleanTextField(){
  nombreController.text = "";
  emailController.text = "";
  numeroDeTelefonoController.text = "";
  streetController.text = "";
  cpController.text = "";
  dniController.text = "";
}

///-------------------------------- class with the interface to manage the hours
enum SingingCharacter { casa, tienda }

class BuenoDeHoras extends StatelessWidget {
  
  final customerSearchController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  
  SingingCharacter? radioButtonSelection;

  @override
  Widget build(BuildContext context) {
    customersController = context.watch<ApplicationController>();
    //The canvas for the customer signature
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

    //The canvas for the SAT signature
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
                  color: const Color.fromARGB(255, 255, 255, 255),
                  height: 350,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Contrato de cliente",
                          style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: customerSearchController,
                                decoration: InputDecoration(
                                    hintText: 'Buscar al cliente por nombre o numero telefonico...',
                                    hintStyle: TextStyle(
                                      fontStyle: FontStyle.italic, //Italic style
                                    ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    var tmp = false;
                                    if(customerSearchController.text.contains(RegExp(r'\d'))){
                                      tmp = await customersController.pullCustomersFromPhoneNumber(customerSearchController.text);
                                    }else if(customerSearchController.text.contains(RegExp(r'[a-zA-Z]'))){
                                      tmp = await customersController.pullCustomersFromName(customerSearchController.text);
                                    }else{
                                      customersController.pullCustomers();
                                      tmp=true;
                                    }
                                    if(!tmp){
                                      customersController.alert(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        "Error",
                                        "The customer doesn't exist. Check the data you inserted. "
                                      );
                                      customerSearchController.text = "";
                                      customersController.pullCustomers();
                                    }
                                  },child: Icon(Icons.search)
                                ),
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Tipo de contrato: ${customersController.customer != null ? customersController.customer!.contractType.name : ""}")),
                              Expanded(
                                child: Text(
                                  "Horas restantes: ${customersController.customer != null ? customersController.customer!.remainingContractTimeStr() : ""}",
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
                        Text("Tipo de asistencia"),
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
                                  "Horas de trabajo reales: ${customersController.workHoursString()}"),
                              Text(
                                  "Horas de trabajo contadas: ${customersController.workHoursStringContadas()}")
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
                                      if (customersController.customer != null) {
                                        if (await customersController.removeHours(int.parse(customerSearchController.text))) {
                                          customersController.alert(context,"Saved", "time updated");
                                        }
                                      } else {
                                        customersController.alert(context, "Error", "insert something...");
                                      }
                                    },
                                    child: Text("Save")
                                  )
                            ),
                            //Spacer(),
                            /*Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text("View Data")
                                  )
                            ),*/
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
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              controllerSAT.clear();
                            },
                            child: Text("Clean"))
                      ],
                    ),
                    signatureCanvasSAT,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Firma Cliente",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              controllerCustomers.clear();
                            },
                            child: Text("Clean")),
                      ],
                    ),
                    signatureCanvasCustomers,
                  ],
                ),
              )
            ],
          ),
        )
      );
   }
}

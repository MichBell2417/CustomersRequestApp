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
              /*SizedBox(
                width: 300,
                height: 75,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return BuenoDeHoras();
                    }));
                  }, child: Text("Bonus de horas")
                ),
              ),*/
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
                    leading: Icon(
                      customersController.customers[index].remainingContractTime.hour == 0 && customersController.customers[index].remainingContractTime.minute == 0 // Checks if the customer has time in his contract
                          ? Icons.cancel_outlined  // If the customer has time in his contract
                          : Icons.check_circle_outline_outlined,  // If the customer hasn't time in his contract
                    ),
                    title: Text(customersController.customers[index].name),
                    subtitle: Text(customersController.customers[index].dni),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),//other icon (Icons.arrow_circle_right_outlined)
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
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // fix the distribution of the buttons
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      customersController.setCustomer(customersController.customers[index]);
                                      return BuenoDeHoras();
                                    }));
                                  },
                                  child: Icon(Icons.timer),
                                ),
                              ),

                              SizedBox(width: 10),  // Spacer between buttons (optional, to slightly separate the buttons)
                              
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (await customersController.findCustomerFromNumberdb(
                                      customersController.customers[index].id,
                                    )) {
                                      nombreController.text = customersController.customer!.name;
                                      emailController.text = customersController.customer!.eMail;
                                      numeroDeTelefonoController.text =
                                          customersController.customer!.phoneNumber;
                                      streetController.text = customersController.customer!.street;
                                      cpController.text = customersController.customer!.cp;
                                      dniController.text = customersController.customer!.dni;
                                    }
                                    showDialog<String>(
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Editar cliente"),
                                            TextButton.icon(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                cleanTextField();
                                              },
                                              label: Icon(Icons.close, size: 20),
                                            ),
                                          ],
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              textfieldCustomer,
                                              Container(
                                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    customersController.upgradeData(
                                                      customersController.customers[index].id,
                                                      nombreController.text,
                                                      emailController.text,
                                                      numeroDeTelefonoController.text,
                                                      streetController.text,
                                                      cpController.text,
                                                      dniController.text,
                                                    );
                                                    cleanTextField();
                                                  },
                                                  child: Icon(Icons.save),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.edit_document),
                                ),
                              ),
                            ],
                          )
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

// ignore: must_be_immutable, use_key_in_widget_constructors
class BuenoDeHoras extends StatelessWidget {
   final ValueNotifier<SingingCharacter?> radioButtonSelectionNotifier = ValueNotifier<SingingCharacter?>(null);
  
  final customerSearchController = TextEditingController();
  final startTimeController = TextEditingController();
  late final endTimeController = TextEditingController();
  
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
      // Container for contract details
      Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Contrato de cliente",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 12),

            // Card displaying contract type and remaining hours
            Container(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.contrast, color: Colors.blue, size: 20),
                            SizedBox(width: 10),
                            Text(
                              "Tipo de contrato:",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                            ),
                            SizedBox(width: 10),
                            Text(
                              customersController.customer != null
                                  ? customersController.customer!.contractType.name
                                  : "No Contract",
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.orange, size: 20),
                            SizedBox(width: 10),
                            Text(
                              "Horas restantes:",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                            ),
                            SizedBox(width: 10),
                            Text(
                              customersController.customer != null
                                  ? customersController.customer!.remainingContractTimeStr()
                                  : "N/A",
                              style: customersController.customer != null &&
                                      customersController.customer!.remainingContractTime.hour == 0 &&
                                      customersController.customer!.remainingContractTime.minute == 0
                                  ? TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)
                                  : TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Assistance Type section
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tipo de asistencia",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ValueListenableBuilder<SingingCharacter?>(
                  valueListenable: radioButtonSelectionNotifier,
                  builder: (context, selectedValue, _) {
                    return Column(
                      children: [
                        RadioListTile<SingingCharacter>(
                          title: Row(
                            children: [
                              Icon(Icons.home, color: Colors.blue, size: 20),
                              SizedBox(width: 10),
                              Text("En casa del cliente", style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          value: SingingCharacter.casa,
                          groupValue: selectedValue,
                          onChanged: (SingingCharacter? value) {
                            radioButtonSelectionNotifier.value = value;
                          },
                        ),
                        RadioListTile<SingingCharacter>(
                          title: Row(
                            children: [
                              Icon(Icons.store, color: Colors.orange, size: 20),
                              SizedBox(width: 10),
                              Text("En la tienda", style: TextStyle(fontSize: 15)),
                            ],
                          ),
                          value: SingingCharacter.tienda,
                          groupValue: selectedValue,
                          onChanged: (SingingCharacter? value) {
                            radioButtonSelectionNotifier.value = value;
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // Work Hours section
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Horas de trabajo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 16),

            // Row with buttons and text for work hours
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Start time button and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          customersController.selectTime(context, true); // Start time button
                        },
                        child: Text("Hora de inicio", style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text("Inicio: ${customersController.startTime}", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                // End time button and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          customersController.selectTime(context, false); // End time button
                        },
                        child: Text("Hora de fin", style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text("Fin: ${customersController.endTime}", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                // Work hours summary
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Horas reales: ${customersController.workHoursString()}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Horas contadas: ${customersController.workHoursStringContadas()}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Save and View buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Save button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () async {
                      print("wñkjdfnl");
                      if (customersController.customer != null) {
                        bool success = await customersController.removeHours(customerSearchController.text);
                        if (success) {
                          radioButtonSelection = null;
                          customersController.setStartName(TimeOfDay(hour: 0, minute: 0));
                          customersController.setEndTime(TimeOfDay(hour: 0, minute: 0));
                          customersController.alert(context, "Guardado", "Tiempo actualizado");
                        }
                      } else {
                        customersController.alert(context, "Error", "Inserte algo...");
                      }
                    },
                    child: Text("Guardar", style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                // View Data button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      // Optional action
                    },
                    child: Text("Ver Datos", style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // Signature section
      Container(
        color: const Color.fromARGB(255, 123, 168, 204),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Firma SAT", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () {
                    controllerSAT.clear();
                  },
                  child: Text("Clean"),
                ),
              ],
            ),
            signatureCanvasSAT,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Firma Cliente", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () {
                    controllerCustomers.clear();
                  },
                  child: Text("Clean"),
                ),
              ],
            ),
            signatureCanvasCustomers,
          ],
        ),
      ),
    ],
  ),
),

      /*body: SingleChildScrollView(
        child: Column(
          children: [
            // The initial container with contract details
            Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Contrato de cliente",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // Card displaying contract type and remaining hours
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.contrast, color: Colors.blue, size: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    "Tipo de contrato:",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    customersController.customer != null
                                        ? customersController.customer!.contractType.name
                                        : "No Contract",
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, color: Colors.orange, size: 20),
                                  SizedBox(width: 10),
                                  Text(
                                    "Horas restantes:",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    customersController.customer != null
                                        ? customersController.customer!.remainingContractTimeStr()
                                        : "N/A",
                                    style: customersController.customer != null &&
                                            customersController.customer!.remainingContractTime.hour == 0 &&
                                            customersController.customer!.remainingContractTime.minute == 0
                                        ? TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )
                                        : TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Content for "Tipo de asistencia" (Assistance Type)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tipo de asistencia", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: ValueListenableBuilder<SingingCharacter?>(
                              valueListenable: radioButtonSelectionNotifier,
                              builder: (context, selectedValue, _) {
                                return Column(
                                  children: [
                                    RadioListTile<SingingCharacter>(
                                      title: Row(
                                        children: [
                                          Icon(Icons.home, color: Colors.blue, size: 20),
                                          SizedBox(width: 10),
                                          Text("En casa del cliente", style: TextStyle(fontSize: 15)),
                                        ],
                                      ),
                                      value: SingingCharacter.casa,
                                      groupValue: selectedValue,
                                      onChanged: (SingingCharacter? value) {
                                        radioButtonSelectionNotifier.value = value;
                                      },
                                    ),
                                    RadioListTile<SingingCharacter>(
                                      title: Row(
                                        children: [
                                          Icon(Icons.store, color: Colors.orange, size: 20),
                                          SizedBox(width: 10),
                                          Text("En la tienda", style: TextStyle(fontSize: 15)),
                                        ],
                                      ),
                                      value: SingingCharacter.tienda,
                                      groupValue: selectedValue,
                                      onChanged: (SingingCharacter? value) {
                                        radioButtonSelectionNotifier.value = value;
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title for the section
                  Text(
                    "Horas de trabajo",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16), // Adjusted space between title and content

                  // First Row with buttons and text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust spacing
                    children: [
                      // Column for the start time button and text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                customersController.selectTime(context, true); // Start time button
                              },
                              child: Text(
                                "Hora de inicio",
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent, // Button color
                                padding: EdgeInsets.symmetric(vertical: 10), // Padding inside the button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // Rounded corners
                                ),
                              ),
                            ),
                            SizedBox(height: 8), // Space between button and text
                            Text(
                              "Inicio: ${customersController.startTime}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      // Column for the end time button and text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                customersController.selectTime(context, false); // End time button
                              },
                              child: Text(
                                "Hora de fin",
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent, // Button color
                                padding: EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            SizedBox(height: 8), // Space between button and text
                            Text(
                              "Fin: ${customersController.endTime}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      // Column for work hours summary
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Horas reales: ${customersController.workHoursString()}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis, // Prevent overflow for long text
                            ),
                            SizedBox(height: 8), // Space between text widgets
                            Text(
                              "Horas contadas: ${customersController.workHoursStringContadas()}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Space between rows

                  // Second Row with save and view buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Save button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            print("PASSATO DENTRO ONPRESSED");
                            if (customersController.customer != null) {
                              print("PASSATO DENTRO METODI");
                              if (await customersController.removeHours(customerSearchController.text)) {
                                radioButtonSelection = null;
                                customersController.setStartName(TimeOfDay(hour: 0, minute: 0));
                                customersController.setEndTime(TimeOfDay(hour: 0, minute: 0));
                                customersController.alert(context, "Guardado", "Tiempo actualizado");
                              }
                            } else {
                              customersController.alert(context, "Error", "Inserte algo...");
                            }
                          },
                          child: Text("Guardar"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Button color
                            padding: EdgeInsets.symmetric(vertical: 14), // Padding for button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                            ),
                          ),
                        ),
                      ),
                      // View Data button (Optional)
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text("Ver Datos"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // Button color
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Signature part of the screen
            Container(
              color: const Color.fromARGB(255, 123, 168, 204),
              padding: EdgeInsets.all(20), // Added padding for better spacing
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Firma SAT", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      Text("Firma Cliente", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
            ),
          ],
        ),
      ),*/

      /*body: SingleChildScrollView(
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
                      /*Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              controller: customerSearchController,
                              decoration: InputDecoration(
                                  hintText: 'Buscar al cliente por DNI',
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
                                  if(await customersController.findCustomerFromDNIdb(customerSearchController.text)){
                                    tmp=true;
                                  }else{
                                    tmp=false;
                                  }
                                  
                                  /*if(customerSearchController.text.contains(RegExp(r'\d'))){
                                    tmp = await customersController.pullCustomersFromPhoneNumber(customerSearchController.text);
                                  }else if(customerSearchController.text.contains(RegExp(r'[a-zA-Z]'))){
                                    tmp = await customersController.pullCustomersFromName(customerSearchController.text);
                                  }else{
                                    customersController.pullCustomers();
                                    tmp=true;
                                  }*/
                                  if(!tmp){
                                    customersController.alert(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      "Error",
                                      "The customer doesn't exist. Check the data you inserted. "
                                    );
                                    customerSearchController.text = "";
                                  }
                                },child: Icon(Icons.search)
                              ),
                          )
                        ],
                      ),*/
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(Icons.contrast, color: Colors.blue, size: 20),
                                      SizedBox(width: 10),
                                      Text(
                                        "Tipo de contrato:",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        customersController.customer != null
                                            ? customersController.customer!.contractType.name
                                            : "No Contract",
                                        style: TextStyle(fontSize: 16, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(Icons.access_time, color: Colors.orange, size: 20),
                                      SizedBox(width: 10),
                                      Text(
                                        "Horas restantes:",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        customersController.customer != null
                                            ? customersController.customer!.remainingContractTimeStr()
                                            : "N/A",
                                        style: customersController.customer != null &&
                                                customersController.customer!.remainingContractTime.hour == 0 &&
                                                customersController.customer!.remainingContractTime.minute == 0
                                            ? TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              )
                                            : TextStyle(fontSize: 16, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title for the section
                              Text(
                                "Tipo de asistencia",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              SizedBox(height: 10), // Space between title and radio buttons

                              // Card to wrap the radio buttons for better appearance
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: ValueListenableBuilder<SingingCharacter?>(
                                    valueListenable: radioButtonSelectionNotifier,
                                    builder: (context, selectedValue, _) {
                                      return Column(
                                        children: [
                                          // Radio button for "En casa del cliente"
                                          RadioListTile<SingingCharacter>(
                                            title: Row(
                                              children: [
                                                Icon(Icons.home, color: Colors.blue, size: 20), // Icon for "En casa"
                                                SizedBox(width: 10),
                                                Text(
                                                  "En casa del cliente",
                                                  style: TextStyle(fontSize: 15),
                                                ),
                                              ],
                                            ),
                                            value: SingingCharacter.casa,
                                            groupValue: selectedValue,
                                            onChanged: (SingingCharacter? value) {
                                              // Update the value when a radio button is selected
                                              radioButtonSelectionNotifier.value = value;
                                            },
                                          ),

                                          // Radio button for "En la tienda"
                                          RadioListTile<SingingCharacter>(
                                            title: Row(
                                              children: [
                                                Icon(Icons.store, color: Colors.orange, size: 20), // Icon for "En la tienda"
                                                SizedBox(width: 10),
                                                Text(
                                                  "En la tienda",
                                                  style: TextStyle(fontSize: 15),
                                                ),
                                              ],
                                            ),
                                            value: SingingCharacter.tienda,
                                            groupValue: selectedValue,
                                            onChanged: (SingingCharacter? value) {
                                              // Update the value when a radio button is selected
                                              radioButtonSelectionNotifier.value = value;
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 20), // Space between first and second rows

                              // Title for the second section
                              Text(
                                "Horas de trabajo",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(height: 10), // Space between title and the rest of the content

                              // First Row with buttons and text
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust spacing
                                children: [
                                  // Column for the start time button and text
                                  Expanded( // Changed Flexible to Expanded to allow for better space control
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            customersController.selectTime(context, true); // Start time button
                                          },
                                          child: Text("Hora de inicio"),
                                        ),
                                        SizedBox(height: 8), // Space between button and text
                                        Text("Inicio: ${customersController.startTime}"),
                                      ],
                                    ),
                                  ),
                                  // Column for the end time button and text
                                  Expanded( // Changed Flexible to Expanded
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            customersController.selectTime(context, false); // End time button
                                          },
                                          child: Text("Hora de fin"),
                                        ),
                                        SizedBox(height: 8), // Space between button and text
                                        Text("Fin: ${customersController.endTime}"),
                                      ],
                                    ),
                                  ),
                                  // Column for work hours summary
                                  Expanded( // Changed Flexible to Expanded
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Horas de trabajo reales: ${customersController.workHoursString()}",
                                          overflow: TextOverflow.ellipsis, // Prevent overflow for long text
                                        ),
                                        SizedBox(height: 8), // Space between text widgets
                                        Text(
                                          "Horas de trabajo contadas: ${customersController.workHoursStringContadas()}",
                                          overflow: TextOverflow.ellipsis, // Prevent overflow for long text
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20), // Space between first and second rows

                              // Second Row with save and view buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust spacing
                                children: [
                                  // Save button
                                  Expanded( // Changed Flexible to Expanded
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (customersController.customer != null) {
                                          if (await customersController.removeHours(customerSearchController.text)) {
                                            radioButtonSelection = null;
                                            customersController.setStartName(TimeOfDay(hour: 0, minute: 0));
                                            customersController.setEndTime(TimeOfDay(hour: 0, minute: 0));
                                            customersController.alert(context, "Saved", "Time updated");
                                          }
                                        } else {
                                          customersController.alert(context, "Error", "Insert something...");
                                        }
                                      },
                                      child: Text("Guardar"),
                                    ),
                                  ),
                                  // Optionally, you can enable this button for viewing data
                                  Expanded( // Changed Flexible to Expanded
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text("Ver Datos"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),


                      /*Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title for the section
                            Text(
                              "Tipo de asistencia",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            SizedBox(height: 10), // Space between title and radio buttons

                            // Card to wrap the radio buttons for better appearance
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: ValueListenableBuilder<SingingCharacter?>(
                                  valueListenable: radioButtonSelectionNotifier,
                                  builder: (context, selectedValue, _) {
                                    return Column(
                                      children: [
                                        // Radio button for "En casa del cliente"
                                        RadioListTile<SingingCharacter>(
                                          title: Row(
                                            children: [
                                              Icon(Icons.home, color: Colors.blue, size: 20), // Icon for "En casa"
                                              SizedBox(width: 10),
                                              Text(
                                                "En casa del cliente",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          value: SingingCharacter.casa,
                                          groupValue: selectedValue,
                                          onChanged: (SingingCharacter? value) {
                                            // Update the value when a radio button is selected
                                            radioButtonSelectionNotifier.value = value;
                                          },
                                        ),

                                        // Radio button for "En la tienda"
                                        RadioListTile<SingingCharacter>(
                                          title: Row(
                                            children: [
                                              Icon(Icons.store, color: Colors.orange, size: 20), // Icon for "En la tienda"
                                              SizedBox(width: 10),
                                              Text(
                                                "En la tienda",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          value: SingingCharacter.tienda,
                                          groupValue: selectedValue,
                                          onChanged: (SingingCharacter? value) {
                                            // Update the value when a radio button is selected
                                            radioButtonSelectionNotifier.value = value;
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title for the section
                            Text(
                              "Horas de trabajo",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 10), // Space between title and the rest of the content

                            // First Row with buttons and text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust spacing
                              children: [
                                // Column for the start time button and text
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          customersController.selectTime(context, true); // Start time button
                                        },
                                        child: Text("Hora de inicio"),
                                      ),
                                      SizedBox(height: 8), // Space between button and text
                                      Text("Inicio: ${customersController.startTime}"),
                                    ],
                                  ),
                                ),
                                // Column for the end time button and text
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          customersController.selectTime(context, false); // End time button
                                        },
                                        child: Text("Hora de fin"),
                                      ),
                                      SizedBox(height: 8), // Space between button and text
                                      Text("Fin: ${customersController.endTime}"),
                                    ],
                                  ),
                                ),
                                // Column for work hours summary
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Horas de trabajo reales: ${customersController.workHoursString()}",
                                        overflow: TextOverflow.ellipsis, // Prevent overflow for long text
                                      ),
                                      SizedBox(height: 8), // Space between text widgets
                                      Text(
                                        "Horas de trabajo contadas: ${customersController.workHoursStringContadas()}",
                                        overflow: TextOverflow.ellipsis, // Prevent overflow for long text
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20), // Space between first and second rows

                            // Second Row with save and view buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust spacing
                              children: [
                                // Save button
                                Flexible(
                                  flex: 2,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (customersController.customer != null) {
                                        if (await customersController.removeHours(customerSearchController.text)) {
                                          radioButtonSelection = null;
                                          customersController.setStartName(TimeOfDay(hour: 0, minute: 0));
                                          customersController.setEndTime(TimeOfDay(hour: 0, minute: 0));
                                          customersController.alert(context, "Saved", "Time updated");
                                        }
                                      } else {
                                        customersController.alert(context, "Error", "Insert something...");
                                      }
                                    },
                                    child: Text("Guardar"),
                                  ),
                                ),
                                // Optionally, you can enable this button for viewing data
                                Flexible(
                                  flex: 2,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text("Ver Datos"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )*/

                      /*Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // First Row with buttons and text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust spacing
                              children: [
                                // Using Flexible instead of Expanded for better control over size distribution
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          customersController.selectTime(context, true);
                                        },
                                        child: Text("Hora de inicio"),
                                      ),
                                      SizedBox(height: 8), // Space between button and text
                                      Text("Inicio: ${customersController.startTime}"),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          customersController.selectTime(context, false);
                                        },
                                        child: Text("Hora de fin"),
                                      ),
                                      SizedBox(height: 8), // Space between button and text
                                      Text("Fin: ${customersController.endTime}"),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Horas de trabajo reales: ${customersController.workHoursString()}",
                                        overflow: TextOverflow.ellipsis, // Prevent overflow for long text
                                      ),
                                      SizedBox(height: 8), // Space between text widgets
                                      Text(
                                        "Horas de trabajo contadas: ${customersController.workHoursStringContadas()}",
                                        overflow: TextOverflow.ellipsis, // Prevent overflow for long text
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20), // Space between first and second rows

                            // Second Row with save button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjust spacing
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (customersController.customer != null) {
                                        if (await customersController.removeHours(customerSearchController.text)) {
                                          radioButtonSelection = null;
                                          customersController.setStartName(TimeOfDay(hour: 0, minute: 0));
                                          customersController.setEndTime(TimeOfDay(hour: 0, minute: 0));
                                          customersController.alert(context, "Saved", "Time updated");
                                        }
                                      } else {
                                        customersController.alert(context, "Error", "Insert something...");
                                      }
                                    },
                                    child: Text("Save"),
                                  ),
                                ),
                                // Optionally, you can enable this button for viewing data
                                Flexible(
                                  flex: 2,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text("View Data"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),*/
                      /*Container(
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
                      )*/
                    ],
                  ),
                )
            )
          ]
        )
      )*/
    );
  }
}
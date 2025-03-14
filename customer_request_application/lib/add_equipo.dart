import 'package:customer_request_application/resguardo_de_deposito.dart';
import 'package:flutter/material.dart';
import 'package:customer_request_application/interfaces.dart';
import 'package:provider/provider.dart';
import 'package:customer_request_application/classes.dart';
import 'package:signature/signature.dart';

///Global variable and methods
late ApplicationController customersController;

// ignore: non_constant_identifier_names
final descriptionController = TextEditingController();


///-------------------------------- class with the interface to manage the hours
enum SingingCharacter { si, no }

// ignore: must_be_immutable, camel_case_types, use_key_in_widget_constructors
class AddEquipo extends StatelessWidget {  
  ValueNotifier<SingingCharacter?> radioButtonSelectionNotifier = ValueNotifier<SingingCharacter?>(null);
  
  final SignatureController controllerSAT = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );

  final SignatureController controllerCustomers = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );

  @override
  Widget build(BuildContext context) {
    customersController = context.watch<ApplicationController>();

    if (!customersController.connectionStatus) {
      customersController.classContext = context;
      customersController.connectionDb();
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              tileMode: TileMode.clamp,
              colors: <Color>[
                Color.fromARGB(0, 255, 255, 255),
                Color.fromARGB(63, 123, 168, 204),
                Color.fromARGB(255, 123, 168, 204),
                Color.fromARGB(255, 123, 168, 204),
              ],
            ),
          ),
        ),
        title: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  customersController.customer = null;
                  return Menu();
                },
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              'Divermatica',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
        leading: Image.asset("resources/image/DivermaticaLogo.jpg"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,size: 20),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) {
                    return resguardoDeDeposito();
                  },
                ),
              );
            },
          ),
        ]
      ),

      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView( // Aggiungi SingleChildScrollView per evitare overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /*---------TODO-------------TextField







              */
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Garantia",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1), // Bordo nero sottile
                          borderRadius: BorderRadius.circular(12), // Stessa curvatura del Card
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ValueListenableBuilder<SingingCharacter?>(
                            valueListenable: radioButtonSelectionNotifier,
                            builder: (context, selectedValue, _) {
                              return Column(
                                children: [
                                  RadioListTile<SingingCharacter>(
                                    title: Row(
                                      children: [
                                        Icon(Icons.check, color: const Color.fromARGB(206, 0, 105, 4), size: 20),
                                        SizedBox(width: 10),
                                        Text("Si", style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                    value: SingingCharacter.si,
                                    groupValue: selectedValue,
                                    onChanged: (SingingCharacter? value) {
                                      radioButtonSelectionNotifier.value = value;
                                    },
                                  ),
                                  RadioListTile<SingingCharacter>(
                                    title: Row(
                                      children: [
                                        Icon(Icons.close, color: const Color.fromARGB(255, 175, 12, 0), size: 20),
                                        SizedBox(width: 10),
                                        Text("No", style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                    value: SingingCharacter.no,
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
                    ),
                  ],
                ),
              ),


              SizedBox(height: 16),

              // Description input field
              Text(
                "Trabajo a realizar segun cliente",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(172, 0, 0, 0), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: null,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: "Enter Description...",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: const Color.fromARGB(255, 29, 68, 134), width: 2.0),
                      ),
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Signature section
              Text(
                "Conformidad",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(172, 0, 0, 0), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SAT Signature
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Firma SAT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                              ElevatedButton(
                                onPressed: () {
                                  controllerSAT.clear();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 4,
                                ),
                                child: Text("Limpia", style: TextStyle(fontSize: 14, color: Colors.black)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Signature(
                            controller: controllerSAT,
                            width: double.infinity, // Utilizza la larghezza massima disponibile
                            height: 180,
                            backgroundColor: Colors.white,
                          ),
                        ),

                        // Customer Signature
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Firma Cliente", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                              ElevatedButton(
                                onPressed: () {
                                  controllerCustomers.clear();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 4,
                                ),
                                child: Text("Limpia", style: TextStyle(fontSize: 14, color: Colors.black)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Signature(
                            controller: controllerCustomers,
                            width: double.infinity, // Utilizza la larghezza massima disponibile
                            height: 180,
                            backgroundColor: Colors.white,
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
      ),
    );
  }
}
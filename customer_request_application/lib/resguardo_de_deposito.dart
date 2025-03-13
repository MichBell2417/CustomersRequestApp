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

// ignore: camel_case_types, use_key_in_widget_constructors, must_be_immutable
class resguardoDeDeposito extends StatelessWidget{
  ValueNotifier<SingingCharacter?> radioButtonSelectionNotifier = ValueNotifier<SingingCharacter?>(null);

  final SignatureController controllerSAT = SignatureController(
    penStrokeWidth: 1, // Slightly thicker stroke for clearer signatures
    penColor: Colors.black, // Default pen color is black
    exportBackgroundColor: Colors.transparent, // Transparent background for easier export
  );
  //The canvas for the customer signature
  final SignatureController controllerCustomers = SignatureController(
    penStrokeWidth:  1,  // Slightly thicker stroke for clearer signatures
    penColor: Colors.black, // Default pen color is black
    exportBackgroundColor: Colors.transparent, // Transparent background for easier export
  );

  Widget _buildNoDevicesContent(){
    return Column(
      children: [
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(5), // Padding around the button to show the dashed border
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.grey, // Border color
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              // Your onPressed code here
            },
            icon: Icon(
              Icons.add,
              color: Colors.black, // Icon color
              size: 28, // Adjust icon size
            ),
            label: Text(
              'Add',
              style: TextStyle(
                fontSize: 18, // Larger font size
                fontWeight: FontWeight.w600, // Bold text for better readability
                color: Colors.black, // Text color
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50), // Make the button take the full width of the parent
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              backgroundColor: Colors.transparent, // Button background color
              elevation: 0, // Subtle shadow to lift the button
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSuccessContent(List<Equipo?>? equipo) {
    return Column(
      children: [
        SizedBox(height: 16),
        Text(
          "Equipo",
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
              border: Border.all(color: const Color.fromARGB(172, 0, 0, 0), width: 1), // black border
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Aligning text to the start
                children: [
                  SizedBox(height: 16),
                  Text(
                    "Equipo",
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
                        border: Border.all(color: const Color.fromARGB(172, 0, 0, 0), width: 1), // black border
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16), // Padding around the entire content
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Aligning text to the start
                          children: [
                            // First row - "Nombre contrato" and "Horas restantes"
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Text(
                                        "Tipo:",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 33, 82, 243)),
                                        softWrap: true, // Allow text to wrap
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          equipo!.toList().first!.tipo,
                                          style: TextStyle(fontSize: 16, color: Colors.black),
                                          overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                          softWrap: true, // Allow text to wrap
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Text(
                                        "Marca:",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                        softWrap: true, // Allow text to wrap
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          equipo.toList().first!.marca, // This can be dynamic and longer if needed
                                          style: TextStyle(fontSize: 16, color: Colors.black),
                                          overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                          softWrap: true, // Allow text to wrap
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Spacer between two rows
                            SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Text(
                                        "Modelo:",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 33, 82, 243)),
                                        softWrap: true, // Allow text to wrap
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          equipo.toList().first!.modello,
                                          style: TextStyle(fontSize: 16, color: Colors.black),
                                          overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                          softWrap: true, // Allow text to wrap
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Text(
                                        "Numero de Serie:",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                        softWrap: true, // Allow text to wrap
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          equipo.toList().first!.numeroDiSerie, // This can be dynamic and longer if needed
                                          style: TextStyle(fontSize: 16, color: Colors.black),
                                          overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                          softWrap: true, // Allow text to wrap
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Text(
                                        "Accessorios:",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 33, 82, 243)),
                                        softWrap: true, // Allow text to wrap
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          equipo.toList().first!.descripcionAccesorios,
                                          style: TextStyle(fontSize: 16, color: Colors.black),
                                          overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                          softWrap: true, // Allow text to wrap
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  /*// Title Text "Garantia"
                  Text(
                    "Garantia",
                    style: TextStyle(
                      fontSize: 18, // Font size
                      fontWeight: FontWeight.bold, // Bold text
                      color: Colors.black, // Teal color to match previous text styling
                    ),
                  ),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(172, 0, 0, 0), width: 1), // black border
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ValueListenableBuilder<SingingCharacter?>(
                          valueListenable: radioButtonSelectionNotifier,
                          builder: (context, selectedValue, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround, // Align items evenly
                              children: [
                                // Custom Radio for SI
                                Row(
                                  children: [
                                    Radio<SingingCharacter>(
                                      value: SingingCharacter.si,
                                      groupValue: selectedValue,
                                      onChanged: (SingingCharacter? value) {
                                        radioButtonSelectionNotifier.value = value;
                                      },
                                    ),
                                    Text("SI", style: TextStyle(fontSize: 16,color: Colors.black)),
                                  ],
                                ),
                                // Custom Radio for NO
                                Row(
                                  children: [
                                    Radio<SingingCharacter>(
                                      value: SingingCharacter.no,
                                      groupValue: selectedValue,
                                      onChanged: (SingingCharacter? value) {
                                        radioButtonSelectionNotifier.value = value;
                                      },
                                    ),
                                    Text("NO", style: TextStyle(fontSize: 16,color: Colors.black)),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Title Text "Equipo"
                  Text(
                    "Trabajo a realizar segun cliente",
                    style: TextStyle(
                      fontSize: 18, // Font size
                      fontWeight: FontWeight.bold, // Bold text
                      color: Colors.black, // Teal color to match previous text styling
                    ),
                  ),
                  
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(172, 0, 0, 0), width: 1), // black border
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: null, // Allows the text to grow and go to the next line
                        minLines: 1, // Minimum lines (initially 1 line)
                        decoration: InputDecoration(
                          hintText: "Enter Description...",
                          hintStyle: TextStyle(color: Colors.grey[600]), // Hint text style
                          contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 16), // Padding inside the text field
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: const Color.fromARGB(255, 29, 68, 134), width: 2.0), // Focused border
                          ),
                          enabledBorder: InputBorder.none, // Remove enabled border
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
    
  @override
  Widget build(BuildContext context){
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
        title: TextButton(
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) {
                  //customersController.setCustomer(Customer(_id, _name, _eMail, _phoneNumber, _street, _remainingContractTime, _contractType, _dni, _cp));
                  return Menu();
                },
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(right: 10), // Adjust this value to move the text to the left
            child: Text(
              'Divermatica',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 22, // Optional: Adjust font size if needed
              ),
            ),
          ),
        ),
        leading: Image.asset("resources/image/DivermaticaLogo.jpg", ),
        
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.people,size: 20),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) {
                    //customersController.setCustomer(Customer(_id, _name, _eMail, _phoneNumber, _street, _remainingContractTime, _contractType, _dni, _cp));
                    return customerView();
                  },
                ),
              );
            },
          ),
        ]
      ),
      
      body: SingleChildScrollView(
        padding: EdgeInsets.all(22), // Distance from the walls of the page
        child: Column(
          children: [
            // Title Text "Cliente"
            Text(
              "Cliente",
              style: TextStyle(
                fontSize: 18, // Font size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.black, // Teal color to match previous text styling
              ),
            ),
            // Card displaying contract type and remaining hours
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromARGB(172, 0, 0, 0), width: 1), // black border
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16), // Padding around the entire content
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligning text to the start
                    children: [
                      // First row - "Nombre contrato" and "Horas restantes"
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  "Nombre:",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 33, 82, 243)),
                                  softWrap: true, // Allow text to wrap
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    customersController.customer!.name,
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                    overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                    softWrap: true, // Allow text to wrap
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  "E-Mail:",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                  softWrap: true, // Allow text to wrap
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    customersController.customer!.eMail, // This can be dynamic and longer if needed
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                    overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                    softWrap: true, // Allow text to wrap
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      // Spacer between two rows
                      SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  "Numero Telefonico:",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 33, 82, 243)),
                                  softWrap: true, // Allow text to wrap
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    customersController.customer!.phoneNumber,
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                    overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                    softWrap: true, // Allow text to wrap
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  "D.N.I:",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                  softWrap: true, // Allow text to wrap
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    customersController.customer!.dni, // This can be dynamic and longer if needed
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                    overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                    softWrap: true, // Allow text to wrap
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  "Direccion:",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 33, 82, 243)),
                                  softWrap: true, // Allow text to wrap
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    customersController.customer!.street,
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                    overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                    softWrap: true, // Allow text to wrap
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  "C.P.:",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                  softWrap: true, // Allow text to wrap
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    customersController.customer!.cp, // This can be dynamic and longer if needed
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                    overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                    softWrap: true, // Allow text to wrap
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      // Spacer between two rows
                      SizedBox(height: 16),

                      // Last row - Similar structure to the first row
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  "Nombre contrato:",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 33, 82, 243)),
                                  softWrap: true, // Allow text to wrap
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    customersController.customer!.contractType.name, // This can be dynamic and longer if needed
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                    overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                    softWrap: true, // Allow text to wrap
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  "Horas restantes:",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                  softWrap: true, // Allow text to wrap
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    customersController.customer!.remainingContractTimeStr(), // This can be dynamic and longer if needed
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                    overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                    softWrap: true, // Allow text to wrap
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )

              ),
            ),
            FutureBuilder<List<Equipo?>?>(
              future: customersController.pullDevicesOfCustomer(customersController.customer!.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show loading indicator while fetching data
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20),
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Searching the equipos of this customer...')
                      ],
                    ),
                  );
                }else if (snapshot.hasError) {
                  // Show error message if there is an issue fetching data
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  // If the future is done, check if we have data
                  if (snapshot.hasData) {
                    final equipo = snapshot.data;
                    // If we have a valid Equipo, show its content
                    if(equipo != null){
                      return _buildSuccessContent(equipo);  // You need to pass the Equipos to this function
                    }else{
                      return _buildNoDevicesContent();
                    }
                  } else {
                    // If no data is found (snapshot.data is null)
                    return _buildNoDevicesContent();
                  }
                } else {
                  // Fallback for unexpected states
                  return Center(child: Text('Unknown state'));
                }
              },
            )


            /*SizedBox(height: 16),

            Text(
              "Conformidad",
              style: TextStyle(
                fontSize: 18, // Font size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.black, // Teal color to match previous text styling
              ),
            ),

            // Signature section
            Card(
              elevation: 6, // Slightly more elevated for a floating effect
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromARGB(172, 0, 0, 0), width: 1), // Black border
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16), // Increased padding around the card content
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Left-align text for a cleaner look
                    children: [
                      // SAT Signature
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16), // Increased bottom padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Firma SAT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                            ElevatedButton(
                              onPressed: () {
                                controllerSAT.clear();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // White background
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Reduced padding
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Slightly sharper rounded corners
                                elevation: 4, // Slight shadow for a floating effect
                              ),
                              child: Text("Limpia", style: TextStyle(fontSize: 14, color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),  // Padding around the canvas for spacing
                        decoration: BoxDecoration(
                          color: Colors.white, // Light grey background to distinguish from white
                          borderRadius: BorderRadius.circular(12), // Rounded corners for the container
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.1), // Lighter shadow for depth
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: Offset(0, 2), // Shadow offset
                            ),
                          ],
                        ),
                        child: Signature(
                          controller: controllerSAT,
                          width: 400, // Reduced width for a more compact signature area
                          height: 180, // Reduced height for a more compact signature area
                          backgroundColor: Colors.white,
                        ),
                      ),

                      // Customer Signature
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16), // Increased padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Firma Cliente", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                            ElevatedButton(
                              onPressed: () {
                                controllerCustomers.clear();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // White background
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Consistent padding
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Slightly sharper rounded corners
                                elevation: 4, // Slight shadow for a floating effect
                              ),
                              child: Text("Limpia", style: TextStyle(fontSize: 14, color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),  // Padding around the canvas for spacing
                        decoration: BoxDecoration(
                          color: Colors.white, // Light grey background to distinguish from white
                          borderRadius: BorderRadius.circular(12), // Rounded corners for the container
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.1), // Lighter shadow for depth
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: Offset(0, 2), // Shadow offset
                            ),
                          ],
                        ),
                        child: Signature(
                          controller: controllerCustomers,
                          width: 400, // Reduced width for a more compact signature area
                          height: 180, // Reduced height for a more compact signature area
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),*/
          ],
        ),
      )
    );
  }
}
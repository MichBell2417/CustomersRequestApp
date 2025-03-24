import 'package:customer_request_application/detail_equipo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:customer_request_application/interfaces.dart';
import 'package:customer_request_application/classes.dart';
import 'package:customer_request_application/add_equipo.dart';

///Global variable and methods
late ApplicationController customersController;

// ignore: non_constant_identifier_names
final descriptionController = TextEditingController();


///-------------------------------- class with the interface to manage the hours
enum SingingCharacter { si, no }


// ignore: must_be_immutable
class ResguardoDeDeposito extends StatelessWidget{
  ResguardoDeDeposito({super.key});

  ValueNotifier<SingingCharacter?> radioButtonSelectionNotifier = ValueNotifier<SingingCharacter?>(null);

  final ValueNotifier<Customer?> selectedCustomerNotifier = ValueNotifier<Customer?>(null);

  Widget _buildNoDevicesContent(BuildContext context){
    return Column(
      children: [
        SizedBox(height: 16),

        Text(
          "No equipos are associated with this customer.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],  // Slightly lighter color for subtle appearance
            fontWeight: FontWeight.w500,  // Medium weight for the font
            letterSpacing: 0.5,  // Adds a little bit of spacing between letters
          ),
          textAlign: TextAlign.center,  // Centers the text
        ),
        
        SizedBox(height: 16),
        
        Text(
          "You want to add one?",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],  // Slightly lighter color for subtle appearance
            fontWeight: FontWeight.w500,  // Medium weight for the font
            letterSpacing: 0.5,  // Adds a little bit of spacing between letters
          ),
          textAlign: TextAlign.center,  // Centers the text
        ),

        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) {
                    //customersController.setCustomer(Customer(_id, _name, _eMail, _phoneNumber, _street, _remainingContractTime, _contractType, _dni, _cp));
                    return AddEquipo();
                  },
                ),
              );
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,
              size: 28,
            ),
            label: Text(
              'Add equipo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSuccessContent(List<Equipo?>? equipos,BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Align everything to the start
      children: [
        SizedBox(height: 16),
        Text(
          "Equipos",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        SizedBox(height: 16),

        // Iterate through the list of equipos and generate a Card for each
        ...equipos!.map(
          (equipo) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16), // Padding between each equipment card
              child: GestureDetector(
                onTap: () {
                  customersController.equipo = equipo;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailEquipo()));
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(172, 0, 0, 0), width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First row - Tipo and Marca
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
                                        equipo?.tipo ?? 'N/A',
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
                                        equipo?.marca ?? 'N/A', // This can be dynamic and longer if needed
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

                          // Second row - Modelo and Numero di Serie
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
                                        equipo?.modelo ?? 'N/A',
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
                                      "Número de Serie: ",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                      softWrap: true, // Allow text to wrap
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        equipo?.numeroSerie ?? 'N/A', // This can be dynamic and longer if needed
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

                          // Last row - Accesorios
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Text(
                                      "Is In Garantia: ",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 33, 82, 243)),
                                      softWrap: true, // Allow text to wrap
                                    ),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        equipo?.garantia == 1 ? "SI" : "NO",
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
              ),
            );
          }
        ),

        SizedBox(height: 16),

        Text(
          "You want to add another one?",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],  // Slightly lighter color for subtle appearance
            fontWeight: FontWeight.w500,  // Medium weight for the font
            letterSpacing: 0.5,  // Adds a little bit of spacing between letters
          ),
          textAlign: TextAlign.center,  // Centers the text
        ),

        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) {
                    return AddEquipo();
                  },
                ),
              );
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,
              size: 28,
            ),
            label: Text(
              'Add equipo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.transparent,
              elevation: 0,
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
                  customersController.customer = null;
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
                    customersController.customer = null;
                    return CustomerView();
                  },
                ),
              );
            },
          ),
        ]
      ),
      
      body:
      customersController.customer !=null ? //checks if there is a customer to show
      SingleChildScrollView(
        padding: EdgeInsets.all(22), // Distance from the walls of the page
        child: Column(
          children: [
            // Title Text "Cliente"
            Text(
              "Cliente",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
                    return _buildSuccessContent(customersController.equipos,context);  // You need to pass the Equipos to this function
                  } else {
                    // If no data is found (snapshot.data is null)
                    return _buildNoDevicesContent(context);
                  }
                } else {
                  // Fallback for unexpected states
                  return Center(child: Text('Unknown state'));
                }
              },
            )
          ],
        ),
      ) : 
      SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text for the dropdown prompt
            Text(
              'Select a customer:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // ListView to select a customer
            ValueListenableBuilder<Customer?>(
              valueListenable: selectedCustomerNotifier,
              builder: (context, selectedCustomer, _) {
                return Column(
                  children: customersController.customers.map((item) {
                    return GestureDetector(
                      onTap: () {
                        // Update the selected customer when tapped
                        selectedCustomerNotifier.value = item;
                        customersController.customer = item;
                      },
                      child: Card(
                        color: selectedCustomer == item
                            // ignore: deprecated_member_use
                            ? Colors.blueAccent.withOpacity(0.2)  // Highlight selected customer
                            : Colors.white,
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.info_outline, size: 20,color: Colors.blueAccent,),
                          title: Text('${item.name} - ${item.dni}'),
                          subtitle: Text('Tap to select'),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            SizedBox(height: 20),

            // Display the selected customer details
            ValueListenableBuilder<Customer?>(
              valueListenable: selectedCustomerNotifier,
              builder: (context, selectedCustomer, _) {
                // If a customer is selected, navigate to the AddEquipo screen
                if (selectedCustomer != null) {
                  // Use WidgetsBinding to ensure the navigation happens after the build is complete
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          // You can pass the selected customer to the AddEquipo screen if needed
                          return ResguardoDeDeposito();
                        },
                      ),
                    );
                  });
                }
                return Container(); // Return an empty container if no customer is selected
              },
            ),
          ],
        ),
      ),
    );
  }
}
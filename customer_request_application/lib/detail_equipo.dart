// ignore_for_file: use_build_context_synchronously

import 'package:customer_request_application/resguardo_de_deposito.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:customer_request_application/interfaces.dart';
import 'package:customer_request_application/classes.dart';

///Global variable and methods
late ApplicationController customersController;

/*class DetailEquipo extends StatelessWidget {
  const DetailEquipo({super.key});

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
                Color.fromARGB(255, 123, 168, 204)
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
        leading: Image.asset("resources/image/DivermaticaLogo.jpg"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ResguardoDeDeposito();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(22), // Distance from the walls of the page
        child: Column(
          children: [
            // Title Text "Equipo"
            Text(
              "Equipo",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            // First Card with details about the Equipo
            Card(
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
                                    customersController.equipo!.tipo ?? 'N/A',
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
                                    customersController.equipo!.marca ?? 'N/A', // This can be dynamic and longer if needed
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
                                    customersController.equipo!.modelo ?? 'N/A',
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
                                    customersController.equipo!.numeroSerie ?? 'N/A', // This can be dynamic and longer if needed
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
                                    customersController.equipo!.garantia == 1 ? "SI" : "NO",
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

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: Container(
                width: double.infinity, // Makes the card take the entire width
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(172, 0, 0, 0), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16), // Adjust the padding to make it visually balanced
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Example Text or Widgets inside the card
                      Text(
                        "Descricion de la falta",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text(
                        customersController.equipo!.descripcion ?? "No description available",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: Container(
                width: double.infinity, // Makes the card take the entire width
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(172, 0, 0, 0), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16), // Adjust the padding to make it visually balanced
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Example Text or Widgets inside the card
                      Text(
                        "Otro accesorio",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text(
                        customersController.equipo!.descripcionAccesorios ?? "No accessorios available",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Row(
              verticalDirection: VerticalDirection.down,
              children: [
                ElevatedButton.icon(
                  onPressed: (){
                    print("diocane");
                  }, 
                  label: Icon(
                    Icons.delete
                  )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}*/

class DetailEquipo extends StatelessWidget {
  const DetailEquipo({super.key});

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
                Color.fromARGB(255, 123, 168, 204)
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
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ResguardoDeDeposito();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(22), 
              child: Column(
                children: [
                  Text(
                    "Equipo",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // First Card with details about the Equipo
                  Card(
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
                                        softWrap: true,
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          customersController.equipo!.tipo ?? 'N/A',
                                          style: TextStyle(fontSize: 16, color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
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
                                        softWrap: true,
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          customersController.equipo!.marca ?? 'N/A',
                                          style: TextStyle(fontSize: 16, color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
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
                                          customersController.equipo!.modelo ?? 'N/A',
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
                                          customersController.equipo!.numeroSerie ?? 'N/A', // This can be dynamic and longer if needed
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
                                          customersController.equipo!.garantia == 1 ? "SI" : "NO",
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

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.white,
                    child: Container(
                      width: double.infinity, // Makes the card take the entire width
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(172, 0, 0, 0), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16), // Adjust the padding to make it visually balanced
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Example Text or Widgets inside the card
                            Text(
                              "Descricion de la falta",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              customersController.equipo!.descripcion ?? "No description available",
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.white,
                    child: Container(
                      width: double.infinity, // Makes the card take the entire width
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(172, 0, 0, 0), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16), // Adjust the padding to make it visually balanced
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Example Text or Widgets inside the card
                            Text(
                              "Otro accesorio",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              customersController.equipo!.descripcionAccesorios ?? "No accessorios available",
                              style: TextStyle(fontSize: 16, color: Colors.black54),
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
          
          // Button at the bottom that spans the full width
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: SizedBox(
              width: double.infinity, // Makes the button take the entire width
              child: ElevatedButton.icon(
                onPressed: () async {
                  if(await customersController.deleteDevice(customersController.equipo!.id)){
                    customersController.alert(context, "Done!", "The device has been deleted correctly.");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ResguardoDeDeposito();
                        },
                      ),
                    );  
                  }else{
                    print("PASSA DOVE NON DEVE");
                    customersController.alert(context, "Error", "There has been a mistake in deleting this device :(");
                  }
                },
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16), // Adjust vertical padding for button size
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




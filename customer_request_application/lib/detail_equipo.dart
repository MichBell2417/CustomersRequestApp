// ignore_for_file: use_build_context_synchronously
import 'package:customer_request_application/resguardo_de_deposito.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:customer_request_application/interfaces.dart';
import 'package:customer_request_application/classes.dart';

///Global variable and methods
late ApplicationController customersController;
final tipoController = TextEditingController();
final marcaController = TextEditingController();
final modeloController = TextEditingController();
final numeroSerieController = TextEditingController();
final descriptionController = TextEditingController();
final descriptionAccessoriosController = TextEditingController();

class DetailEquipo extends StatelessWidget {
  const DetailEquipo({super.key});

  @override
  Widget build(BuildContext context) {
        final customersController = context.watch<ApplicationController>();

    // Use addPostFrameCallback to run async code after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!customersController.connectionStatus) {
        customersController.classContext = context;
        customersController.connectionDb();
      }
    });

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
                  GestureDetector(
                    onTap: () {
                      // Set the text controllers based on the customer data
                      tipoController.text = customersController.equipo!.tipo;
                      marcaController.text = customersController.equipo!.marca;
                      modeloController.text = customersController.equipo!.modelo;
                      numeroSerieController.text = customersController.equipo!.numeroSerie;

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Update data",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,  // Change the title color
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Row with Label and TextField side by side
                                //TIPO
                                Row(
                                  children: [
                                    // Label for the 'Tipo' field
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0), // Add space between label and TextField
                                      child: Text(
                                        'Tipo:', // Label text
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    // Text field for the 'Tipo'
                                    Expanded(
                                      child: TextFormField(
                                        controller: tipoController,
                                        maxLines: null,
                                        minLines: 1,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                                          ),
                                          hintText: 'Enter Tipo...',
                                          hintStyle: TextStyle(color: Colors.grey),  // Hint text style
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16),
                                
                                //MARCA
                                Row(
                                  children: [
                                    // Label for the 'Marca' field
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0), // Add space between label and TextField
                                      child: Text(
                                        'Marca:', // Label text
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    // Text field for the 'Marca'
                                    Expanded(
                                      child: TextFormField(
                                        controller: marcaController,
                                        maxLines: null,
                                        minLines: 1,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                                          ),
                                          hintText: 'Enter marca...',
                                          hintStyle: TextStyle(color: Colors.grey),  // Hint text style
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16),
                                
                                //MODELO
                                Row(
                                  children: [
                                    // Label for the 'Modelo' field
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0), // Add space between label and TextField
                                      child: Text(
                                        'Modelo:', // Label text
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    // Text field for the 'Modelo'
                                    Expanded(
                                      child: TextFormField(
                                        controller: modeloController,
                                        maxLines: null,
                                        minLines: 1,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                                          ),
                                          hintText: 'Enter modelo...',
                                          hintStyle: TextStyle(color: Colors.grey),  // Hint text style
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16),
                                
                                //NUMERO DE SERIE
                                Row(
                                  children: [
                                    // Label for the 'NumeroSerie' field
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0), // Add space between label and TextField
                                      child: Text(
                                        'Numero de serie:', // Label text
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    // Text field for the 'NumeroSerie'
                                    Expanded(
                                      child: TextFormField(
                                        controller: numeroSerieController,
                                        maxLines: null,
                                        minLines: 1,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                                          ),
                                          hintText: 'Enter Numero De Serie...',
                                          hintStyle: TextStyle(color: Colors.grey),  // Hint text style
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                //GARANTIA
                                Row(
                                  children: [
                                    // Label for the 'Garantia' field
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0), // Add space between label and TextField
                                      child: Text(
                                        'Garantia:', // Label text
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    // Text field for the 'Garantia'
                                    Expanded(
                                      child: Text("data"),
                                    ),
                                  ],
                                ),




                              ],
                            ),


                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,  // Button background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                onPressed: () async {
                                  bool success = await customersController.upgradeDevice(
                                    tipoController.text, 
                                    marcaController.text, 
                                    modeloController.text, 
                                    numeroSerieController.text, 
                                    customersController.equipo!.descripcion, 
                                    customersController.equipo!.descripcionAccesorios,
                                  );
                                  if (success) {
                                    // Show confirmation alert
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Update Successful",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,  // Green color for success
                                            ),
                                          ),
                                          content: Text(
                                            "The device details have been successfully updated.",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                "OK",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();  // Close the confirmation dialog
                                                Navigator.pop(context);  // Close the update dialog
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => DetailEquipo()),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.save, color: Colors.white),  // Use icon with white color
                                    SizedBox(width: 8),
                                    Text(
                                      "Save",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,  // White text on the button
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }, // Open dialog when card is tapped
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
                                          softWrap: true,
                                        ),
                                        SizedBox(width: 10),
                                        Flexible(
                                          child: Text(
                                            customersController.equipo!.tipo,
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
                                            customersController.equipo!.marca,
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
                                            customersController.equipo!.modelo,
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
                                            customersController.equipo!.numeroSerie, // This can be dynamic and longer if needed
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
                  ),

                  SizedBox(height: 16),

                  GestureDetector(
                    onTap: () {
                      // Set the text controllers based on the customer data
                      descriptionController.text = customersController.equipo!.descripcion;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Update Descricion",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,  // Change the title color
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: descriptionController,
                                  maxLines: null,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                                    ),
                                    hintText: 'Enter...',
                                    hintStyle: TextStyle(color: Colors.grey),  // Hint text style
                                  ),
                                ),  // Add space between the text field and button
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,  // Button background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                onPressed: () async {
                                  bool success = await customersController.upgradeDevice(
                                    customersController.equipo!.tipo, 
                                    customersController.equipo!.marca, 
                                    customersController.equipo!.modelo, 
                                    customersController.equipo!.numeroSerie, 
                                    descriptionController.text, 
                                    customersController.equipo!.descripcionAccesorios,
                                  );
                                  if (success) {
                                    // Show confirmation alert
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Update Successful",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,  // Green color for success
                                            ),
                                          ),
                                          content: Text(
                                            "The device details have been successfully updated.",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                "OK",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();  // Close the confirmation dialog
                                                Navigator.pop(context);  // Close the update dialog
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => DetailEquipo()),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.save, color: Colors.white),  // Use icon with white color
                                    SizedBox(width: 8),
                                    Text(
                                      "Save",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,  // White text on the button
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }, // Open dialog when card is tapped
                    child: Card(
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
                  ),

                  SizedBox(height: 16),

                  GestureDetector(
                    onTap: () {
                      // Set the text controllers based on the customer data
                      descriptionAccessoriosController.text = customersController.equipo!.descripcionAccesorios;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Update Accesorios",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,  // Change the title color
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: descriptionAccessoriosController,
                                  maxLines: null,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                                    ),
                                    hintText: 'Enter additional accessories',
                                    hintStyle: TextStyle(color: Colors.grey),  // Hint text style
                                  ),
                                ),  // Add space between the text field and button
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,  // Button background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                onPressed: () async {
                                  bool success = await customersController.upgradeDevice(
                                    customersController.equipo!.tipo, 
                                    customersController.equipo!.marca, 
                                    customersController.equipo!.modelo, 
                                    customersController.equipo!.numeroSerie, 
                                    customersController.equipo!.descripcion, 
                                    descriptionAccessoriosController.text,
                                  );
                                  if (success) {
                                    // Show confirmation alert
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Update Successful",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,  // Green color for success
                                            ),
                                          ),
                                          content: Text(
                                            "The device details have been successfully updated.",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                "OK",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();  // Close the confirmation dialog
                                                Navigator.pop(context);  // Close the update dialog
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => DetailEquipo()),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.save, color: Colors.white),  // Use icon with white color
                                    SizedBox(width: 8),
                                    Text(
                                      "Save",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,  // White text on the button
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      child: Container(
                        width: double.infinity,  // Makes the card take the entire width
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromARGB(172, 0, 0, 0), width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),  // Adjust the padding to make it visually balanced
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Other Accesory",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,  // Darker color for better readability
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                customersController.equipo!.descripcionAccesorios ?? "No accessories available",
                                style: TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Add horizontal padding to distance from the sides
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Attempt to delete the device
                      if (await customersController.deleteDevice(customersController.equipo!.id)) {
                        // Show confirmation alert
                        customersController.alert(context, "Done!", "The device has been deleted correctly.");

                        // Wait for the alert to be closed before navigating
                        await Future.delayed(Duration(seconds: 2));  // Optional delay before going back

                        customersController.equipos.clear();

                        // Navigate to ResguardoDeDeposito page after deletion
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ResguardoDeDeposito()),
                        );
                      } else {
                        // Show error alert if the deletion fails
                        customersController.alert(context, "Error", "There has been a mistake in deleting this device :(");
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Color(0xFFB71C1C), // Dark red color for the icon
                      size: 28, // Increased icon size for better visibility
                    ),
                    label: Text(
                      'Delete Equipo',
                      style: TextStyle(
                        color: Color(0xFFB71C1C), // Dark red for the text
                        fontSize: 18, // Larger font size for better readability
                        fontWeight: FontWeight.bold, // Bold text for emphasis
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFFB71C1C), // Dark red color for the icon and text
                      backgroundColor: Colors.white, // White background for the button
                      padding: EdgeInsets.symmetric(vertical: 18), // Increased height for a better touch experience
                      minimumSize: Size(double.infinity, 56), // Full width button with a fixed height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners for a smooth look
                        side: BorderSide(color: Color(0xFFB71C1C), width: 2), // Dark red border around the button
                      ),
                      elevation: 5, // Light shadow for the button
                      shadowColor: Colors.black45, // Shadow color for better visibility
                      splashFactory: InkSplash.splashFactory, // Splash effect when clicked
                    ),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
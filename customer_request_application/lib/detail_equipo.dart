// ignore_for_file: use_build_context_synchronously
import 'package:customer_request_application/resguardo_de_deposito.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:customer_request_application/interfaces.dart';
import 'package:customer_request_application/classes.dart';


///PDF LIBRARY
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:typed_data';
import 'dart:io';


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

  // Draws a circle on the PDF
  void drawCircle(PdfGraphics graphics, double x, double y, double diameter) {
    // Draw an ellipse with equal width and height (creates a circle)
    graphics.drawEllipse(
      Rect.fromLTWH(
        x, // X-coordinate for the top-left corner of the bounding rectangle
        y, // Y-coordinate for the top-left corner of the bounding rectangle
        diameter, // Width of the circle
        diameter, // Height of the circle (same as width for a perfect circle)
      ),
      pen: PdfPen(PdfColor(0, 0, 0)), // Black color outline for the circle
    );
  }



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
        leading: Image.asset("assets/resources/image/DivermaticaLogo.jpg"),
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
                            content: SingleChildScrollView(  // Add SingleChildScrollView here
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // TIPO
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Text(
                                          'Tipo:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
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
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),

                                  // MARCA
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Text(
                                          'Marca:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
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
                                            hintText: 'Enter Marca...',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),

                                  // MODELO
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Text(
                                          'Modelo:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
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
                                            hintText: 'Enter Modelo...',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),

                                  // NUMERO DE SERIE
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Text(
                                          'Numero de serie:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
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
                                            hintText: 'Enter Numero de Serie...',
                                            hintStyle: TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
                                    customersController.equipos.clear();
                                    // Show confirmation alert
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Update",
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
                                                Navigator.push(
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

                              // Last row - Garantia
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
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Add horizontal padding to distance from the sides
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Attempt to delete the device
                      if (await customersController.deleteDevice(customersController.equipo!.id)) {              
                        // Show confirmation alert
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Delete",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,  // Green color for success
                                ),
                              ),
                              content: Text(
                                "The device have been successfully deleted.",
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
                                    Navigator.of(context).pop();  // Close the dialog first

                                    // Now navigate to ResguardoDeDeposito
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ResguardoDeDeposito();
                                        },
                                      )
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }else{
                        // Show error alert if it fails
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
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Add horizontal padding to distance from the sides
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        // Load the existing PDF file
                        final ByteData bytes = await rootBundle.load('assets/resources/Documents/ResguardoDeposito.pdf');
                        final Uint8List pdfData = bytes.buffer.asUint8List();

                        // Open the PDF document
                        final PdfDocument document = PdfDocument(inputBytes: pdfData);

                        // Access the first page (or other pages as needed)
                        final PdfPage page = document.pages[0];
                        final PdfGraphics graphics = page.graphics;

                        // Define a font similar to the original one in the PDF
                        final PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 12); // Change to the desired font

                        // Set the color and style of the text (example: solid black)
                        final PdfBrush brush = PdfSolidBrush(PdfColor(0, 0, 0)); // Black color

                        graphics.drawString(
                          '${customersController.equipo!.id}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(476, 84, 300, 20), // Positioning
                        );

                        //CUSTOMER INFORMATION
                        graphics.drawString(
                          '${customersController.customer!.name}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(203, 132, 300, 20), // Positioning
                        );

                        graphics.drawString(
                          '${customersController.customer!.street}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(207, 146, 300, 20), // Positioning
                        );

                        graphics.drawString(
                          '${customersController.customer!.cp}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(180, 160, 300, 20), // Positioning
                        );


                        Map<String, String>? location = await customersController.customer!.getCityAndProvince(customersController.customer!.cp); // Codice postale di Jerez de la Frontera
                        if (location != null) {
                          print('Città: ${location['city']}, Provincia: ${location['province']}');
                        } else {
                          print('Impossibile trovare la città e la provincia.');
                        }
                        

                        graphics.drawString(
                          '${customersController.customer!.dni}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(185, 188, 300, 20), // Positioning
                        );
                        
                        graphics.drawString(
                          '${customersController.customer!.phoneNumber}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(310, 188, 300, 20), // Positioning
                        );

                        graphics.drawString(
                          '${customersController.customer!.eMail}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(190, 202, 300, 20), // Positioning
                        );
                        
                        //EQUIPO INFORMATION
                        graphics.drawString(
                          '${customersController.equipo!.tipo}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(183, 276, 300, 20), // Positioning
                        );

                        graphics.drawString(
                          '${customersController.equipo!.fechaSolicitud.day}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(397, 276, 300, 20), // Positioning
                        );

                        graphics.drawString(
                          '${customersController.equipo!.fechaSolicitud.month}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(419, 276, 300, 20), // Positioning
                        );

                        graphics.drawString(
                          '${customersController.equipo!.fechaSolicitud.year}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(437, 276, 300, 20), // Positioning
                        );

                        graphics.drawString(
                          '${customersController.equipo!.marca}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(189, 290, 300, 20), // Positioning
                        );

                        customersController.equipo!.garantia == 1 ? 
                          drawCircle(graphics, 371, 292, 11) : drawCircle(graphics, 405, 292, 11);

                        graphics.drawString(
                          '${customersController.equipo!.modelo}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(195, 304, 300, 20), // Positioning
                        );

                        graphics.drawString(
                          '${customersController.equipo!.numeroSerie}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(230, 318, 300, 20), // Positioning
                        );

                        graphics.drawString(
                          '${customersController.equipo!.descripcionAccesorios}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(206, 332, 300, 20), // Positioning
                        );

                        graphics.drawString(
                          '${customersController.equipo!.descripcion}', // Dynamic text
                          font,
                          brush: brush,
                          bounds: const Rect.fromLTWH(120, 400, 300, 20), // Positioning
                        );

                        // Ottieni il percorso della directory dei documenti
                        final directorySignature = await getApplicationDocumentsDirectory();

                        //SignatureSAT
                        final String filePathSignatureSAT = '${directorySignature.path}/signatureSAT_${customersController.equipo!.numeroSerie}.png';

                        // Controlla se il file esiste
                        final File signatureSAT = File(filePathSignatureSAT);

                        // Check if the signature file exists
                        if (await signatureSAT.exists()) {
                          // Read the signature file as bytes
                          final Uint8List signatureData = await signatureSAT.readAsBytes();

                          // Create a PdfBitmap from the signature bytes
                          final PdfBitmap signatureImage = PdfBitmap(signatureData);

                          // Draw the signature on the page
                          graphics.drawImage(
                            signatureImage,
                            const Rect.fromLTWH(117, 710, 50, 40), // Position and size of the signature
                          );
                        } else {
                          // ignore: avoid_print
                          print('${directorySignature.path}/signatureSAT_${customersController.equipo!.numeroSerie}.png');
                          // ignore: avoid_print
                          print("The signature file does not exist");
                        }

                        //Signature Customer
                        final String filePathSignatureCustomer = '${directorySignature.path}/${customersController.customer!.dni}_${customersController.equipo!.numeroSerie}.png';

                        // Controlla se il file esiste
                        final File signatureCustomer = File(filePathSignatureCustomer);

                        // Check if the signature file exists
                        if (await signatureCustomer.exists()) {
                          // Read the signature file as bytes
                          final Uint8List signatureData = await signatureCustomer.readAsBytes();

                          // Create a PdfBitmap from the signature bytes
                          final PdfBitmap signatureImage = PdfBitmap(signatureData);

                          // Draw the signature on the page
                          customersController.equipo!.sinPresupuesto == false ?
                            graphics.drawImage(
                              signatureImage,
                              const Rect.fromLTWH(230, 710, 50, 40), // Con presupuesto
                            ) : 
                            graphics.drawImage(
                              signatureImage,
                              const Rect.fromLTWH(410, 710, 50, 40), // Sin presupuesto
                            );
                        } else {
                          // ignore: avoid_print
                          print('${directorySignature.path}/${directorySignature.path}/${customersController.customer!.dni}_${customersController.equipo!.numeroSerie}.png');
                          // ignore: avoid_print
                          print("The signature file does not exist");
                        }

                        // Save the modified document
                        final directory = await getExternalStorageDirectory();
                        if (directory == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Unable to access the external directory!')),
                          );
                          return;
                        }

                        final String filePath = '${directory.path}/${customersController.customer!.dni}_${customersController.equipo!.numeroSerie}.pdf';
                        final File file = File(filePath);
                        await file.writeAsBytes(document.saveSync());

                        // Close the document to release resources
                        document.dispose();

                        // Show a success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('PDF modified and saved in $filePath')),
                        );
                      } catch (e) {
                        // Error handling
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error while editing the PDF: $e')),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.download,
                      color: Colors.black, // Dark red color for the icon
                      size: 28, // Increased icon size for better visibility
                    ),
                    label: Text(
                      'PDF',
                      style: TextStyle(
                        color: Colors.black, // Dark red for the text
                        fontSize: 18, // Larger font size for better readability
                        fontWeight: FontWeight.bold, // Bold text for emphasis
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, // Dark red color for the icon and text
                      backgroundColor: Colors.white, // White background for the button
                      padding: EdgeInsets.symmetric(vertical: 18), // Increased height for a better touch experience
                      minimumSize: Size(double.infinity, 56), // Full width button with a fixed height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners for a smooth look
                        side: BorderSide(color: Colors.black, width: 2), // Dark red border around the button
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
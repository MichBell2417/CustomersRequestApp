// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

///LINKTO THE OTHER PAGES
import 'package:customer_request_application/resguardo_de_deposito.dart';
import 'package:customer_request_application/interfaces.dart';
import 'package:customer_request_application/classes.dart';

///SIGNATURE LIBRARY 
import 'package:signature/signature.dart';

///PDF LIBRARY
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

///SIGNATURE TO IMAGE LIBRARY
import 'dart:typed_data';
import 'package:image/image.dart' as img; // For image manipulation
import 'dart:ui' as ui;  // Import dart:ui to work with images


///Global variable and methods
late ApplicationController customersController;

// ignore: non_constant_identifier_names
final descriptionController = TextEditingController();

final tipoController = TextEditingController();
final marcaController = TextEditingController();
final modeloController = TextEditingController();
final numeroSerieController = TextEditingController();
final descriptionAccessoriosController = TextEditingController();

///-------------------------------- class with the interface to manage the hours
enum SingingCharacter { si, no }

// ignore: must_be_immutable
class AddEquipo extends StatelessWidget {
  AddEquipo({super.key});
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

  //Exporting the signature as png or jpeg (to put them in a pdf file?)
  Future<void> _exportSignatureAsPNG() async {
    try {
      // Get the signature image as a PNG
      var signature = await controllerSAT.toImage();
      var byteData = await signature?.toByteData(format: ui.ImageByteFormat.png);
      var bytes = byteData?.buffer.asUint8List();

      // Get the device's directory to save the file
      var directory = await getApplicationDocumentsDirectory();
      var filePath = '${directory.path}/signatureSAT_${numeroSerieController.text}.png';

      // Save the image as PNG
      var file = File(filePath);
      await file.writeAsBytes(bytes as List<int>);

      // Get the signature image as a PNG
      signature = await controllerCustomers.toImage();
      byteData = await signature?.toByteData(format: ui.ImageByteFormat.png);
      bytes = byteData?.buffer.asUint8List();

      // Get the device's directory to save the file
      filePath = '${directory.path}/${customersController.customer!.dni}_${numeroSerieController.text}.png';

      // Save the image as PNG
      file = File(filePath);
      await file.writeAsBytes(bytes as List<int>);
    
    } catch (e) {
      print("Error saving signature: $e");
    }
  }

  Future<void> modifyPdfDirectly(BuildContext context) async {
    /*try {
      // Carica il file PDF esistente
      final ByteData bytes = await rootBundle.load('assets/resources/Documents/ResguardoDeposito.pdf');
      final Uint8List pdfData = bytes.buffer.asUint8List();

      // Apri il documento PDF
      final PdfDocument document = PdfDocument(inputBytes: pdfData);

      // Accedi alla prima pagina (o altre pagine se necessario)
      final PdfPage page = document.pages[0];
      final PdfGraphics graphics = page.graphics;

      // Aggiungi testo dinamico accanto al campo "NOMBRE"
      final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);
      graphics.drawString(
        '${customersController.customer!.name}', // Testo dinamico
        font,
        bounds: const Rect.fromLTWH(200, 150, 300, 20), // Posizionamento del testo (coordina qui manualmente)
      );

      // Salva il documento modificato
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossibile accedere alla directory esterna!')),
        );
        return;
      }

      final String filePath = '${directory.path}/${customersController.customer!.dni}_${customersController.equipo!.numeroSerie}.pdf';
      final File file = File(filePath);
      await file.writeAsBytes(document.saveSync());

      // Chiudi il documento per rilasciare risorse
      document.dispose();

      // Mostra un messaggio di successo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF modificato e salvato in $filePath')),
      );
    } catch (e) {
      // Gestione degli errori
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante la modifica del PDF: $e')),
      );
    }*/

    ///parte finale non relativa ai file
    Future.delayed(
      Duration(seconds: 2), () {      
        Navigator.of(context).pop();
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResguardoDeDeposito(),
          ),
        );
      }
    );
  }


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
        leading: Image.asset("assets/resources/image/DivermaticaLogo.jpg"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,size: 20),
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
        ]
      ),

      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView( // Add SingleChildScrollView to avoid overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1), // Bordo nero sottile
                    borderRadius: BorderRadius.circular(12), // Stessa curvatura del Card
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Padding for the entire Card content
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tipo field
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0), // Spacing between fields
                          child: Row(
                            children: [
                              Text(
                                "Tipo: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 8), // Space between label and input
                              Expanded(
                                child: TextFormField(
                                  controller: tipoController,
                                  decoration: InputDecoration(
                                    hintText: "Enter tipo",
                                    hintStyle: TextStyle(color: Colors.grey[600]), // Hint text style
                                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16), // Padding for the text field
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: const Color.fromARGB(255, 29, 68, 134), width: 2.0), // Focused border
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Marca field
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0), // Spacing between fields
                          child: Row(
                            children: [
                              Text(
                                "Marca: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 8), // Space between label and input
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.text, // Adjust if needed
                                  controller: marcaController,
                                  decoration: InputDecoration(
                                    hintText: "Enter marca",
                                    hintStyle: TextStyle(color: Colors.grey[600]), // Hint text style
                                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16), // Padding for the text field
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: const Color.fromARGB(255, 29, 68, 134), width: 2.0), // Focused border
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Modelo
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0), // Spacing between fields
                          child: Row(
                            children: [
                              Text(
                                "Modelo: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 8), // Space between label and input
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.text, // Adjust if needed
                                  controller: modeloController,
                                  decoration: InputDecoration(
                                    hintText: "Enter modelo",
                                    hintStyle: TextStyle(color: Colors.grey[600]), // Hint text style
                                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16), // Padding for the text field
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: const Color.fromARGB(255, 29, 68, 134), width: 2.0), // Focused border
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        //Numero di serie
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0), // Spacing between fields
                          child: Row(
                            children: [
                              Text(
                                "Numero di serie: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 8), // Space between label and input
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.text, // Adjust if needed
                                  controller: numeroSerieController,
                                  decoration: InputDecoration(
                                    hintText: "Enter numero di serie",
                                    hintStyle: TextStyle(color: Colors.grey[600]), // Hint text style
                                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16), // Padding for the text field
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: const Color.fromARGB(255, 29, 68, 134), width: 2.0), // Focused border
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ),

              SizedBox(height: 16),

              // Description input field
              Text(
                "Tienes otro accessorios",
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
                    controller: descriptionAccessoriosController,
                    maxLines: null,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: "Enter Accessorios...",
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
                                      customersController.setGarantia(1);
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
                                      customersController.setGarantia(0);
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
              
              SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(  // This makes the button take all available width
                    child: Container(
                      padding: EdgeInsets.all(8), // Adjust the padding to prevent overflow
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(12),  // Keeps rounded corners
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          var success = controllerCustomers.isNotEmpty && controllerSAT.isNotEmpty;
                          // Check if both signature controllers have content
                          if (success) {
                            customersController.addDevice(
                              tipoController.text,
                              marcaController.text,
                              modeloController.text,
                              numeroSerieController.text,
                              descriptionController.text,
                              descriptionAccessoriosController.text,
                            );
                            
                            // Show confirmation alert
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Equipos Added",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,  // Green color for success
                                    ),
                                  ),
                                  content: Text(
                                    "The device has been successfully added.",
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
                                        _exportSignatureAsPNG();
                                        modifyPdfDirectly(context);

                                        /*Navigator.of(context).pop();  // Close the dialog first

                                        // Now navigate to ResguardoDeDeposito
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ResguardoDeDeposito();
                                            },
                                          )
                                        );*/
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                          } else {
                            // Show an error dialog if signatures are not provided
                            customersController.alert(
                              context,
                              "Error",
                              "You need to sign."
                            );
                          }
                        },

                        icon: Icon(
                          Icons.save,
                          color: Colors.black,
                          size: 28,
                        ),
                        label: Text(
                          'Save equipo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50), // Button will expand to fill the available width
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:customer_request_application/classes.dart';
import 'package:signature/signature.dart';

/*
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img; // For image manipulation
import 'dart:ui' as ui;  // Import dart:ui to work with images
*/

///Global variable and methods
late ApplicationController customersController;

final customerSearchController = TextEditingController();
final streetController = TextEditingController();
final nombreController = TextEditingController();
final numeroDeTelefonoController = TextEditingController();
final emailController = TextEditingController();
final cpController = TextEditingController();
final dniController = TextEditingController();

/// this variable contains the graphic part of the textField
Widget textfieldCustomer = Column(
  children: [
    // Name field
    Padding(
      padding: const EdgeInsets.only(bottom: 10.0), // Spacing between fields
      child: Row(
        children: [
          Text(
            "Nombre: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8), // Space between label and input
          Expanded(
            child: TextFormField(
              controller: nombreController,
              decoration: InputDecoration(
                hintText: "Enter name",
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

    // Phone Number field
    Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text(
            "Número telefónico: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.phone,
              controller: numeroDeTelefonoController,
              decoration: InputDecoration(
                hintText: "Enter phone number",
                hintStyle: TextStyle(color: Colors.grey[600]),
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: const Color.fromARGB(255, 29, 68, 134), width: 2.0),
                ),
              ),
            ),
          ),
        ],
      ),
    ),

    // Email field
    Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text(
            "E-Mail: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter email",
                hintStyle: TextStyle(color: Colors.grey[600]),
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: const Color.fromARGB(255, 29, 68, 134), width: 2.0),
                ),
              ),
            ),
          ),
        ],
      ),
    ),

    // Address field
    Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text(
            "Dirección: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: streetController,
              decoration: InputDecoration(
                hintText: "Enter address",
                hintStyle: TextStyle(color: Colors.grey[600]),
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: const Color.fromARGB(255, 29, 68, 134), width: 2.0),
                ),
              ),
            ),
          ),
        ],
      ),
    ),

    // Postal Code field
    Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text(
            "Código Postal: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: cpController,
              decoration: InputDecoration(
                hintText: "Enter postal code",
                hintStyle: TextStyle(color: Colors.grey[600]),
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: const Color.fromARGB(255, 29, 68, 134), width: 2.0),
                ),
              ),
            ),
          ),
        ],
      ),
    ),

    // DNI field
    Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text(
            "DNI: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: dniController,
              decoration: InputDecoration(
                hintText: "Enter DNI",
                hintStyle: TextStyle(color: Colors.grey[600]),
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: const Color.fromARGB(255, 29, 68, 134), width: 2.0),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
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

///--------------------------------Class with the interface for the menu
// ignore: use_key_in_widget_constructors
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
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    foregroundColor: const Color.fromARGB(255, 29, 68, 134), // Text and icon color
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Padding for better spacing
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    elevation: 5, // Subtle shadow effect
                    // ignore: deprecated_member_use
                    shadowColor: Colors.blue.withOpacity(0.3), // Light blue shadow for effect
                  ), 
                  child: Text("Lista de cliente"),
                ),
              ),
              SizedBox(
                width: 300,
                height: 75,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return resguardoDeDeposito();
                    }));
                  },style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    foregroundColor: const Color.fromARGB(255, 29, 68, 134), // Text and icon color
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Padding for better spacing
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    elevation: 5, // Subtle shadow effect
                    // ignore: deprecated_member_use
                    shadowColor: Colors.blue.withOpacity(0.3), // Light blue shadow for effect
                  ),child: Text("Resguardo de deposito"),
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
// ignore: camel_case_types
class customerView extends StatelessWidget{
  
  final customerSearchController = TextEditingController();

  customerView({super.key});
  
  // Helper method to reduce redundancy in row styling
  Widget _buildCustomerInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

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
            icon: const Icon(Icons.computer),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) {
                    //customersController.setCustomer(Customer(_id, _name, _eMail, _phoneNumber, _street, _remainingContractTime, _contractType, _dni, _cp));
                    return resguardoDeDeposito();
                  },
                ),
              );
            },
          ),
        ]
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (){
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Nuevo cliente",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                label: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Colors.black, // Adjusted color to match the theme
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero, // No padding around the icon button
                                ),
                              ),
                            ],
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Improved text field
                                textfieldCustomer,
                                // Improved contract type section
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Tipo de contrato: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: DropdownMenu<String>(
                                          initialSelection: "-------",
                                          onSelected: (String? value) {
                                            customersController.selectedContract = value!;
                                          },
                                          dropdownMenuEntries: customersController.contractTypes
                                              .map<DropdownMenuEntry<String>>(
                                                (ContractType value) {
                                                  return DropdownMenuEntry<String>(
                                                    value: value.name,
                                                    label: value.name,
                                                  );
                                                },
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Save button with custom styling
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      customersController.addCustomer(
                                        nombreController.text,
                                        emailController.text,
                                        numeroDeTelefonoController.text,
                                        streetController.text,
                                        cpController.text,
                                        dniController.text,
                                      );
                                      customersController.selectedContract = "";
                                      cleanTextField();

                                    },
                                    label: Icon(
                                      Icons.save,
                                      size: 24, // Adjusted icon size for better visibility
                                      color: const Color.fromARGB(255, 29, 68, 134), // White icon color for contrast
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white, // Background color
                                      foregroundColor: const Color.fromARGB(255, 29, 68, 134), // Text and icon color
                                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Padding for better spacing
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12), // Rounded corners
                                      ),
                                      elevation: 5, // Subtle shadow effect
                                      // ignore: deprecated_member_use
                                      shadowColor: Colors.blue.withOpacity(0.3), // Light blue shadow for effect
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16), // Rounded corners for the dialog
                          ),
                          contentPadding: EdgeInsets.all(16), // Padding around the content inside the dialog
                        ),

                      );
                    },
                    label: Icon(
                      Icons.person_add_alt_1,
                      size: 24, // Adjusted icon size for better visibility
                      color: const Color.fromARGB(255, 29, 68, 134), // White icon color for contrast
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Background color
                      foregroundColor: const Color.fromARGB(255, 29, 68, 134), // Text and icon color
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Padding for better spacing
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      elevation: 5, // Subtle shadow effect
                      // ignore: deprecated_member_use
                      shadowColor: Colors.blue.withOpacity(0.3), // Light blue shadow for effect
                    )
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: customerSearchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre o numero telefonico...',
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic, // Italic style for the hint
                          color: Colors.grey[600], // Slightly lighter color for the hint
                        ),
                        // Customizing the text field border
                        filled: true,
                        fillColor: Colors.white, // Background color inside the text field
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                          borderSide: BorderSide(
                            width: 1.5, // Border thickness
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 29, 68, 134), // Stronger color when focused
                            width: 2.0, // Slightly thicker border when focused
                          ),
                        ),
                        // Padding inside the text field to make it more spacious
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    var tmp = false;
                    if (customerSearchController.text.contains(RegExp(r'\d'))) {
                      tmp = await customersController.pullCustomersFromPhoneNumber(customerSearchController.text);
                    } else if (customerSearchController.text.contains(RegExp(r'[a-zA-Z]'))) {
                      tmp = await customersController.pullCustomersFromName(customerSearchController.text);
                    } else {
                      customersController.pullCustomers();
                      tmp = true;
                    }
                    if (!tmp) {
                      customersController.alert(
                        // ignore: use_build_context_synchronously
                        context,
                        "Error",
                        "The customer doesn't exist. Check the data you inserted. "
                      );
                      customerSearchController.text = "";
                      customersController.pullCustomers();
                    }
                  },
                  icon: Icon(
                    Icons.search,
                    size: 24, // Adjusted icon size for better visibility
                    color: const Color.fromARGB(255, 29, 68, 134), // White icon color for contrast
                  ),
                  label: Text(
                    "Buscar", // Text to accompany the icon (optional)
                    style: TextStyle(
                      fontSize: 16, // Font size for better readability
                      color:const Color.fromARGB(255, 29, 68, 134), // Text color matching the icon
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    foregroundColor: const Color.fromARGB(255, 29, 68, 134), // Text and icon color
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Padding for better spacing
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    elevation: 5, // Subtle shadow effect
                    // ignore: deprecated_member_use
                    shadowColor: Colors.blue.withOpacity(0.3), // Light blue shadow for effect
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: customersController.customers.length,
              itemBuilder: (BuildContext context, int index) {
                final customer = customersController.customers[index];
                bool hasRemainingTime = customer.remainingContractTime.hour != 0 || customer.remainingContractTime.minute != 0;
                
                return Card(
                  elevation: 4, // Adds a subtle shadow to the card for a floating effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Margins between items
                  child: ListTile(
                    tileColor: Colors.white, // Light background color for the tile
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Padding inside the tile
                    leading: Icon(
                      hasRemainingTime ? Icons.pause : Icons.stop,
                      color: hasRemainingTime ? Colors.green : Colors.red, // Color based on the contract time
                      size: 30, // Adjusted icon size for better visibility
                    ),
                    title: Text(
                      customer.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // Bold title for better readability
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      customer.dni,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54, // Slightly lighter color for subtitle
                      ),
                    ),
                    trailing: Icon(
                      Icons.ads_click,
                      color: const Color.fromARGB(255, 29, 68, 134), // Blue color for the trailing icon
                      size: 24, // Slightly smaller icon for the trailing arrow
                    ),
                    onTap:() {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Cliente n. ${customersController.customers[index].id}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                label: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Colors.black, // Adjusted color to match the theme
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero, // No padding around the icon button
                                ),
                              ),
                            ],
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildCustomerInfoRow("Nombre: ", customersController.customers[index].name),
                                _buildCustomerInfoRow("Número telefónico: ", customersController.customers[index].phoneNumber),
                                _buildCustomerInfoRow("E-Mail: ", customersController.customers[index].eMail),
                                _buildCustomerInfoRow("Dirección: ", customersController.customers[index].street),
                                _buildCustomerInfoRow("Código postal: ", customersController.customers[index].cp),
                                _buildCustomerInfoRow("Tipo de contrato: ", customersController.customers[index].contractType.name),
                                _buildCustomerInfoRow("Tiempo restante: ", customersController.customers[index].remainingContractTimeStr()),
                                _buildCustomerInfoRow("DNI: ", customersController.customers[index].dni),
                                SizedBox(height: 20), // Space before buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: hasRemainingTime ? ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context, MaterialPageRoute(
                                              builder: (context) {
                                                customersController.setCustomer(customersController.customers[index]);
                                                return BuenoDeHoras();
                                              },
                                            ),
                                          );
                                        },
                                        label: Icon(
                                          Icons.timer,
                                          size: 24, // Adjusted icon size for better visibility
                                          color: const Color.fromARGB(255, 29, 68, 134), // Icon color for contrast
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white, // Background color
                                          foregroundColor: const Color.fromARGB(255, 29, 68, 134), // Text and icon color
                                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Padding for better spacing
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12), // Rounded corners
                                          ),
                                          elevation: 5, // Subtle shadow effect
                                          // ignore: deprecated_member_use
                                          shadowColor: Colors.blue.withOpacity(0.3), // Light blue shadow for effect
                                        ),
                                      ) 
                                      : ElevatedButton.icon(
                                        onPressed: () {
                                          customersController.alert(context, "Error", "This customer finished his contract.");
                                        },
                                        label: Icon(
                                          Icons.timer,
                                          size: 24, // Adjusted icon size for better visibility
                                          color: const Color.fromARGB(255, 29, 68, 134), // Icon color for contrast
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red, // Background color
                                          foregroundColor: const Color.fromARGB(255, 29, 68, 134), // Text and icon color
                                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Padding for better spacing
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12), // Rounded corners
                                          ),
                                          elevation: 5, // Subtle shadow effect
                                          // ignore: deprecated_member_use
                                          shadowColor: Colors.blue.withOpacity(0.3), // Light blue shadow for effect
                                        ),
                                      )

                                    ),
                                    SizedBox(width: 10), // Space between the two buttons
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          if (await customersController.findCustomerFromNumberdb(customersController.customers[index].id)) {
                                            nombreController.text = customersController.customer!.name;
                                            emailController.text = customersController.customer!.eMail;
                                            numeroDeTelefonoController.text = customersController.customer!.phoneNumber;
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
                                                  Text(
                                                    "Editar cliente",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  TextButton.icon(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    label: Icon(
                                                      Icons.close,
                                                      size: 20,
                                                      color: Colors.black, // Adjusted color to match the theme
                                                    ),
                                                    style: TextButton.styleFrom(
                                                      padding: EdgeInsets.zero, // No padding around the icon button
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    textfieldCustomer,
                                                    SizedBox(height: 10),
                                                    ElevatedButton.icon(
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
                                                      label: Icon(
                                                        Icons.save_alt,
                                                        size: 24, // Adjusted icon size for better visibility
                                                        color: const Color.fromARGB(255, 29, 68, 134), // Icon color for contrast
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.white, // Background color
                                                        foregroundColor: const Color.fromARGB(255, 29, 68, 134), // Text and icon color
                                                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Padding for better spacing
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12), // Rounded corners
                                                        ),
                                                        elevation: 5, // Subtle shadow effect
                                                        // ignore: deprecated_member_use
                                                        shadowColor: Colors.blue.withOpacity(0.3), // Light blue shadow for effect
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        label: Icon(
                                          Icons.edit_document,
                                          size: 24, // Adjusted icon size for better visibility
                                          color: const Color.fromARGB(255, 29, 68, 134), // Icon color for contrast
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white, // Background color
                                          foregroundColor: const Color.fromARGB(255, 29, 68, 134), // Text and icon color
                                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Padding for better spacing
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12), // Rounded corners
                                          ),
                                          elevation: 5, // Subtle shadow effect
                                          // ignore: deprecated_member_use
                                          shadowColor: Colors.blue.withOpacity(0.3), // Light blue shadow for effect
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
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

///-------------------------------- class with the interface to manage the hours
enum SingingCharacter { casa, tienda }

// ignore: must_be_immutable, use_key_in_widget_constructors
class BuenoDeHoras extends StatelessWidget {
  ValueNotifier<SingingCharacter?> radioButtonSelectionNotifier = ValueNotifier<SingingCharacter?>(null);  
  SingingCharacter? radioButtonSelection;

  final customerSearchController = TextEditingController();
  final startTimeController = TextEditingController();
  late final endTimeController = TextEditingController();
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

  //IDEA: Exporting the signature as png or jpeg (to put them in a pdf file?)
  /*Future<void> _exportSignatureAsImage() async {
    try {
      // Get the signature image as a PNG
      final signature = await controllerSAT.toImage();
      final byteData = await signature?.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();

      // Get the device's directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/signature.png';

      // Save the image as PNG
      final file = File(filePath);
      await file.writeAsBytes(bytes as List<int>);

      print("Signature saved as PNG at: $filePath");
    } catch (e) {
      print("Error saving signature: $e");
    }
  }

  Future<void> _exportSignatureAsJPEG() async {
    try {
      // Get the signature image as PNG
      final signature = await controllerSAT.toImage();
      final byteData = await signature?.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();

      // Decode the PNG image into a usable format
      img.Image? decodedImage = img.decodeImage(Uint8List.fromList(bytes as List<int>));

      if (decodedImage != null) {
        // Convert the image to JPEG
        final jpegBytes = img.encodeJpg(decodedImage, quality: 85);

        // Get the device's directory to save the JPEG
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/signature.jpg';
        final file = File(filePath);

        // Save the JPEG image
        await file.writeAsBytes(jpegBytes);

        print("Signature saved as JPEG at: $filePath");
      }
    } catch (e) {
      print("Error saving signature as JPEG: $e");
    }
  }*/
  
  @override
  Widget build(BuildContext context) {
    customersController = context.watch<ApplicationController>();
    //The canvas for the SAT signature


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
            icon: const Icon(Icons.arrow_back_ios,size: 20),
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
        child: Column(
          children: [
            // Container for contract details
            Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Contrato de cliente",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  // Card displaying contract type and remaining hours
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.contrast, color: Colors.blue, size: 24),
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
                                Icon(Icons.access_time, color: Colors.orange, size: 24),
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
                                  style: customersController.customer != null && customersController.customer!.remainingContractTime.hour == 0 && customersController.customer!.remainingContractTime.minute == 0 
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.white,
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
                                    Icon(Icons.home, color: Colors.blue, size: 20),
                                    SizedBox(width: 10),
                                    Text("En casa del cliente", style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                                value: SingingCharacter.casa,
                                groupValue: selectedValue,
                                onChanged: (SingingCharacter? value) {
                                  customersController.serviceInShop(2);
                                  radioButtonSelectionNotifier.value = value;
                                },
                              ),
                              RadioListTile<SingingCharacter>(
                                title: Row(
                                  children: [
                                    Icon(Icons.store, color: Colors.orange, size: 20),
                                    SizedBox(width: 10),
                                    Text("En la tienda", style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                                value: SingingCharacter.tienda,
                                groupValue: selectedValue,
                                onChanged: (SingingCharacter? value) {
                                  customersController.serviceInShop(1);
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
                  // Row for work hours input buttons and summary
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
                                customersController.selectTime(context, true); // Start time button action
                              },
                              style: ElevatedButton.styleFrom(// Main blue accent color for the button
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14,horizontal: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 5, // Slight shadow for the button
                              ),
                              child: Text("Hora de inicio", style: TextStyle(fontSize: 16)),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Inicio: ${customersController.startTime}", // Start time display
                              style: TextStyle(fontSize: 16, color: Color(0xFF2A4365)), // Dark blue text for consistency
                            ),
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
                                customersController.selectTime(context, false); // End time button action
                              },
                              style: ElevatedButton.styleFrom( // Main blue accent color for the button
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14,horizontal: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 5, // Slight shadow for the button
                              ),
                              child: Text("Hora de fin", style: TextStyle(fontSize: 16)),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Fin: ${customersController.endTime}", // End time display
                              style: TextStyle(fontSize: 16, color: Color(0xFF2A4365)), // Dark blue text for consistency
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Work hours summary
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Card displaying contract type and remaining hours
                            Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(Icons.timelapse_sharp, color: Colors.blue, size: 24),
                                          SizedBox(width: 10),
                                          Text("Horas reales: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                                          SizedBox(width: 10),
                                          Text(customersController.workHoursString(), style: TextStyle(fontSize: 16, color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(Icons.timer, color: Colors.orange, size: 24),
                                          SizedBox(width: 10),
                                          Text("Horas contadas: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
                                          SizedBox(width: 10),
                                          Text(customersController.workHoursStringContadas(), style: TextStyle(fontSize: 16, color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Row for Save and View buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Save button
                      Expanded(
                        flex: 2,
                        child: 
                        customersController.customer!.remainingContractTime.hour != 0 || customersController.customer!.remainingContractTime.minute != 0 
                        ? ElevatedButton(
                          onPressed: () async {
                            bool success = await customersController.removeHours(customersController.customer!.dni);

                            radioButtonSelection = null;
                            radioButtonSelectionNotifier.value=null;
                            customersController.setStartName(TimeOfDay(hour: 0, minute: 0));
                            customersController.setEndTime(TimeOfDay(hour: 0, minute: 0));
                            customersController.serviceInShop(0);

                            if (success) {
                              // ignore: use_build_context_synchronously
                              customersController.alert(context, "Guardado", "Tiempo actualizado"); // Success message
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 5, // Slight shadow for the button
                          ),
                          child: Text("Guardar", style: TextStyle(fontSize: 16)),
                        ) 
                        : ElevatedButton(
                          onPressed: (){
                              customersController.alert(context, "Error", "This customer finished his contract.");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 5, // Slight shadow for the button
                          ),
                          child: Text("Guardar", style: TextStyle(fontSize: 16)),
                        ) 
                        ,
                      ),
                      /*SizedBox(width: 10,),
                      // View Data button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            print("sjdiahifciuswgbi");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 5, // Slight shadow for the button
                          ),
                          child: Text("Ver Datos", style: TextStyle(fontSize: 16)),
                        ),
                      ),*/
                    ],
                  ),
                ],
              ),
            ),
            // Signature section
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,  // White background for consistency with the buttons
                  borderRadius: BorderRadius.circular(12), // Rounded corners for a cohesive look
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.1), // Light shadow for a floating effect
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 4), // Shadow offset
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Left-align text for a cleaner look
                  children: [
                    // SAT Signature
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Firma SAT", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4A6FB1))),
                          ElevatedButton(
                            onPressed: () {
                              controllerSAT.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // White background
                              padding: EdgeInsets.symmetric(vertical: 14), // Consistent padding
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
                              elevation: 5, // Slight shadow for a floating effect
                            ),
                            child: Text("Limpia"),
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
                            color: Colors.black.withOpacity(0.2), // Light shadow for depth
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 4), // Shadow offset
                          ),
                        ],
                      ),
                      child: Signature(
                        controller: controllerSAT,
                        width: 500,
                        height: 250,
                        backgroundColor: Colors.white,
                      ),
                    ),

                    // Customer Signature
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Firma Cliente", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4A6FB1))),
                          ElevatedButton(
                            onPressed: () {
                              controllerCustomers.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // White background
                              padding: EdgeInsets.symmetric(vertical: 14), // Consistent padding
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
                              elevation: 5, // Slight shadow for a floating effect
                            ),
                            child: Text("Limpia"),
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
                            color: Colors.black.withOpacity(0.2), // Light shadow for depth
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 4), // Shadow offset
                          ),
                        ],
                      ),
                      child: Signature(
                        controller: controllerCustomers,
                        width: 500,
                        height: 250,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            )
          ]
        )
      )
    );
  }
}

// ignore: camel_case_types, use_key_in_widget_constructors
class resguardoDeDeposito extends StatelessWidget{
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
    );
  }
}
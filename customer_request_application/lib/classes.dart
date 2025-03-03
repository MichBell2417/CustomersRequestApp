import 'dart:async';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';

class Customer {
  int _id;
  String _name;
  String? _eMail;
  String _phoneNumber;
  String _street; //Where the customer live
  ContractType _contractType; //The type of contract the customers bougth
  TimeOfDay _remainingContractTime; //Remaining contract time for the customer
  String _dni;
  String _cp;

  //BUILDER
  Customer(this._id, this._name, this._eMail, this._phoneNumber, this._street,this._remainingContractTime, 
    this._contractType, this._dni, this._cp);
  
  //SETTER
  void setId(int id) {
    _id = id;
  }

  void setName(String name) {
    _name = name;
  }

  void setEmail(String? eMail) {
    _eMail = eMail;
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  void setStreet(String street) {
    _street = street;
  }

  void setContractType(ContractType contractType) {
    _contractType = contractType;
  }

  void setCP(String cp) {
    _cp = cp;
  }

  void setDNI(String dni) {
    _dni = dni;
  }

  //GETTER
  get id => _id;
  get name => _name;
  get eMail => _eMail;  
  get phoneNumber => _phoneNumber;
  get street => _street;
  get contractType => _contractType;
  get remainingContractTime => _remainingContractTime;
  get dni => _dni;
  get cp => _cp;

  //METHODS
  //This method returns the remaining time of the customer in string for it to be shown in the graphic part
  String remainingContractTimeStr() {
    return ApplicationController.timeInString(
        _remainingContractTime.hour, _remainingContractTime.minute);
  }
}

class ContractType {
  String _name;
  TimeOfDay _time;
  
  //BUILDER
  ContractType(this._name, this._time);
  
  //SETTER
  void setName(String name) {
    _name = name;
  }

  void setTime(TimeOfDay time) {
    _time = time;
  }

  //GETTER
  String get name => _name;
  TimeOfDay get time => _time;
}

class ApplicationController extends ChangeNotifier {
  //Array of contracts. The contracts doesn't change 
  final List<ContractType> contractTypes = <ContractType>[];
  
  //Array of Costumer
  List<Customer> customers = [];
  //Costumer
  Customer? customer;

  BuildContext? classContext;
  bool connectionStatus = false; //To track the status of the connection
  // ignore: non_constant_identifier_names
  String IPaddress = "192.168.0.146"; //The IP address of the computer where there is the mariaDB server
  MySqlConnection? database;
  String selectedContract = "";

  
  //------------------------------------------ notifyListeners();
  //Need this to update the graphic called by the interfaces
  void notifyListenersLocal(){
    notifyListeners();
  }

  //------------------------------------------ methods for the query
  void connectionDb() async {

    final conn = ConnectionSettings(
      host: IPaddress, // The IP address where you are connecting
      port: 3306, // Add the port of the socket(normally for the database it should be 3306)
      user: "tablet", // Your username on the DB
      password: "T3cn1c0@2025", // Your password on the DB
      db: "divermatica", // The name of the DataBase
    );

    //It will be called in 10 seconds while we are tryng to connect to the database. 
    //This permits to the user to restart or close the application if he can't connect to the database
    Timer(
      const Duration(seconds: 10), (){
        if (database==null) {
          connectionStatus=true;

          notifyListeners();

          showDialog<String>(
          context: classContext!,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Database Error"),
            content: Text("Database connection failed, check the wifi or the database status.\nRestart the application."),
            ),
          );

          //This closes the application
          Timer(
            const Duration(seconds: 5), (){
              SystemNavigator.pop();
            }
          );

        }
      }
    );


    while(!connectionStatus){
      try {
        database = await MySqlConnection.connect(conn);
        connectionStatus = true;
        pullContracts();
        pullCustomers();
        notifyListeners();
      } catch (e) {
        database=null;
        connectionStatus = false;
      }
    }
  }
  
  //This method takes the customers from the database and saves them inside the "customers" vector
  void pullCustomers() async {
    customers.clear();//Clearing the array

    var result = await database!.query('SELECT * FROM clientela'); //Query

    for (var customerDB in result) { //It fills the costumer array
      Duration time = customerDB['tiempo_restante'];
      int minutes = time.inMinutes;
      int hours = 0;

      if (minutes >= 60) {
        hours = (minutes / 60).toInt();
        minutes = minutes - hours * 60;
      }

      customers.add(Customer(
          customerDB['id'],
          customerDB['nombre'],
          customerDB['email'],
          customerDB['numero_telefonico'],
          customerDB['direccion'],
          TimeOfDay(hour: hours, minute: minutes),
          contractTypes[customerDB['id_contratos']-1],
          customerDB['dni'],
          customerDB['cp'],
        )
      );
    }

    notifyListeners();
  }

  void pullContracts() async {
    contractTypes.clear(); //Clearing the array

    var result = await database!.query('SELECT * FROM contratos'); //Query

    for (var contract in result) {
      
      Duration time = contract['duracion_contrato'];
      int minutes = time.inMinutes;
      int hours = 0;
      
      if (minutes >= 60) {
        hours = (minutes / 60).toInt();
        minutes = minutes - hours * 60;
      }
      
      contractTypes.add(ContractType(
          contract['nombre'], 
          TimeOfDay(hour: hours, minute: minutes)
        )
      );
    }

    notifyListeners();
  }

  //Upgrades the customer in the database
  void upgradeData(int index, String name, String eMail, String phoneNumber,String street,String cp,String dni) async {
    
    try {
      await database!.query(
          "UPDATE clientela SET nombre = '$name', email='$eMail', numero_telefonico='$phoneNumber', direccion='$street', cp='$cp', dni='$dni' WHERE id = $index; ");
      alert(classContext!, "Upgraded", "The customer has been upgraded.");
    }catch (e) {
      alert(classContext!, "Something went wrong...", "check if the data are correct or check the connection to the database.");
    }
    pullCustomers();

    notifyListeners();
  
  }

  //Adds a customer to the database
  Future<bool> addCustomer(String name, String eMail, String phoneNumber, String street,String cp,String dni) async {
    ContractType? contract;

    if (selectedContract != "") {
      for (int i = 0; i < contractTypes.length; i++) {
        if (selectedContract == contractTypes[i].name) {
          contract = contractTypes[i];
          try {
            var contractdb = await database!.query(
                'SELECT id,duracion_contrato FROM contratos WHERE nombre="${contract.name}" ');

            var idContract = contractdb.toList().first['id'];
            var timeDuration = contractdb.toList().first['duracion_contrato'];
            
            await database!.query(
                "INSERT INTO clientela (nombre,email,numero_telefonico,direccion,cp,id_contratos,tiempo_restante,dni) VALUES ('$name','$eMail','$phoneNumber','$street','$cp','$idContract','$timeDuration','$dni')");
            
            alert(classContext!, "Saved", "The customer has been saved in the database.");
            
            customers.add(Customer(await findNumberFromCustomerdb(name, eMail, phoneNumber), name, eMail, phoneNumber, street, contract.time, contract, dni, cp));
            
            selectedContract == "";
            pullCustomers();
            notifyListeners();

            return true;
          } catch (e) {
            alert(classContext!, "Not saved", "The customer hasn't been saved in the database. Check if you inserted the information right. ");
            return false;
          }
        }
      }
    }else{
      alert(classContext!, "Not saved", "Select a contract.");
      return false;
    }
    return false;
  }

//--------------------------------------------------------- Methods for the searching query
  Future<bool> findCustomerFromNumberdb(int index) async {
    Results customerdb;
    ResultRow customerLocal;
    try {
      customerdb = await database!.query("SELECT * FROM clientela WHERE id='$index'");
      customerLocal = customerdb.toList().first;
    } catch (e) {
      customer=null;
      notifyListeners();
      return false;
    }

    Duration time = customerLocal['tiempo_restante'];
    int minutes = time.inMinutes;
    int hours = 0;
    if (minutes >= 60) {
      hours = (minutes / 60).toInt();
      minutes = minutes - hours * 60;
    }

    customer = Customer(
        customerLocal['id'],
        customerLocal['nombre'],
        customerLocal['email'],
        customerLocal['numero_telefonico'],
        customerLocal['direccion'],
        TimeOfDay(hour: hours, minute: minutes),
        contractTypes[customerLocal['id_contratos']-1],
        customerLocal['dni'],
        customerLocal['cp']
    );

    notifyListeners();

    return true;
  }

  Future<bool> pullCustomersFromName(String name) async {
    customers.clear();//Clearing the array

    var result = await database!.query("SELECT * FROM clientela WHERE nombre='$name';"); //Query
    if(result.isNotEmpty){
      for (var customerDB in result) { //It fills the costumer array
        Duration time = customerDB['tiempo_restante'];
        int minutes = time.inMinutes;
        int hours = 0;

        if (minutes >= 60) {
          hours = (minutes / 60).toInt();
          minutes = minutes - hours * 60;
        }

        customers.add(Customer(
            customerDB['id'],
            customerDB['nombre'],
            customerDB['email'],
            customerDB['numero_telefonico'],
            customerDB['direccion'],
            TimeOfDay(hour: hours, minute: minutes),
            contractTypes[customerDB['id_contratos']-1],
            customerDB['dni'],
            customerDB['cp'],
          )
        );
      }
      notifyListeners();
      return true;
    }else{
      return false;
    }
  }

    Future<bool> pullCustomersFromPhoneNumber(String phoneNumber) async {
    customers.clear();//Clearing the array

    var result = await database!.query("SELECT * FROM clientela WHERE numero_telefonico='$phoneNumber';"); //Query

    for (var customerDB in result) { //It fills the costumer array
      Duration time = customerDB['tiempo_restante'];
      int minutes = time.inMinutes;
      int hours = 0;

      if (minutes >= 60) {
        hours = (minutes / 60).toInt();
        minutes = minutes - hours * 60;
      }

      customers.add(Customer(
          customerDB['id'],
          customerDB['nombre'],
          customerDB['email'],
          customerDB['numero_telefonico'],
          customerDB['direccion'],
          TimeOfDay(hour: hours, minute: minutes),
          contractTypes[customerDB['id_contratos']-1],
          customerDB['dni'],
          customerDB['cp'],
        )
      );
    }

    notifyListeners();
    return true;
  }

  Future<int> findNumberFromCustomerdb(String name, String eMail, String phoneNumber) async {
    var customerid = await database!.query(
        "SELECT id FROM clientela WHERE nombre= '$name' AND email = '$eMail' AND numero_telefonico='$phoneNumber'");

    //print(customerid.toList().first['id']);

    return customerid.toList().first['id'];
  }

  

//--------------------------------------------------------- Control the alert parts
  void alert(BuildContext context, String title, String description) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


//--------------------------------------------------------- part to check the selected radiobutton
  bool? _serviceInShop;
  void serviceInShop(bool value) {
    _serviceInShop = value;
    notifyListeners();
  }

//--------------------------------------------------------- part to control the time
  Future<bool> removeHours(int index) async {
    TimeOfDay remainingTime = customer!.remainingContractTime;
    TimeOfDay timeToRemove = workHoursContadas();
    if (timeToRemove.minute == 0 && timeToRemove.hour == 0) {
      return false;
    }
    if (_serviceInShop == null) {
      return false;
    }
    int hours = remainingTime.hour - timeToRemove.hour;
    int minutes = remainingTime.minute - timeToRemove.minute;
    if (hours < 0) {
      hours = 0;
    }
    if (minutes < 0) {
      if (hours > 0) {
        hours -= 1;
        minutes = 60 + minutes;
      } else {
        minutes = 0;
      }
    }

    var time = TimeOfDay(hour: hours, minute: minutes);
    Duration timeDuration = Duration(hours: time.hour, minutes: time.minute);
    try {
      await database!.query(
          "UPDATE clientela SET tiempo_restante='$timeDuration' WHERE id = $index");
    } catch (e) {
      alert(classContext!, "Error", "an error occured changing the time");
      return false;
    }

    customer!._remainingContractTime = TimeOfDay(hour: hours, minute: minutes);
    notifyListeners();
    return true;
  }

  TimeOfDay _startTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 0, minute: 0);

  void selectTime(BuildContext context, bool start) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      if (start) {
        _startTime = newTime;
      } else {
        _endTime = newTime;
      }
    }
    notifyListeners();
  }

  get startTime => timeInString(_startTime.hour, _startTime.minute);
  get endTime => timeInString(_endTime.hour, _endTime.minute);
  TimeOfDay workHours() {
    int hours = _endTime.hour - _startTime.hour;
    int minutes = _endTime.minute - _startTime.minute;
    if (hours < 0) {
      hours = 24 + hours;
    }
    if (minutes < 0) {
      if (hours > 0) {
        hours -= 1;
      }
      minutes = 60 + minutes;
    }
    return TimeOfDay(hour: hours, minute: minutes);
  }

  String workHoursString() {
    var time = workHours();
    return timeInString(time.hour, time.minute);
  }

  TimeOfDay workHoursContadas() {
    var time = workHours();
    int minute = time.minute;
    int hour = time.hour;
    if (_serviceInShop != null) {
      if (_serviceInShop!) {
        if (time.minute % 15 != 0) {
          minute = 15 * (minute ~/ 15) + 15;
        }
      } else {
        if (time.minute % 30 != 0) {
          minute = 30 * (minute ~/ 30) + 30;
        }
        if (minute >= 60) {}
      }
      return TimeOfDay(hour: hour, minute: minute);
    }
    return TimeOfDay(hour: 0, minute: 0);
  }

  String workHoursStringContadas() {
    var time = workHours();
    int minute = time.minute;
    int hour = time.hour;
    if (_serviceInShop != null) {
      if (_serviceInShop!) {
        if (time.minute % 15 != 0) {
          minute = 15 * (minute ~/ 15) + 15;
        }
      } else {
        if (time.minute % 30 != 0) {
          minute = 30 * (minute ~/ 30) + 30;
        }
      }
      if (minute == 60) {
        hour += 1;
        minute = 0;
      }
      return timeInString(hour, minute);
    } else {
      return "00:00";
    }
  }

  static String timeInString(int hour, int minute) {
    return "${hour < 10 ? "0$hour" : hour}:${minute < 10 ? "0$minute" : minute}";
  }
}

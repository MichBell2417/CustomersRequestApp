import 'dart:async';
import "package:flutter/material.dart";
import 'package:mysql1/mysql1.dart';

class Customer {
  String _name;
  String? _eMail;
  String _phoneNumber;
  String _street; //where the customer live
  ContractType _contractType; //the type of contract the customers bougth
  TimeOfDay _remainingContractTime; //time left
  Customer(this._name, this._eMail, this._phoneNumber, this._street,
      this._remainingContractTime, this._contractType);
  get eMail => _eMail;
  get name => _name;
  get phoneNumber => _phoneNumber;
  get street => _street;
  get contractType => _contractType;
  get remainingContractTime => _remainingContractTime;

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

  String remainingContractTimeStr() {
    return ApplicationController.timeInString(
        _remainingContractTime.hour, _remainingContractTime.minute);
  }
}

class ContractType {
  String _name;
  TimeOfDay _time;
  ContractType(this._name, this._time);
  void setName(String name) {
    _name = name;
  }

  void setTime(TimeOfDay time) {
    _time = time;
  }

  String get name => _name;
  TimeOfDay get time => _time;
}

class ApplicationController extends ChangeNotifier {
  Customer? customer;
  BuildContext? classContext;
  bool connectionStatus = false;
  final List<ContractType> contractTypes = <ContractType>[ContractType("primo", TimeOfDay(hour: 10, minute: 0))];
  List<Customer> customers = [];
  String IPaddress = "192.168.0.146";
  
  //------------------------------------------ notifyListeners();
  void notifyListenersLocal(){
    notifyListeners();
  }

  //------------------------------------------ usefull metods to comunicate with the db
  MySqlConnection? database;
  void connectionDb() async {
    final conn = ConnectionSettings(
      host: IPaddress, // Add your host IP address or server name
      port: 3306, // Add the port the server is running on
      user: "tablet", // Your username
      password: "T3cn1c0@2025", // Your password
      db: "divermatica", // Your DataBase name
    );
    //chargingdDb(classContext!);
    Timer(const Duration(seconds: 10), (){
      connectionStatus=true;
      notifyListeners();
      alert(classContext!, "database error",
      "database connection failed, check the wifi or the database status. \n And restart the application.");
    });
    while(!connectionStatus){
      try {
        database = await MySqlConnection.connect(conn);
        connectionStatus = true;
        pullContracts();
        pullCustomers();
        notifyListeners();
        //Navigator.of(classContext!).pop();
        //print("interface closed");
      } catch (e) {
        connectionStatus = false;
      }
    }
  }
  
  /// in this method the customers are taken from the database and saved inside the "customers" vector
  void pullCustomers() async {
    var result = await database!.query('SELECT * FROM clientela');
    customers.clear();
    for (var customerDB in result) {
      Duration time = customerDB['tiempo_restante'];
      int minutes = time.inMinutes;
      int hours = 0;
      if (minutes >= 60) {
        hours = (minutes / 60).toInt();
        minutes = minutes - hours * 60;
      }
      customers.add(Customer(
          customerDB['nombre'],
          customerDB['email'],
          customerDB['numero_telefonico'],
          customerDB['direccion'],
          TimeOfDay(hour: hours, minute: minutes),
          contractTypes[customerDB['id_contratos']]));
    }
  }

  void pullContracts() async {
    var result = await database!.query('SELECT * FROM contratos');
    contractTypes.clear();
    for (var contract in result) {
      Duration time = contract['duracion_contrato'];
      int minutes = time.inMinutes;
      int hours = 0;
      if (minutes >= 60) {
        hours = (minutes / 60).toInt();
        minutes = minutes - hours * 60;
      }
      contractTypes.add(ContractType(
          contract['nombre'], TimeOfDay(hour: hours, minute: minutes)));
    }
    notifyListeners();
  }

  String selectedContract = "";

  void upgradeData(int index, String name, String eMail, String phoneNumber,
      String street) async {
    if (eMail.contains('@')) {
      try {
        await database!.query(
            "UPDATE clientela SET nombre = '$name', email='$eMail', numero_telefonico='$phoneNumber', direccion='$street', cp='6523', dni='12345678c' WHERE id = $index ");
        alert(classContext!, "Upgraded", "The customer has been upgraded");
      } catch (e) {
        alert(classContext!, "Error", "check if the data are correct or check the connection to database.");
      }
    }
    /*try {
      customers[index].setName(name);
      customers[index].setEmail(eMail);
      customers[index].setPhoneNumber(phoneNumber);
      customers[index].setStreet(street);
    } catch (e) {
    }*/
  }

  Future<bool> addCustomer(String name, String eMail, String phoneNumber, String street) async {
    ContractType? contract;
    if (selectedContract != "") {
      for (int i = 0; i < contractTypes.length; i++) {
        if (selectedContract == contractTypes[i].name) {
          contract = contractTypes[i];
          break;
        }
      }
      if (contract != null && eMail.contains('@')) {
        customers.add(Customer(name, eMail, phoneNumber, street, contract.time, contract));
        //try {
          //print(contract.name);
          var contractdb = await database!.query(
              'SELECT id,duracion_contrato FROM contratos WHERE nombre="${contract.name}" ');
          //print(id_contract.toList().first['id']);
          var id_contract = contractdb.toList().first['id'];
          var time_duration = contractdb.toList().first['duracion_contrato'];
          //print(id_contract.runtimeType);
          //print(time_duration.runtimeType);
          await database!.query(
              "INSERT INTO clientela (nombre,email,numero_telefonico,direccion,cp,id_contratos,tiempo_restante,dni) VALUES ('$name','$eMail','$phoneNumber','$street','54352','$id_contract','$time_duration','12345678l')");
          alert(classContext!, "Saved", "the customer has been saved in database");
          return true;
        //} catch (e) {
          //alert(classContext!, "Not saved", "the customer hasn't been saved in database.");
          //return false;
        //}
      }else {
        alert(classContext!, "Not saved", "Insert a valid Email");
        return false;
      }
    }else{
      alert(classContext!, "Not saved", "Select a contract");
      return false;
    }
  }

//--------------------------------------------------------- control the alert parts
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

//--------------------------------------------------------- part to find the customer from his number
  //the customer number is the corresponding index in the vector "customers"
  bool findNumberCustomer(String indexStr) {
    customer = null;
    notifyListeners();
    try {
      int index = int.parse(indexStr);
      try {
        customer = customers[index];
        notifyListeners();
        return true;
      } catch (e) {}
    } catch (e) {}
    notifyListeners();
    return false;
  }

  Future<bool> findCustomerFromNumberdb(int index) async {
    Results customerdb;
    var customerLocal;
    try {
      customerdb = await database!.query("SELECT * FROM clientela WHERE id='$index'");
      customerLocal = customerdb.toList().first;
    } catch (e) {
      this.customer=null;
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
        customerLocal['nombre'],
        customerLocal['email'],
        customerLocal['numero_telefonico'],
        customerLocal['direccion'],
        TimeOfDay(hour: hours, minute: minutes),
        contractTypes[customerLocal['id_contratos']]);

    notifyListeners();

    return true;
  }

  Future<int> findNumberFromCustomerdb(
      String name, String eMail, String phone_number) async {
    var customerid = await database!.query(
        "SELECT id FROM clientela WHERE nombre= '$name' AND email = '$eMail' AND numero_telefonico='$phone_number'");

    print(customerid.toList().first['id']);

    return customerid.toList().first['id'];
  }

//--------------------------------------------------------- part to edit the hours remain
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
    Duration time_duration = Duration(hours: time.hour, minutes: time.minute);
    try {
      await database!.query(
          "UPDATE clientela SET tiempo_restante='$time_duration' WHERE id = $index");
    } catch (e) {
      alert(classContext!, "Error", "an error occured changing the time");
      return false;
    }

    customer!._remainingContractTime = TimeOfDay(hour: hours, minute: minutes);
    notifyListeners();
    return true;
  }

//--------------------------------------------------------- part to check the selected radiobutton
  bool? _serviceInShop;
  void serviceInShop(bool value) {
    _serviceInShop = value;
    notifyListeners();
  }

//--------------------------------------------------------- part to control the time
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

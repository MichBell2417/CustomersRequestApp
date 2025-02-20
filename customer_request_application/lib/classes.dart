import 'dart:ffi';

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
  final List<ContractType> contractTypes = <ContractType>[];
  List<Customer> customers = [];
  
  //------------------------------------------ notifyListeners();
  @override
  void notifyListenersLocal(){
    notifyListeners();
  }

  //------------------------------------------ usefull metods to comunicate with the db
  MySqlConnection? database;
  void conecctionDb() async {
    final conn = ConnectionSettings(
      host: "192.168.0.146", // Add your host IP address or server name
      port: 3306, // Add the port the server is running on
      user: "tablet", // Your username
      password: "123456", // Your password
      db: "divermatica", // Your DataBase name
    );
    try {
      database = await MySqlConnection.connect(conn);
      connectionStatus = true;
      pullContracts();
      pullCustomers();
    } catch (e) {
      connectionStatus = false;
      alert(classContext!, "database error",
          "database connection failed, check the wifi status");
    }
  }

  /// in this method the customers are taken from the database and saved inside the "customers" vector
  void pullCustomers() async {
    var result = await database!.query('SELECT * FROM customer');
    customers.clear();
    for (var customerDB in result) {
      Duration time = customerDB['remaining_time'];
      int minutes = time.inMinutes;
      int hours = 0;
      if (minutes >= 60) {
        hours = (minutes / 60).toInt();
        minutes = minutes - hours * 60;
      }
      customers.add(Customer(
          customerDB['name'],
          customerDB['email'],
          customerDB['phone_number'],
          customerDB['street'],
          TimeOfDay(hour: hours, minute: minutes),
          contractTypes[customerDB['id_contract']]));
    }
  }

  void pullContracts() async {
    var result = await database!.query('SELECT * FROM contract');
    contractTypes.clear();
    for (var contract in result) {
      Duration time = contract['time_duration'];
      int minutes = time.inMinutes;
      int hours = 0;
      if (minutes >= 60) {
        hours = (minutes / 60).toInt();
        minutes = minutes - hours * 60;
      }
      contractTypes.add(ContractType(
          contract['name'], TimeOfDay(hour: hours, minute: minutes)));
    }
    notifyListeners();
  }

  String selectedContract = "";

  void upgradeData(int index, String name, String eMail, String phoneNumber,
      String street) async {
    if (eMail.contains('@')) {
      try {
        var result = await database!.query(
            "UPDATE customer SET name = '$name', email='$eMail', phone_number='$phoneNumber', street='$street', CP='6523' WHERE id = $index ");
        alert(classContext!, "Upgraded", "The customer has been upgraded");
      } catch (e) {
        alert(classContext!, "Error", "check if the data are correct");
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

  void addCustomer(
      String name, String eMail, String phoneNumber, String street) async {
    ContractType? contract;
    if (selectedContract != "") {
      for (int i = 0; i < contractTypes.length; i++) {
        if (selectedContract == contractTypes[i].name) {
          contract = contractTypes[i];
          break;
        }
      }
      if (contract != null && eMail.contains('@')) {
        customers.add(Customer(
            name, eMail, phoneNumber, street, contract.time, contract));
        //print(contract.name);
        var contractdb = await database!.query(
            'SELECT id,time_duration FROM contract WHERE name="${contract.name}" ');
        //print(id_contract.toList().first['id']);
        var id_contract = contractdb.toList().first['id'];
        var time_duration = contractdb.toList().first['time_duration'];
        //print(id_contract.runtimeType);
        //print(time_duration.runtimeType);
        try {
          var result = await database!.query(
              "INSERT INTO customer (name,email,phone_number,street,CP,id_contract,remaining_time) VALUES ('$name','$eMail','$phoneNumber','$street','5432','$id_contract','$time_duration')");
          alert(classContext!, "Saved", "the customer has been saved");
        } catch (e) {
          alert(classContext!, "Not saved", "the customer hasn't been saved");
        }
      }
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
      customerdb = await database!.query("SELECT * FROM customer WHERE id='$index'");
      customerLocal = customerdb.toList().first;
    } catch (e) {
      this.customer=null;
      notifyListeners();
      return false;
    }

    Duration time = customerLocal['remaining_time'];
    int minutes = time.inMinutes;
    int hours = 0;
    if (minutes >= 60) {
      hours = (minutes / 60).toInt();
      minutes = minutes - hours * 60;
    }

    customer = Customer(
        customerLocal['name'],
        customerLocal['email'],
        customerLocal['phone_number'],
        customerLocal['street'],
        TimeOfDay(hour: hours, minute: minutes),
        contractTypes[customerLocal['id_contract']]);

    notifyListeners();

    return true;
  }

  Future<int> findNumberFromCustomerdb(
      String name, String eMail, String phone_number) async {
    var customerid = await database!.query(
        "SELECT id FROM costumer WHERE name= '$name' AND email = '$eMail' AND phone_number='$phone_number'");

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
    //try {
      var result = await database!.query(
          "UPDATE customer SET remaining_time='$time_duration' WHERE id = $index");
    //} catch (e) {
      //alert(classContext!, "Error", "an error occured changing the time");
      //return false;
    //}

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

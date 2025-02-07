import "package:flutter/material.dart";

class Customer{
  String _name;
  String? _eMail;
  String _phoneNumber;
  String _street; //where the customer live
  ContractType _contractType; //the type of contract the customers bougth
  TimeOfDay _remainingContractTime; //time left
  Customer(this._name, String eMail, this._phoneNumber, this._street, this._remainingContractTime, this._contractType){
    if(!eMail.contains('@')){
      print("Email error");
    }else{
      _eMail=eMail;
    }
  }
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

  String remainingContractTimeStr(){
    return ApplicationController.timeInString(_remainingContractTime.hour, _remainingContractTime.minute);
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

class ApplicationController extends ChangeNotifier{
  Customer? customer;

  final List<ContractType> contractTypes = <ContractType>[
    ContractType("decima",TimeOfDay(hour: 20, minute: 0)),
    ContractType("secunda",TimeOfDay(hour: 15, minute: 0)),
    ContractType("terza",TimeOfDay(hour: 10, minute: 0)),
    ContractType("quarta",TimeOfDay(hour: 5, minute: 0))
  ];
  //TODO: the data customer will be archived in csv file and the process will be automated
  List<Customer> customers = [
    Customer("Marco", "xx@gmail.com", "3333333333", "via, Marco Ruspi", TimeOfDay(hour: 10, minute: 0),ContractType("decima",TimeOfDay(hour: 20, minute: 0)),), 
    //Customer("Luca", "luce@gmail.com", "334555555", "via, Lucio Armando", TimeOfDay(hour: 15, minute: 0), "20h"),
    ];
  String selectedContract="";
  bool upgradeData(int index, String name, String eMail, String phoneNumber, String street){
    try {
      customers[index].setName(name);
      customers[index].setEmail(eMail);
      customers[index].setPhoneNumber(phoneNumber);
      customers[index].setStreet(street);
      return true;
    } catch (e) {
      return false;
    }
       
  }
  bool addCustomer(String name, String eMail, String phoneNumber, String street){
    ContractType? contract;
    if(selectedContract!=""){
      for(int i=0; i<contractTypes.length; i++){
        if(selectedContract==contractTypes[i].name){
          contract=contractTypes[i];
          break;
        }
      }
      if(contract!=null){
        customers.add(Customer(name, eMail, phoneNumber, street, contract.time, contract));
        return true;
      }
    }
    return false;
  }
//--------------------------------------------------------- control the alert parts
  void alert(BuildContext context, String title, String description){
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
  bool findNumberCustomer(String indexStr){
    try{
      int index=int.parse(indexStr);
      try {
        customer=customers[index];
        notifyListeners();
        return true;
      } catch (e) {
        print("error customer no exist");
      }
    }catch(e){
      print("error insert a number");
    }
    customer=null;
    notifyListeners();
    return false;
  }
//--------------------------------------------------------- part to edit the hours remain
  removeHours(){
    TimeOfDay remainingTime = customer!.remainingContractTime;
    TimeOfDay timeToRemove = workHoursContadas();
    int hours=remainingTime.hour-timeToRemove.hour;
    int minutes=remainingTime.minute-timeToRemove.minute;
    if(hours<0){
      hours=0;
    }
    if(minutes<0){
      if(hours>0){
        hours-=1;
      }
      minutes=60+minutes;
    }
    customer!._remainingContractTime=TimeOfDay(hour: hours, minute: minutes);
    notifyListeners();
  }
//--------------------------------------------------------- part to check the selected radiobutton
  bool? _serviceInShop;
  void serviceInShop(bool value){
    _serviceInShop=value;
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
        if(start){
          _startTime=newTime;
        }else{
          _endTime=newTime;
        }
    }
    notifyListeners();
  }

  get startTime => timeInString(_startTime.hour, _startTime.minute);
  get endTime => timeInString(_endTime.hour, _endTime.minute);
  TimeOfDay workHours(){
    int hours=_endTime.hour-_startTime.hour;
    int minutes=_endTime.minute-_startTime.minute;
    if(hours<0){
      hours=24+hours;
    }
    if(minutes<0){
      if(hours>0){
        hours-=1;
      }
      minutes=60+minutes;
    }
    return TimeOfDay(hour: hours, minute: minutes);
  }
  String workHoursString(){
    var time=workHours();
    return timeInString(time.hour,time.minute);
  }
  TimeOfDay workHoursContadas(){
    var time=workHours();
    int minute=time.minute;
    int hour=time.hour;
    if (_serviceInShop!=null){
      if(_serviceInShop!){
        if(time.minute%15!=0){
          minute=15*(minute~/15)+15;
        }
      }else{
        if(time.minute%30!=0){
          minute=30*(minute~/30)+30;
        }
        if(minute>=60){

        }
      }
      return TimeOfDay(hour: hour, minute: minute);
    }
    return TimeOfDay(hour: 0, minute: 0);
  }
  String workHoursStringContadas(){
    var time=workHours();
    int minute=time.minute;
    int hour=time.hour;
    if (_serviceInShop!=null){
      if(_serviceInShop!){
        if(time.minute%15!=0){
          minute=15*(minute~/15)+15;
        }
      }else{
        if(time.minute%30!=0){
          minute=30*(minute~/30)+30;
        }
      }
      if(minute==60){
        hour+=1;
        minute=0;
      }
      return timeInString(hour, minute);
    }else{
      return "seleccione un tipo de asistencia";
    }
  }
  static String timeInString(int hour, int minute){
    return "${hour<10 ? "0$hour" : hour}:${minute<10 ? "0$minute" : minute}";
  }
}
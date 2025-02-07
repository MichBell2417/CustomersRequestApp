import "package:flutter/material.dart";

class Customer{
  String _name;
  String? _eMail;
  int _phoneNumber;
  String _street; //where the customer live
  String _contractType; //the type of contract the customers bougth
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
  String remainingContractTimeStr(){
    return ApplicationController.timeInString(_remainingContractTime.hour, _remainingContractTime.minute);
  }
}

class ApplicationController extends ChangeNotifier{
  Customer? customer;
  //TODO: the data customer will be archived in csv file and the process will be automated
  List<Customer> customers = [
    Customer("Marco", "xx@gmail.com", 3333333333, "via, Marco Ruspi", TimeOfDay(hour: 3, minute: 0), "10h"), 
    Customer("Luca", "luce@gmail.com", 334555555, "via, Lucio Armando", TimeOfDay(hour: 15, minute: 0), "20h")
    ];
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
    return false;
  }
//--------------------------------------------------------- part to edit the hours remain
  removeHours(){
    TimeOfDay remainingTime = customer!.remainingContractTime;
    TimeOfDay timeToRemove = workHoursContadas();
    int hours=remainingTime.hour-timeToRemove.hour;
    int minutes=remainingTime.minute-timeToRemove.minute;
    if(hours<0){
      hours=24+hours;
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
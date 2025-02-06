import "package:flutter/material.dart";
import "package:provider/provider.dart";

class Customer{
  String _name;
  String? _eMail;
  int _phoneNumber;
  String _street; //where the customer live
  String _contractType; //the type of contract the customers bougth
  double _remainingContractTime; //time left
  Customer(this._name, String eMail, this._phoneNumber, this._street, this._remainingContractTime, this._contractType){
    if(!eMail.toLowerCase().contains('@')){
      print("Email error");
    }
  }
}

class ApplicationController extends ChangeNotifier{
  //TODO: the data customer will be archived in csv file and the process will be automated
  List<Customer> customers = [Customer("Marco", "xx@gmail.com", 3333333333, "via, Marco Ruspi", 3, "10h"), Customer("Luca", "luce@gmail.com", 334555555, "via, Lucio Armando", 15, "20h")];

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

  get startTime => "${_startTime.hour<10 ? "0${_startTime.hour}" : _startTime.hour}:${_startTime.minute<10 ? "0${_startTime.minute}" : _startTime.minute}";
  get endTime => "${_endTime.hour<10 ? "0${_endTime.hour}" : _endTime.hour}:${_endTime.minute<10 ? "0${_endTime.minute}" : _endTime.minute}";
  //get workHours => TimeOfDay(hour: _endTime.hour-_startTime.hour, minute: _endTime.minute-_startTime.minute);
  TimeOfDay workHours(){
    int hours=_endTime.hour-_startTime.hour;
    int minutes=_endTime.minute-_startTime.minute;
    if(hours<0){
      hours=24+hours;
    }
    if(minutes<0){
      hours-=1;
      minutes=60+minutes;
    }
    return TimeOfDay(hour: hours, minute: minutes);
  }
  String workHoursString(){
    var time=workHours();
    return "${time.hour<10 ? "0${time.hour}" : time.hour}:${time.minute<10 ? "0${time.minute}" : time.minute}";
  }
  String workHoursStringContadas(){
    var time=workHours();
    //TODO: check the radio button
    return "${time.hour<10 ? "0${time.hour}" : time.hour}:${time.minute<10 ? "0${time.minute}" : time.minute}";
  }
}

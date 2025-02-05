import "package:flutter/material.dart";

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
class applicationController extends ChangeNotifier{
  //TODO: the data customer will be archived in csv file and the process will be automated
  List<Customer> customers = [Customer("Marco", "xx@gmail.com", 3333333333, "via, Marco Ruspi", 3, "10h"), Customer("Luca", "luce@gmail.com", 334555555, "via, Lucio Armando", 15, "20h")];


}

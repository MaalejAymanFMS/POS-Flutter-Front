import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      children: [
        Container(
          color: Colors.red,
          height: 50,
        child: Center(child: Text("Header",style: TextStyle(fontSize: 20,color: Colors.white),)),),
        Expanded(child: Container(
          color: Colors.blue,
          child: Row(
            children: [
              Container(
                width: 200,
                color: Colors.green),
    
              Expanded(
                flex: 5,
                child: Container(color: Colors.yellow,)),
            ],
          ))),
      ],
    ),);
  }
}
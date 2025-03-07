import 'package:customer_request_application/classes.dart';
import 'package:customer_request_application/interfaces.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(PrincipalPage());
}

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationController(),
      child: MaterialApp(
        home: Menu(),
      ),
    );
  }
}
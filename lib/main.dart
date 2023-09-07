import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_integration/stripe.dart';
import 'package:payment_integration/stripe2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//Assign publishable key to flutter_stripe
  Stripe.publishableKey =
      'pk_test_51NnF74BlRldTZFO0DvBPpCIU83fF4QSO2uYJ87FeXikcijFn0X3iXU4fI59g257hLpfROjfVwZ4U95X3ac1Dbe0N00Ccl18Pft';

  //Load our .env file that contains our Stripe Secret key
  // await dotenv.load(fileName: 'assets/.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Stripp(),
    );
  }
}

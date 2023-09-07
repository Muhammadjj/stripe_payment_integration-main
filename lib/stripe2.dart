import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Stripe2 extends StatefulWidget {
  const Stripe2({super.key});

  @override
  State<Stripe2> createState() => _Stripe2State();
}

class _Stripe2State extends State<Stripe2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expMonthController = TextEditingController();
  final TextEditingController _expYearController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _submitPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
        _errorMessage = null;
      });

      final cardNumber = _cardNumberController.text;
      final expMonth = int.parse(_expMonthController.text);
      final expYear = int.parse(_expYearController.text);
      final cvc = _cvvController.text;

      final url = Uri.parse('https://api.stripe.com/v1/charges');

      final response = await http.post(url, headers: {
        'Authorization':
            'Bearer sk_test_51NnF74BlRldTZFO0KNhIdU5thKJWDW89LAS1BOrOquph8sye6JiVrjQctDSxasktSdKq41jLr3CuDQSqoqhEsGyq00TkV16ub3',
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'amount': '1000',
        'currency': 'usd',
        // 'source': 'tok_visa',
        'description': 'Sample Charge',
        'card[number]': cardNumber,
        'card[exp_month]': expMonth.toString(),
        'card[exp_year]': expYear.toString(),
        'card[cvc]': cvc,
      });
      if (response.statusCode == 200) {
        // Request successful, parse the response
        final jsonResponse = json.decode(response.body);

        // Handle the response data as needed
        print('Payment successful! Response: $jsonResponse');
        setState(() {
          _errorMessage = null;
        });
      } else {
        // Request failed, handle the error
        print('Error: ${response.statusCode}');

        print('Response body: ${response.body}');
        setState(() {
          _errorMessage = 'Payment failed. Please Try again';
        });
      }
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(labelText: 'Card Number'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a card number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expMonthController,
                        decoration:
                            const InputDecoration(labelText: 'Exp Month'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an expiration month';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _expYearController,
                        decoration:
                            const InputDecoration(labelText: 'Exp Year'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an expiration year';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _cvvController,
                  decoration: const InputDecoration(labelText: 'CVV'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter CVV';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                //  Button
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitPayment,
                  child: _isSubmitting
                      ? const Center(child: CircularProgressIndicator())
                      : const Text('Submit Payment'),
                ),
                const SizedBox(height: 16.0),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

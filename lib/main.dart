import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Geex Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Helvetica',
      ),
      home: const CurrencyConverterScreen(),
    );
  }
}

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  String amount = '1,427.34';
  String receivedAmount = '37,817,767';
  String fromCurrency = 'USD';
  String toCurrency = 'BTC';

  TextEditingController amountController = TextEditingController(text: '1,427.34');

  // Method to update amount
  void updateAmount(String value) {
    setState(() {
      // In a real app, you would implement proper conversion logic here
      amount = value;
      // Mock conversion - in a real app this would use actual exchange rates
      if (value.isNotEmpty) {
        double parsedValue = double.tryParse(value.replaceAll(',', '')) ?? 0.0;
        double convertedValue = parsedValue * 26496.453; // Mock conversion rate
        receivedAmount = convertedValue.toStringAsFixed(3);
      } else {
        receivedAmount = '0';
      }
    });
  }

  void appendDigit(String digit) {
    String newValue = amount.replaceAll(',', '') + digit;
    double? parsed = double.tryParse(newValue);
    if (parsed != null) {
      setState(() {
        amount = _formatNumber(newValue);
        updateAmount(newValue);
      });
    }
  }

  void deleteDigit() {
    if (amount.replaceAll(',', '').length > 1) {
      String newValue = amount.replaceAll(',', '').substring(0, amount.replaceAll(',', '').length - 1);
      setState(() {
        amount = _formatNumber(newValue);
        updateAmount(newValue);
      });
    } else {
      setState(() {
        amount = '0';
        updateAmount('0');
      });
    }
  }

  void clearAmount() {
    setState(() {
      amount = '0';
      updateAmount('0');
    });
  }

  String _formatNumber(String value) {
    double? parsed = double.tryParse(value);
    if (parsed != null) {
      return parsed.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},'
      );
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'geex',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        '2',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Enter Amount Section
              Text(
                'Enter Amount',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      amount,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Text('\$', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 5),
                        Text(
                          fromCurrency,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, size: 16),
                      ],
                    ),
                  ),
                ],
              ),

              // Yellow Button
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Icon(Icons.swap_vert),
                ),
              ),

              // You Receive Section
              SizedBox(height: 16),
              Text(
                'You Receive',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      receivedAmount,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Text('₿', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 5),
                        Text(
                          toCurrency,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, size: 16),
                      ],
                    ),
                  ),
                ],
              ),

              // Number Pad
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildNumberKey('7'),
                      _buildNumberKey('8'),
                      _buildNumberKey('9'),
                      _buildActionKey(Icons.remove, () {}),
                      _buildNumberKey('4'),
                      _buildNumberKey('5'),
                      _buildNumberKey('6'),
                      _buildActionKey(Icons.add, () {}),
                      _buildNumberKey('1'),
                      _buildNumberKey('2'),
                      _buildNumberKey('3'),
                      Container(
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            '=',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      _buildActionKey(Icons.backspace_outlined, deleteDigit),
                      _buildNumberKey('0'),
                      _buildNumberKey('.'),
                      Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberKey(String number) {
    return InkWell(
      onTap: () => appendDigit(number),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Icon(icon, size: 24),
        ),
      ),
    );
  }
}
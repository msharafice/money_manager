import 'package:flutter/material.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  String type = 'income';
  DateTime selectedDate = DateTime.now();

  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010, 01),
      lastDate: DateTime(2050, 12),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff69247C),
        centerTitle: true,
        title: Text(
          'ثبت تراکنش جدید',
          style: TextStyle(fontFamily: 'yekan', color: Colors.white),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'مبلغ',
              prefixIcon: Icon(Icons.money, color: Colors.green),
            ),
            style: TextStyle(fontFamily: 'yekan'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'شرح تراکنش',
              prefixIcon: Icon(Icons.description),
            ),
            style: TextStyle(fontFamily: 'yekan'),
            maxLength: 70,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ChoiceChip(
                    label: Text(
                      'هزینه',
                      style: TextStyle(
                        fontFamily: 'yekan',
                        color: type == 'expense' ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    selected: type == 'expense' ? true : false,
                    onSelected: (value) {
                      if (value) {
                        setState(() {
                          type = 'expense';
                        });
                      }
                    },
                    selectedColor: Color(0xFFDA498D),
                    disabledColor: Color(0xFFF9E6CF),
                  ),
                  SizedBox(width: 20),
                  ChoiceChip(
                    label: Text(
                      'درآمد',
                      style: TextStyle(
                        fontFamily: 'yekan',
                        color: type == 'income' ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    selected: type == 'income' ? true : false,
                    onSelected: (value) {
                      if (value) {
                        setState(() {
                          type = 'income';
                        });
                      }
                    },
                    selectedColor: Color(0xFFDA498D),
                    disabledColor: Color(0xFFF9E6CF),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _selectedDate(context);
                },

                child: Text(
                  '${selectedDate.day} ${months[selectedDate.month - 1]}',
                  style: TextStyle(
                    fontFamily: 'yekan',
                    color: Color(0xff69247C),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff69247C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'افزودن تراکنش',
                style: TextStyle(
                  fontFamily: 'yekan',
                  color: Color(0xFFF9E6CF),
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

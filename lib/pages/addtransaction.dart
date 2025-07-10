import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_manager/db/db_manager.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  String type = 'Income';
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
  int? amount;
  String? description;

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 01),
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
        title: Text(
          'ثبت تراکنش جدید',
          style: TextStyle(fontFamily: 'yekan'),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'مبلغ',
              prefixIcon: Icon(
                Icons.money,
                color: Colors.green,
              ),
            ),
            style: TextStyle(fontFamily: 'yekan'),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              try {
                amount = int.parse(val);
              } catch (e) {}
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'شرح تراکنش',
              prefixIcon: Icon(
                Icons.description,
              ),
            ),
            style: TextStyle(fontFamily: 'yekan'),
            maxLength: 32,
            onChanged: (val) {
              description = val;
            },
          ),
          SizedBox(
            height: 20,
          ),
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
                        color: type == 'Expense' ? Colors.white : Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    selected: type == 'Expense' ? true : false,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          type = 'Expense';
                        });
                      }
                    },
                    selectedColor: Colors.blue,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ChoiceChip(
                    label: Text(
                      'درآمد',
                      style: TextStyle(
                        fontFamily: 'yekan',
                        color: type == 'Income' ? Colors.white : Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    selected: type == 'Income' ? true : false,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          type = 'Income';
                        });
                      }
                    },
                    selectedColor: Colors.blue,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  _selectedDate(context);
                },
                child: Text(
                  '${selectedDate.day} ${months[selectedDate.month - 1]} ',
                  style: TextStyle(
                    fontFamily: 'yekan',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async{
                  if(amount != null && description!.isNotEmpty){
                    DbManager dbmanager = DbManager();
                    await dbmanager.addData(amount!, selectedDate, description!, type);
                    Navigator.of(context).pop();
                  }else{
                    print('Wrong');
                  }
                },
                child: Text(
                  'افزودن',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontFamily: 'yekan',
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

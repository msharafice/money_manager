import 'package:flutter/material.dart';
import 'package:money_manager/db/db_manager.dart';
import 'package:money_manager/pages/addtransaction.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbManager dbManager = DbManager();

  int balance = 0;
  int income = 0;
  int expense = 0;

  getBalanceData(Map entireData) {
    balance = 0;
    income = 0;
    expense = 0;
    entireData.forEach((key, value) {
      if (value['type'] == 'Income') {
        balance += (value['amount'] as int);
        income += (value['amount'] as int);
      } else {
        balance -= (value['amount'] as int);
        expense += (value['amount'] as int);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff69247C),
        centerTitle: true,
        title: Text(
          'برنامه مدیریت مالی',
          style: TextStyle(fontFamily: 'yekan', color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFAC67A),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddTransaction()))
              .whenComplete(() {
                setState(() {});
              });
        },
        child: Icon(Icons.add, size: 40, color: Color(0xFF69247C)),
      ),
      body: FutureBuilder<Map>(
        future: dbManager.fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(width: 200, height: 100, child: Text('Has Error'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(child: Text('No Data'));
            } else {
              getBalanceData(snapshot.data!);
              return Container(
                margin: EdgeInsets.only(top: 15),
                width: MediaQuery.of(context).size.width * 0.85,

                child: Column(
                  children: [
                    Text(
                      'محمد عزیز،خوش آمدید',
                      style: TextStyle(
                        fontFamily: 'yekan',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [Colors.purple, Colors.blueAccent],
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'موجودی',
                              style: TextStyle(
                                fontFamily: 'yekan',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              balance.toString(),
                              style: TextStyle(
                                fontFamily: 'yekan',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Income(income.toString()),
                                SizedBox(height: 20),
                                Expense(expense.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(child: Text('Unexpected Error'));
          }
        },
      ),
    );
  }
}

Widget Income(String val) {
  return Row(
    children: [
      CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.arrow_upward, color: Colors.green),
      ),
      SizedBox(width: 15),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'واریز',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'yekan',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            val,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'yekan',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget Expense(String val) {
  return Row(
    children: [
      CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.arrow_downward, color: Colors.red),
      ),
      SizedBox(width: 15),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'برداشت',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'yekan',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            val,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'yekan',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ],
  );
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_manager/db/db_manager.dart';
import 'package:money_manager/pages/addtransaction.dart';
import 'package:money_manager/pages/alerts_screen/dialog_box.dart';
import 'package:money_manager/pages/get_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/transactions_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbManager dbManager = DbManager();
  late SharedPreferences preferences;
  late Box box;
  int balance = 0;
  int income = 0;
  int expense = 0;
  List<FlSpot> dataSet = [];
  DateTime today = DateTime.now();

  List<FlSpot> getBalancePoint(List<TransactionModel> entireDate) {
    List<TransactionModel> tempData = [];
    List<FlSpot> points = [];
    int Balance = 0;

    for (TransactionModel data in entireDate) {
      if (data.date.month == today.month) {
        tempData.add(data);
      }
    }

    tempData.sort((a, b) => a.date.day.compareTo(b.date.day));

    for (var data in tempData) {
      if (data.type == 'Income') {
        Balance += data.amount;
      } else {
        Balance -= data.amount;
      }
      points.add(FlSpot(data.date.day.toDouble(), Balance.toDouble()));
    }

    return points;
  }

  List<FlSpot> getExpensePoint(List<TransactionModel> entireDate) {
    dataSet = [];
    // entireDate.forEach((key, value) {
    //   if (value['type'] == 'Expense' &&
    //       (value['date'] as DateTime).month == today.month) {
    //     dataSet.add(FlSpot((value['date'] as DateTime).day.toDouble(),
    //         (value['amount'] as int).toDouble()));
    //   }
    // });
    List tempData = [];
    for (TransactionModel data in entireDate) {
      if (data.date.month == today.month && data.type == "Expense") {
        tempData.add(data);
      }
    }
    tempData.sort((a, b) => a.date.day.compareTo(b.date.day));
    for (var i = 0; i < tempData.length; i++) {
      dataSet.add(
        FlSpot(tempData[i].date.day.toDouble(), tempData[i].amount.toDouble()),
      );
    }
    return dataSet;
  }

  List<FlSpot> getIncomePoint(List<TransactionModel> entireDate) {
    dataSet = [];
    // entireDate.forEach((key, value) {
    //   if (value['type'] == 'Income' &&
    //       (value['date'] as DateTime).month == today.month) {
    //     dataSet.add(FlSpot((value['date'] as DateTime).day.toDouble(),
    //         (value['amount'] as int).toDouble()));
    //   }
    // });
    List tempData = [];
    for (TransactionModel data in entireDate) {
      if (data.date.month == today.month && data.type == "Income") {
        tempData.add(data);
      }
    }
    tempData.sort((a, b) => a.date.day.compareTo(b.date.day));
    for (var i = 0; i < tempData.length; i++) {
      dataSet.add(
        FlSpot(tempData[i].date.day.toDouble(), tempData[i].amount.toDouble()),
      );
    }
    return dataSet;
  }

  getBalanceData(List<TransactionModel> entireData) {
    balance = 0;
    income = 0;
    expense = 0;
    // entireData.forEach((key, value) {
    //   if (value['type'] == 'Income') {
    //     balance += (value['amount'] as int);
    //     income += (value['amount'] as int);
    //   } else {
    //     balance -= (value['amount'] as int);
    //     expense += (value['amount'] as int);
    //   }
    // });
    for (TransactionModel data in entireData) {
      if (data.date.month == today.month) {
        if (data.type == 'Income') {
          balance += data.amount;
          income += data.amount;
        } else {
          balance -= data.amount;
          expense += data.amount;
        }
      }
    }
  }

  getPreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<List<TransactionModel>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        // print(element);
        items.add(
          TransactionModel(
            element['amount'] as int,
            element['date'] as DateTime,
            element['description'],
            element['type'],
          ),
        );
      });
      return items;
    }
  }

  @override
  void initState() {
    super.initState();
    getPreferences();
    box = Hive.box('money');
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'برنامه مدیریت مالی',
          style: TextStyle(fontFamily: 'yekan'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddTransaction()))
              .whenComplete(() {
                setState(() {});
              });
        },
        child: Icon(Icons.add, size: 40),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<TransactionModel>>(
          future: fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Has Error'));
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(child: Text('No Date'));
              }
              getBalanceData(snapshot.data!);
              return Container(
                color: Colors.grey.shade200,
                padding: EdgeInsets.only(top: 15),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 12),
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings),
                          ),
                        ),
                        SizedBox(width: 25),
                        Text(
                          '${preferences.getString('name')} به برنامه خوش آمدی',
                          style: TextStyle(
                            fontFamily: 'yekan',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: double.infinity,
                        height: 180,
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
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              balance.toString(),
                              style: TextStyle(
                                fontFamily: 'yekan',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
                    SizedBox(height: 25),
                    Text(
                      'نمودار موجودی',
                      style: TextStyle(
                        fontFamily: 'yekan',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: LineChart(
                        LineChartData(
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: getBalancePoint(snapshot.data!),
                              isCurved: false,
                              barWidth: 3,
                              color: Colors.deepPurple,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 25),

                    Text(
                      'نمودار برداشت ها',
                      style: TextStyle(
                        fontFamily: 'yekan',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: LineChart(
                        LineChartData(
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: getExpensePoint(snapshot.data!),
                              isCurved: false,
                              barWidth: 3,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      'نمودار واریز ها',
                      style: TextStyle(
                        fontFamily: 'yekan',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: LineChart(
                        LineChartData(
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: getIncomePoint(snapshot.data!),
                              isCurved: false,
                              barWidth: 3,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      'آخرین تراکنش ها',
                      style: TextStyle(
                        fontFamily: 'yekan',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 25),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        TransactionModel dataIndex = snapshot.data![index];
                        if (snapshot.data != null) {
                          if (dataIndex.type == 'Income') {
                            return incomeUI(
                              dataIndex.amount,
                              dataIndex.description,
                              dataIndex.date,
                              index,
                            );
                          } else {
                            return expenseUI(
                              dataIndex.amount,
                              dataIndex.description,
                              dataIndex.date,
                              index,
                            );
                          }
                        } else {
                          return Text('Wrong');
                        }
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Unexpected Error'));
            }
          },
        ),
      ),
    );
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

  Widget incomeUI(int value, String description, DateTime date, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onLongPress: () async {
          bool? answer = await showConfirmDialog(
            context,
            'حذف واریز',
            'آیا از حذف این تراکنش واریز اطمینان دارید ؟',
          );
          if (answer != null && answer) {
            dbManager.deleteData(index);
            setState(() {});
          }
        },
        child: Container(
          width: double.infinity,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.green.shade400,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_upward, color: Colors.green),
                    ),
                    SizedBox(width: 15),
                    Column(
                      children: [
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'yekan',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${date.day} / ${date.month}',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'yekan',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  value.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'yekan',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget expenseUI(int value, String description, DateTime date, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onLongPress: () async {
          bool? answer = await showConfirmDialog(
            context,
            'حذف برداشت',
            'آیا از حذف این تراکنش برداشت اطمینان دارید ؟',
          );
          if (answer != null && answer) {
            dbManager.deleteData(index);
            setState(() {});
          }
        },
        child: Container(
          width: double.infinity,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_downward, color: Colors.red),
                    ),
                    SizedBox(width: 15),
                    Column(
                      children: [
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'yekan',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${date.day} / ${date.month}',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'yekan',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  value.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'yekan',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

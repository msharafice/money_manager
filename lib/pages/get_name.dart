import 'package:flutter/material.dart';
import 'package:money_manager/db/db_manager.dart';
import 'package:money_manager/pages/home_page.dart';

class GetName extends StatefulWidget {
  const GetName({Key? key}) : super(key: key);

  @override
  State<GetName> createState() => _GetNameState();
}

class _GetNameState extends State<GetName> {
  DbManager dbManager = DbManager();
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 25),
              Text(
                'به برنامه مدیریت مالی خوش آمدید',
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'yekan',
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 25),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset('assets/images/money.png'),
              ),
              SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: TextField(
                    onChanged: (val) {
                      name = val;
                    },
                    decoration: InputDecoration(border: InputBorder.none),
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              SizedBox(height: 25),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (name.isNotEmpty) {
                      dbManager.addName(name);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          action: SnackBarAction(
                            label: 'Ok',
                            onPressed: () {
                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                            },
                            textColor: Colors.white,
                          ),
                          backgroundColor: Colors.red.shade700,
                          content: Text(
                            'لطفا نام خود را وارد نمایید',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'yekan',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.navigate_before),
                      Text(
                        'بعدی',
                        style: TextStyle(
                          fontFamily: 'yekan',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}

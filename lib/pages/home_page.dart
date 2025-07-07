import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        backgroundColor: Color(0xFFF9E6CF),
        onPressed: () {},
        child: Icon(Icons.add, size: 40, color: Color(0xFF69247C)),
      ),
    );
  }
}

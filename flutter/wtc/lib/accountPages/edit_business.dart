import 'package:flutter/material.dart';

class EditBusinessInfo extends StatefulWidget {
  const EditBusinessInfo({super.key});

  @override
  State<EditBusinessInfo> createState() => _EditBusinessInfoState();
}

class _EditBusinessInfoState extends State<EditBusinessInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Business Info",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: const Color(0xFF469AB8),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Edit Business Info"),
          ],
        ),
      ),
    );
  }
}
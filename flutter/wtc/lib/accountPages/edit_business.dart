import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:wtc/components/textfield.dart';

class EditBusinessInfo extends StatefulWidget {
  const EditBusinessInfo({super.key});

  @override
  State<EditBusinessInfo> createState() => _EditBusinessInfoState();
}

class _EditBusinessInfoState extends State<EditBusinessInfo> {

  User? user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getBusinessInfo() async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.email)
        .get();
  }

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _bioController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String mondayOpen = "";
  String mondayClose = "";
  String tuesdayOpen = "";
  String tuesdayClose = "";
  String wednesdayOpen = "";
  String wednesdayClose = "";
  String thursdayOpen = "";
  String thursdayClose = "";
  String fridayOpen = "";
  String fridayClose = "";
  String saturdayOpen = "";
  String saturdayClose = "";
  String sundayOpen = "";
  String sundayClose = "";

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
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getBusinessInfo(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasError){
            return const Center(
              child: Text("Error loading data"),
            );
          }
          else if(snapshot.hasData){

            Map<String, dynamic> data = snapshot.data!.data()!;

            _addressController.text = data["address"];
            _bioController.text = data["about"];

            PhoneNumber number = PhoneNumber(isoCode: "US", phoneNumber: data["phone"]);

            String monday = data["businessHours"]["Monday"];
            String tuesday = data["businessHours"]["Tuesday"];
            String wednesday = data["businessHours"]["Wednesday"];
            String thursday = data["businessHours"]["Thursday"];
            String friday = data["businessHours"]["Friday"];
            String saturday = data["businessHours"]["Saturday"];
            String sunday = data["businessHours"]["Sunday"];

            if(monday.length > 3){
              mondayOpen = monday.split(" - ")[0];
              mondayClose = monday.split(" - ")[1];
            }
            if(tuesday.length > 3){
              tuesdayOpen = tuesday.split(" - ")[0];
              tuesdayClose = tuesday.split(" - ")[1];
            }
            if(wednesday.length > 3){
              wednesdayOpen = wednesday.split(" - ")[0];
              wednesdayClose = wednesday.split(" - ")[1];
            }
            if(thursday.length > 3){
              thursdayOpen = thursday.split(" - ")[0];
              thursdayClose = thursday.split(" - ")[1];
            }
            if(friday.length > 3){
              fridayOpen = friday.split(" - ")[0];
              fridayClose = friday.split(" - ")[1];
            }
            if(saturday.length > 3){
              saturdayOpen = saturday.split(" - ")[0];
              saturdayClose = saturday.split(" - ")[1];
            }
            if(sunday.length > 3){
              sundayOpen = sunday.split(" - ")[0];
              sundayClose = sunday.split(" - ")[1];
            }

            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Edit Business Address

                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\tEdit Address",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      MyTextField(
                        hintText: "Change Address", 
                        obscureText: false, 
                        controller: _addressController,
                      ),

                      const SizedBox(height: 15.0),

                      // Edit Business Bio

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\tEdit Business Description",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10.0),

                      MyTextField(
                        hintText: "Change Business Description", 
                        obscureText: false, 
                        controller: _bioController,
                      ),

                      const SizedBox(height: 15.0),

                      // Edit Business Phone Number

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\tEdit Phone Number",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10.0),

                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          _phoneController.text = number.phoneNumber!;
                        },
                        maxLength: 12,
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET
                        ),
                        countries: const ["US"],
                        initialValue: number,
                      ),

                      const SizedBox(height: 20.0),

                      const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\tEdit Business Hours",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),

                      DataTable(
                          columns: const [
                            DataColumn(label: Text("Day")),
                            DataColumn(label: Text("Open")),
                            DataColumn(label: Text("Close")),
                          ],
                          rows: [
                            DataRow(cells: [
                              const DataCell(Text("Monday")),
                              DataCell(
                                onTap:(){
                                  showTimePicker(
                                    context: context, 
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  ).then((value){
                                    if(value != null){
                                      setState(() {
                                        mondayOpen = value.format(context);
                                      });
                                    }
                                  });
                                },
                                Text(mondayOpen),
                              ),
                              DataCell(
                                onTap:(){
                                  showTimePicker(
                                    context: context, 
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  ).then((value){
                                    if(value != null){
                                      setState(() {
                                        mondayClose = value.format(context);
                                      });
                                    }
                                  });
                                },                      
                                Text(mondayClose),
                              ),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("Tuesday")),
                              DataCell(
                                onTap:(){
                                  showTimePicker(
                                    context: context, 
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  ).then((value){
                                    if(value != null){
                                      setState(() {
                                        tuesdayOpen = value.format(context);
                                      });
                                    }
                                  });
                                },
                                Text(tuesdayOpen)
                                ),
                              DataCell(
                                onTap:(){
                                  showTimePicker(
                                    context: context, 
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  ).then((value){
                                    if(value != null){
                                      setState(() {
                                        tuesdayClose = value.format(context);
                                      });
                                    }
                                  });
                                },
                                Text(tuesdayClose)
                                ),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("Wednesday")),
                              DataCell(
                                onTap:(){
                                  showTimePicker(
                                    context: context, 
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  ).then((value){
                                    if(value != null){
                                      setState(() {
                                        wednesdayOpen = value.format(context);
                                      });
                                    }
                                  });
                                },
                                Text(wednesdayOpen)
                                ),
                              DataCell(
                                onTap:(){
                                  showTimePicker(
                                    context: context, 
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  ).then((value){
                                    if(value != null){
                                      setState(() {
                                        wednesdayClose = value.format(context);
                                      });
                                    }
                                  });
                                },
                                Text(wednesdayClose)
                                ),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("Thursday")),
                              DataCell(
                                onTap:(){
                                  showTimePicker(
                                    context: context, 
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  ).then((value){
                                    if(value != null){
                                      setState(() {
                                        thursdayOpen = value.format(context);
                                      });
                                    }
                                  });
                                },
                                Text(thursdayOpen)
                                ),
                              DataCell(
                                onTap:(){
                                  showTimePicker(
                                    context: context, 
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  ).then((value){
                                    if(value != null){
                                      setState(() {
                                        thursdayClose = value.format(context);
                                      });
                                    }
                                  });
                                },
                                Text(thursdayClose)
                                ),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("Friday")),
                              DataCell(
                                onTap:(){
                                  showTimePicker(
                                    context: context, 
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  ).then((value){
                                    if(value != null){
                                      setState(() {
                                        fridayOpen = value.format(context);
                                      });
                                    }
                                  });
                                },
                                Text(fridayOpen)
                                ),
                              DataCell(
                                onTap:(){
                                  showTimePicker(
                                    context: context, 
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  ).then((value){
                                    if(value != null){
                                      setState(() {
                                        fridayClose = value.format(context);
                                      });
                                    }
                                  });
                                },
                                Text(fridayClose)
                                ),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("Saturday")),
                              DataCell(
                                onTap:(){
                                  showTimePicker(
                                    context: context, 
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  ).then((value){
                                    if(value != null){
                                      setState(() {
                                        saturdayOpen = value.format(context);
                                      });
                                    }
                                  });
                                },
                                Text(saturdayOpen)
                                ),
                              DataCell(
                                onTap:(){
                                  showTimePicker(
                                    context: context, 
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  ).then((value){
                                    if(value != null){
                                      setState(() {
                                        saturdayClose = value.format(context);
                                      });
                                    }
                                  });
                                },
                                Text(saturdayClose)
                                ),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text("Sunday")),
                              DataCell(
                                onTap:(){
                                  showTimePicker(
                                    context: context, 
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  ).then((value){
                                    if(value != null){
                                      setState(() {
                                        sundayOpen = value.format(context);
                                      });
                                    }
                                  });
                                },
                                Text(sundayOpen)
                                ),
                              DataCell(
                                onTap:(){
                                  showTimePicker(
                                    context: context, 
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                  ).then((value){
                                    if(value != null){
                                      setState(() {
                                        sundayClose = value.format(context);
                                      });
                                    }
                                  });
                                },
                                Text(sundayClose)
                                ),
                            ]),
                          ],
                        ),

                      const SizedBox(height: 20.0),

                      ElevatedButton(
                        onPressed: () async {

                          if(_addressController.text.isEmpty || _bioController.text.isEmpty || _phoneController.text.length < 12){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill out all fields"),
                              )
                            );
                            return;
                          }

                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(user!.email)
                              .update({
                                "address": _addressController.text,
                                "about": _bioController.text,
                                "phone": _phoneController.text,
                                "businessHours": {
                                  "Monday": "$mondayOpen - $mondayClose",
                                  "Tuesday": "$tuesdayOpen - $tuesdayClose",
                                  "Wednesday": "$wednesdayOpen - $wednesdayClose",
                                  "Thursday": "$thursdayOpen - $thursdayClose",
                                  "Friday": "$fridayOpen - $fridayClose",
                                  "Saturday": "$saturdayOpen - $saturdayClose",
                                  "Sunday": "$sundayOpen - $sundayClose",
                                }
                              });
                          Navigator.pop(context);
                        },
                        child: const Text("Save Changes"),
                      ),

                    ],
                  ),
                )
              )
            );
          }
          else{
            return const Center(
              child: Text("Error loading data"),
            );
          }
        },
      ),
    );
  }
}
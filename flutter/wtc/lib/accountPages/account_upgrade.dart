import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:intl_phone_number_input/intl_phone_number_input.dart";


class AccountUpgradePage extends StatefulWidget {
  const AccountUpgradePage({
    super.key, 
    required this.tier, 
    required this.name, 
    required this.email,
    required this.uid
  });

  final String tier;
  final String name;
  final String email;
  final String uid;

  @override
  State<AccountUpgradePage> createState() => _AccountUpgradePageState();
}

class _AccountUpgradePageState extends State<AccountUpgradePage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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

  bool isBusiness = false;

  Future<void> submitApplication(String email, bool isBusiness) async {

    // Get the values from the text fields
    String name = _nameController.text.trim();
    String about = _bioController.text.trim();
    String address = _addressController.text.trim();
    String phone = _phoneController.text.trim();

    // Create a map of the business hours
    Map<String, String> businessHours = {
      "Monday": "$mondayOpen - $mondayClose",
      "Tuesday": "$tuesdayOpen - $tuesdayClose",
      "Wednesday": "$wednesdayOpen - $wednesdayClose",
      "Thursday": "$thursdayOpen - $thursdayClose",
      "Friday": "$fridayOpen - $fridayClose",
      "Saturday": "$saturdayOpen - $saturdayClose",
      "Sunday": "$sundayOpen - $sundayClose",
    };

    // Upload to database
    await FirebaseFirestore.instance
      .collection("_review_account")
      .doc(widget.uid)
      .set({
        "name": name,
        "about": about,
        "phone": phone,
        "isBusiness": isBusiness,
        "address": address,
        "businessHours": businessHours,
        "email": email,
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    bool isPoster = widget.tier == "Poster";
    if(isPoster){ 
      isBusiness = true;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upgrade Account Application",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: const Color(0xFF469AB8),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // isBusiness button
            if(!isPoster)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Are you a business?",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.start,
                ),
                Switch(
                  activeColor: Colors.grey[600],
                  value: isBusiness,
                  onChanged: (value) {
                    setState(() {
                      isBusiness = value;
                    });
                  },
                ),
              ],
            ),

            if(!isPoster)
            const SizedBox(height: 10),

            if (isBusiness) 
              Column(
                children: [
                  // Business Name
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Business Name",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Business Description
                  TextField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: "Business Description",
                      hintText: "What does your business do?"
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Business Address
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: "Business Address",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Business Number
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      _phoneController.text = number.phoneNumber!;
                    },
                    inputDecoration: const InputDecoration(
                      
                    ),
                    maxLength: 12,
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    countries: const ["US"],
                  ),

                  const SizedBox(height: 20),

                  // Business Hours
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\tBusiness Hours",
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

                  const SizedBox(height: 30),
                ],
              ),

            if(!isBusiness)
              Column(
                children: [
                  // Name
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bio
                  TextField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: "About yourself",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Phone Number
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      _phoneController.text = number.phoneNumber!;
                    },
                    maxLength: 12,
                    inputDecoration: const InputDecoration(
                      labelText: "Phone Number",
                      helperText: "If we need to contact you"
                    ),
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    countries: const ["US"],
                  ),
                  

                  const SizedBox(height: 30),
                ],
              ),

            // Upgrade Button
            ElevatedButton(
              onPressed: () async{
                if(_bioController.text.isEmpty || _nameController.text.isEmpty || _phoneController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill out all fields"),
                    ),
                  );
                }
                else if(isBusiness && _addressController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill out all fields"),
                    ),
                  );
                }
                else{
                  await submitApplication(widget.email, isBusiness);           
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Application submitted successfully"),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Submit"),
            ),
          ]
        ),
      ),
      
    );
  }
}
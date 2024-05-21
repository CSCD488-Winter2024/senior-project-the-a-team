import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:wtc/components/hour_input.dart';

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
  final TextEditingController _cityController = TextEditingController();

  final TextEditingController _mondayOpenController = TextEditingController();
  final TextEditingController _mondayCloseController = TextEditingController();
  final TextEditingController _tuesdayOpenController = TextEditingController();
  final TextEditingController _tuesdayCloseController = TextEditingController();
  final TextEditingController _wednesdayOpenController = TextEditingController();
  final TextEditingController _wednesdayCloseController = TextEditingController();
  final TextEditingController _thursdayOpenController = TextEditingController();
  final TextEditingController _thursdayCloseController = TextEditingController();
  final TextEditingController _fridayOpenController = TextEditingController();
  final TextEditingController _fridayCloseController = TextEditingController();
  final TextEditingController _saturdayOpenController = TextEditingController();
  final TextEditingController _saturdayCloseController = TextEditingController();
  final TextEditingController _sundayOpenController = TextEditingController();
  final TextEditingController _sundayCloseController = TextEditingController();
  


  @override
  void dispose() {
    _bioController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _mondayOpenController.dispose();
    _mondayCloseController.dispose();
    _tuesdayOpenController.dispose();
    _tuesdayCloseController.dispose();
    _wednesdayOpenController.dispose();
    _wednesdayCloseController.dispose();
    _thursdayOpenController.dispose();
    _thursdayCloseController.dispose();
    _fridayOpenController.dispose();
    _fridayCloseController.dispose();
    _saturdayOpenController.dispose();
    _saturdayCloseController.dispose();
    _sundayOpenController.dispose();
    _sundayCloseController.dispose();
    super.dispose();
  }

  Future<void> submitApplication(String oldAddress, String newAddress, String name) async {
    await FirebaseFirestore.instance
      .collection("_review_account")
      .doc(user!.uid)
      .set({
        "email": user!.email,
        "name": name,
        "about": "Old Address: $oldAddress",
        "phone": _phoneController.text,
        "isBusiness": true,
        "businessHours": {
          "Monday": "${_mondayOpenController.text.trim()} - ${_mondayCloseController.text.trim()}",
          "Tuesday": "${_tuesdayOpenController.text.trim()} - ${_tuesdayCloseController.text.trim()}",
          "Wednesday": "${_wednesdayOpenController.text.trim()} - ${_wednesdayCloseController.text.trim()}",
          "Thursday": "${_thursdayOpenController.text.trim()} - ${_thursdayCloseController.text.trim()}",
          "Friday": "${_fridayOpenController.text.trim()} - ${_fridayCloseController.text.trim()}",
          "Saturday": "${_saturdayOpenController.text.trim()} - ${_saturdayCloseController.text.trim()}",
          "Sunday": "${_sundayOpenController.text.trim()} - ${_sundayCloseController.text.trim()}",
        }, 
        "address": newAddress,

      }
    );

    await FirebaseFirestore.instance
      .collection("users")
      .doc(user!.email)
      .update({
        "isPending": true,
      }
    );
  }


  @override
  Widget build(BuildContext context) {

    _cityController.text = "Cheney, WA";
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

            _addressController.text = data["address"].split(", Cheney, WA")[0];
            String address = data["address"].split(", Cheney, WA")[0];
            _bioController.text = data["about"];

            PhoneNumber number = PhoneNumber(isoCode: "US", phoneNumber: data["phone"]);

            String monday = data["businessHours"]["Monday"];
            String tuesday = data["businessHours"]["Tuesday"];
            String wednesday = data["businessHours"]["Wednesday"];
            String thursday = data["businessHours"]["Thursday"];
            String friday = data["businessHours"]["Friday"];
            String saturday = data["businessHours"]["Saturday"];
            String sunday = data["businessHours"]["Sunday"];

            String name = data["name"];

            if(monday.length > 3){
              _mondayOpenController.text = monday.split(" - ")[0];
              _mondayCloseController.text = monday.split(" - ")[1];
            }
            if(tuesday.length > 3){
              _tuesdayOpenController.text = tuesday.split(" - ")[0];
              _tuesdayCloseController.text = tuesday.split(" - ")[1];
            }
            if(wednesday.length > 3){
              _wednesdayOpenController.text = wednesday.split(" - ")[0];
              _wednesdayCloseController.text = wednesday.split(" - ")[1];
            }
            if(thursday.length > 3){
              _thursdayOpenController.text = thursday.split(" - ")[0];
              _thursdayCloseController.text = thursday.split(" - ")[1];
            }
            if(friday.length > 3){
              _fridayOpenController.text = friday.split(" - ")[0];
              _fridayCloseController.text = friday.split(" - ")[1];
            }
            if(saturday.length > 3){
              _saturdayOpenController.text = saturday.split(" - ")[0];
              _saturdayCloseController.text = saturday.split(" - ")[1];
            }
            if(sunday.length > 3){
              _sundayOpenController.text = sunday.split(" - ")[0];
              _sundayCloseController.text = sunday.split(" - ")[1];
            }

            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Edit Business Address

                     Row(
                       children: [
                         Expanded(
                           child: TextField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                hintText: "Change Business Address",
                                labelText: "Business Address",
                                helperText: "Must be approved by admin"
                              ),
                            ),
                         ),

                         SizedBox(
                          width: 90,
                          child: TextField(
                            controller: _cityController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: "",
                              helperText: ""
                            ),
                          ),
                         )
                       ],
                     ),
                   

                      const SizedBox(height: 15.0),

                      // Edit Business Bio

                      TextField(
                        controller: _bioController,
                        decoration: const InputDecoration(
                          hintText: "Change Business Bio",
                          labelText: "Business Bio",
                        ),
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

                      HourInput(day: "Monday", openHour: _mondayOpenController, closeHour: _mondayCloseController),

                      const Divider(),
                      const SizedBox(height: 10),
                      
                      HourInput(day: "Tuesday", openHour: _tuesdayOpenController, closeHour: _tuesdayCloseController),
                      
                      const Divider(),
                      const SizedBox(height: 10),
                      
                      HourInput(day: "Wednesday", openHour: _wednesdayOpenController, closeHour: _wednesdayCloseController),
                      
                      const Divider(),
                      const SizedBox(height: 10),
                      
                      HourInput(day: "Thursday", openHour: _thursdayOpenController, closeHour: _thursdayCloseController),
                      
                      const Divider(),
                      const SizedBox(height: 10),
                      
                      HourInput(day: "Friday", openHour: _fridayOpenController, closeHour: _fridayCloseController),
                      
                      const Divider(),
                      const SizedBox(height: 10),
                      
                      HourInput(day: "Saturday", openHour: _saturdayOpenController, closeHour: _saturdayCloseController),
                      
                      const Divider(),
                      const SizedBox(height: 10),
                      
                      HourInput(day: "Sunday", openHour: _sundayOpenController, closeHour: _sundayCloseController),
                  
                      const Divider(),
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
                          else if(address != _addressController.text){
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Address Change"),
                                content: const Text("Changing your address will require admin approval. Are you sure you want to change your address?"),
                                actions: [
                                  TextButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                      return;
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: ()async{                                      
                                      await submitApplication(address, _addressController.text, name);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Address change submitted for approval"),
                                        )
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Confirm"),
                                  )
                                ],
                              )
                            );
                          }
                      
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(user!.email)
                              .update({
                                "about": _bioController.text,
                                "phone": _phoneController.text,
                                "businessHours": {
                                  "Monday": "${_mondayOpenController.text.trim()} - ${_mondayCloseController.text.trim()}",
                                  "Tuesday": "${_tuesdayOpenController.text.trim()} - ${_tuesdayCloseController.text.trim()}",
                                  "Wednesday": "${_wednesdayOpenController.text.trim()} - ${_wednesdayCloseController.text.trim()}",
                                  "Thursday": "${_thursdayOpenController.text.trim()} - ${_thursdayCloseController.text.trim()}",
                                  "Friday": "${_fridayOpenController.text.trim()} - ${_fridayCloseController.text.trim()}",
                                  "Saturday": "${_saturdayOpenController.text.trim()} - ${_saturdayCloseController.text.trim()}",
                                  "Sunday": "${_sundayOpenController.text.trim()} - ${_sundayCloseController.text.trim()}",
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
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:intl_phone_number_input/intl_phone_number_input.dart";
import "package:wtc/components/hour_input.dart";


class AccountUpgradePage extends StatefulWidget {
  const AccountUpgradePage({
    super.key, 
    required this.tier, 
    required this.name, 
    required this.email,
    required this.uid,
    required this.pfp,
  });

  final String tier;
  final String name;
  final String email;
  final String uid;
  final String pfp;

  @override
  State<AccountUpgradePage> createState() => _AccountUpgradePageState();
}

class _AccountUpgradePageState extends State<AccountUpgradePage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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

  bool isBusiness = false;

  Future<void> submitApplication(String email, bool isBusiness) async {

    // Get the values from the text fields
    String name = _nameController.text.trim();
    String about = _bioController.text.trim();
    String address = _addressController.text.trim();
    String phone = _phoneController.text.trim();

    // Create a map of the business hours
    Map<String, String> businessHours = {
      "Monday": "${_mondayOpenController.text.trim()} - ${_mondayCloseController.text.trim()}",
      "Tuesday": "${_tuesdayOpenController.text.trim()} - ${_tuesdayCloseController.text.trim()}",
      "Wednesday": "${_wednesdayOpenController.text.trim()} - ${_wednesdayCloseController.text.trim()}",
      "Thursday": "${_thursdayOpenController.text.trim()} - ${_thursdayCloseController.text.trim()}",
      "Friday": "${_fridayOpenController.text.trim()} - ${_fridayCloseController.text.trim()}",
      "Saturday": "${_saturdayOpenController.text.trim()} - ${_saturdayCloseController.text.trim()}",
      "Sunday": "${_sundayOpenController.text.trim()} - ${_sundayCloseController.text.trim()}",
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
        "address": "$address, Cheney, WA",
        "businessHours": businessHours,
        "email": email,
        "pfp": widget.pfp,
      }
    );

    await FirebaseFirestore.instance
      .collection("users")
      .doc(widget.uid)
      .update({
        "isPending": true,
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    _cityController.text = "Cheney, WA";

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: "Business Address",
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          //enabled: false,
                          readOnly: true,
                          controller: _cityController,
                          decoration: const InputDecoration(
                            labelText: "",
                          ),
                        )
                      ),
                      
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Business Number
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      _phoneController.text = number.phoneNumber!;
                    },
                    inputDecoration: const InputDecoration(
                      labelText: "Business Number",
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
                        "Business Hours",
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
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        title: Text('Submitting Application...'),
                        content: LinearProgressIndicator(),
                      );
                    }
                  );
                  await submitApplication(widget.email, isBusiness);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Application submitted successfully"),
                    ),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
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
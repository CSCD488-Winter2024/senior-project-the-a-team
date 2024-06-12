import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtc/pages/nav_bar/account_pages/account_upgrade.dart';
import 'package:wtc/pages/nav_bar/account_pages/edit_business.dart';
import 'package:wtc/pages/nav_bar/account_pages/edit_profile.dart';
import 'package:wtc/pages/nav_bar/account_pages/edit_tags.dart';
import 'package:wtc/widgets/auth/delete_account.dart';
import 'package:wtc/pages/authentication/link_accounts.dart';
import 'package:wtc/widgets/components/settings_button.dart';

class EditSettings extends StatefulWidget {
  const EditSettings({
    super.key,
    required this.tier,
    required this.email,
    required this.tags,
    required this.isBusiness,
    required this.username,
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.isPending,
  });

  final String tier;
  final String email;
  final List<String> tags;
  final bool isBusiness;
  final String username;
  final String name;
  final CachedNetworkImage? profilePic;
  final String uid;
  final bool isPending;

  @override
  State<EditSettings> createState() => _EditSettingsState();
}

class _EditSettingsState extends State<EditSettings> {
  final TextEditingController passwordController = TextEditingController();

  final provider = FirebaseAuth.instance.currentUser?.providerData.first;

  bool tour = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  String errorPassword = "";

  @override
  Widget build(BuildContext context) {
    List<String> origTags = List.from(widget.tags);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFBD9F4C),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                EditButton(
                  route: EditProfile(
                    uid: widget.uid,
                    name: widget.name,
                    username: widget.username,
                    profilePic: widget.profilePic,
                    isBusiness: widget.isBusiness,
                  ),
                  icon: const Icon(Icons.person),
                  text: "Edit Profile",
                ),
                const SizedBox(height: 20),
                EditButton(
                  route: EditTags(
                    tags: widget.tags,
                    origTags: origTags,
                  ),
                  icon: const Icon(Icons.miscellaneous_services),
                  text: "Edit Tags",
                ),
                const SizedBox(height: 20),
                const LinkAccounts(),
                const SizedBox(height: 20),
                if (widget.isBusiness)
                  const EditButton(
                    route: EditBusinessInfo(),
                    icon: Icon(Icons.business_center),
                    text: "Edit Business Information",
                  ),
                if (!widget.isBusiness &&
                    widget.tier == "Viewer" &&
                    !widget.isPending)
                  EditButton(
                    route: AccountUpgradePage(
                      tier: widget.tier,
                      name: widget.name,
                      email: widget.email,
                      uid: widget.uid,
                      pfp: widget.profilePic?.imageUrl ?? "",
                    ),
                    icon: const Icon(Icons.pending_actions),
                    text: "Apply to become a poster",
                  ),
                if (widget.tier == "Poster" &&
                    !widget.isBusiness &&
                    !widget.isPending)
                  EditButton(
                    route: AccountUpgradePage(
                      tier: widget.tier,
                      name: widget.name,
                      email: widget.email,
                      uid: widget.uid,
                      pfp: widget.profilePic?.imageUrl ?? "",
                    ),
                    icon: const Icon(Icons.pending_actions),
                    text: "Apply to become a Business",
                  ),
                if (widget.isBusiness && widget.isPending)
                  const SizedBox(height: 20),
                if (widget.isPending)
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Your application is pending"),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFBD9F4C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 80,
                      child: const Center(
                        child: ListTile(
                          leading: Icon(Icons.pending_actions),
                          title: Text(
                            "Application Pending",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  ),
                if (widget.tier == "Poster" || widget.tier == "Viewer")
                  const SizedBox(height: 20),
                DeleteAccount(
                  email: widget.email,
                  tags: widget.tags,
                  uid: widget.uid,
                  provider: provider,
                  passwordController: passwordController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

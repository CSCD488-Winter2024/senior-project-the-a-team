 import 'package:flutter/material.dart';
 
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
    @override
    Widget build(BuildContext context) {
       final ThemeData theme = Theme.of(context);
        return Card(
            shadowColor: Colors.transparent,
            margin: const EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: Center(
                child: Text(
                  'Account Page',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
          );

    }

}
 
 
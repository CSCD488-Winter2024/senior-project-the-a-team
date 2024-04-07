import 'package:flutter/material.dart';
import 'widgets/navbutton.dart';
import 'pages/home.dart';
import 'pages/accountsettings.dart';
import 'pages/alerts.dart';
import 'pages/calendar.dart';
import 'pages/map.dart';
import 'widgets/topbar.dart';

//-- Please read all comments before proceeding!
//****This NavBar should never be touched unless something about it specifically is being addressed**
//  All app functionality will be handled in the pages files!
//  The job of this nav bar is to route us to a given set of pages!
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _NavBars();
}

class _NavBars extends State<App> {
  /*
    setting currentPageIndex here will indicate the starting position for 
    our nav bar

    we want the user to be routed to page 2 [index 2] which is 
    the current location of the home page
  */
  int currentPageIndex = 2;

  Drawer getDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text('Menu', style: TextStyle(color: Colors.white)),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              setState(() {
                currentPageIndex = 2;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.warning),
            title: const Text('Alerts'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              setState(() {
                currentPageIndex = 0;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Jobs'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.volunteer_activism),
            title: const Text('Volunteer'),
            onTap: () {
              // Navigate to Volunteer page
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Account'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              setState(() {
                currentPageIndex = 4;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.create),
            title: const Text('Create Post'),
            onTap: () {
              // Navigate to Create Post page
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(preferredHeight: 70.0),
      drawer: getDrawer(context),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.white,
        backgroundColor: Colors.red,
        selectedIndex: currentPageIndex,
        //beginning of bottom bar
        destinations: const <Widget>[
          /** -- NOTES PLEASE READ BEFORE PROCEEDING
           * 'destinations' contains widgets -- or, in this case, the buttons 
           * for our navbar
           * 
           * I made a custom Navigation Button widget for easy reuse 
           * params order will be label [requires a string], an icon image for when selected [requires an IconData object]
           * and an icon image for when not selected [requires an IconData object type]
           * 
           * -- you can see examples below
           * 
           * **NOTE: The order of buttons will matter!**
           * The beginning of this list will indicate the left most position on the nav bar
           * The end of this list will indicate the right most position on the nav bar
           * 
           * -- Please do not mess with the order unless it was decided so
           * 
           * To add another button (or remove) place comma at last widget in list followed by NavButton widget
           * (to remove, simply remove a nav button from the list - but remember order matters!)
           */
          //Alerts Page Button
          NavButton(
              label: "Alerts",
              icon: Icons.crisis_alert,
              outlinedIcon: Icons.crisis_alert_outlined),
          //Map Page Button
          NavButton(
              label: "Map", icon: Icons.map, outlinedIcon: Icons.map_outlined),
          //Home Page Button
          NavButton(
              label: "Home", icon: Icons.home, outlinedIcon: Icons.home_filled),
          //Calendar Page Button
          NavButton(
              label: "Calendar",
              icon: Icons.calendar_month,
              outlinedIcon: Icons.calendar_month_outlined),
          //Account Page Button
          NavButton(
              label: "Account",
              icon: Icons.manage_accounts,
              outlinedIcon: Icons.manage_accounts_outlined)
        ],
      ),
      body: <Widget>[
        /**
         *  -- just like the previous list, order matters!
         *  -- the order of the pages here will need to line up with the nav buttons above
         *  in terms of order!
         * 
         *  -- this is how we will route our pages for the nav bar
         *  -- to edit a page, please go to the respective dart file! 
         * The page may need to be completely changed - a page is current only formatted for the piece of 
         * text that is displayed
         * 
         * -- you can add a page by placing a comma at the bottom of this list followed by a constant widget which will be a page widget (import to nav bar to add more)
         * -- right now, pages will be unique widgets since they require very different configurations
         */
        const AlertsPage(),
        const MapPage(),
        const HomePage(),
        const CalendarPage(),
        const AccountPage()
      ][currentPageIndex],
    );
  }
}

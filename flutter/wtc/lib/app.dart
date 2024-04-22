import 'package:flutter/material.dart';
import 'widgets/navbutton.dart';
import 'pages/home.dart';
import 'pages/accountsettings.dart';
import 'pages/alerts.dart';
import 'pages/calendar.dart';
import 'pages/map.dart';
import 'widgets/topbar.dart';
import 'pages/create_post.dart';
import 'pages/create_post_event.dart';
import 'pages/create_post_job.dart';
import 'pages/jobs.dart';
import 'pages/volunteering.dart';
import 'widgets/notifications_window.dart';

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
  bool showNotification = false;
  void showCreatePostOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Create Post"),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Use min size for the content
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center content horizontally
            children: <Widget>[
              ElevatedButton(
                child: const Text("Normal Post"),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreatePostPage()),
                  );
                },
              ),
              ElevatedButton(
                child: const Text("Event Post"),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreatePostEventPage()),
                  );
                },
              ),
              ElevatedButton(
                child: const Text("Job Post"),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreatePostJobPage()),
                  );
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Drawer getDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text('', style: TextStyle(color: Colors.white)),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/WTC_BLANK.png'), fit: BoxFit.cover),
              color: Color(0xFF469AB8),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const JobsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.volunteer_activism),
            title: const Text('Volunteer'),
            onTap: () {
              // Navigate to Volunteer page
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VolunteerPage()));
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
              Navigator.pop(context); // Close the drawer
              showCreatePostOptions(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        preferredHeight: 70.0,
        onNotificationsPressed: () {
          setState(() => showNotification = !showNotification);

          print(showNotification);
        },
        showNotifications: showNotification,
      ),
      drawer: getDrawer(context),
      body: Stack(
        children: [
          // Main content of your app
          getPageContent(currentPageIndex),
          // Notification window (conditional rendering)
          if (showNotification)
            const Opacity(
                opacity: 0.5, child: ModalBarrier(color: Colors.black)),

          if (showNotification) NotificationsWindow()
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.white,
        backgroundColor: const Color(0xFF469AB8),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavButton(
              label: "Alerts",
              icon: Icons.crisis_alert,
              outlinedIcon: Icons.crisis_alert_outlined),
          NavButton(
              label: "Map", icon: Icons.map, outlinedIcon: Icons.map_outlined),
          NavButton(
              label: "Home", icon: Icons.home, outlinedIcon: Icons.home_filled),
          NavButton(
              label: "Calendar",
              icon: Icons.calendar_month,
              outlinedIcon: Icons.calendar_month_outlined),
          NavButton(
              label: "Account",
              icon: Icons.manage_accounts,
              outlinedIcon: Icons.manage_accounts_outlined),
        ],
      ),
    );
  }

  Widget getPageContent(int index) {
    switch (index) {
      case 0:
        return AlertsPage();
      case 1:
        return MapPage();
      case 2:
        return HomePage();
      case 3:
        return CalendarPage();
      case 4:
        return AccountPage();
      case 5:
        return JobsPage();
      case 6:
        return VolunteerPage();
      default:
        return Container(); // Default empty container
    }
  }
}

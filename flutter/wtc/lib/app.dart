import 'package:flutter/material.dart';
import 'widgets/navbutton.dart';
import 'User/user_service.dart';
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
import 'pages/specific_fillable_form.dart';
import 'pages/admin_review.dart';
import 'pages/about_us.dart';

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
  bool showJobsPage = false;
  bool showVolunteerPage = false;
  bool showApprovePostsPage = false;
  bool showAboutUsPage = false;
  String title = "Welcome To Cheney";
  String prevTitle = "";
  String userTier = "";

  @override
  void initState() {
    super.initState();
    _initUserTier();
  }

  void _initUserTier() async {
    String tier = await UserService().fetchUserTier(); // Await the Future
    setState(() {
      userTier = tier; // Assign the result within setState to trigger a rebuild
    });
  }

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
              color: Color(0xFF469AB8),
              image: DecorationImage(
                  image: AssetImage('images/WTC_BLANK.png'), fit: BoxFit.cover),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              setState(() {
                title = "Welcome to Cheney";
                prevTitle = "Welcome to Cheney";
                currentPageIndex = 2;
                showJobsPage = false;
                showVolunteerPage = false;
                showNotification = false;
                showApprovePostsPage = false;
                showAboutUsPage = false;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.warning),
            title: const Text('Alerts'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              setState(() {
                title = "Alerts";
                prevTitle = "Alerts";
                currentPageIndex = 0;
                showJobsPage = false;
                showVolunteerPage = false;
                showNotification = false;
                showApprovePostsPage = false;
                showAboutUsPage = false;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Jobs'),
            onTap: () {
              Navigator.pop(context);
              /*Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const JobsPage()));*/
              setState(() {
                title = "Jobs";
                prevTitle = "Jobs";
                showJobsPage = !showJobsPage;
                showVolunteerPage = false;
                showNotification = false;
                showApprovePostsPage = false;
                showAboutUsPage = false;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.volunteer_activism),
            title: const Text('Volunteer'),
            onTap: () {
              // Navigate to Volunteer page
              Navigator.pop(context);
              setState(() {
                title = "Volunteer";
                prevTitle = "Volunteer";
                showJobsPage = false;
                showNotification = false;
                showVolunteerPage = !showVolunteerPage;
                showApprovePostsPage = false;
                showAboutUsPage = false;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Account'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              setState(() {
                title = "Account Settings";
                prevTitle = "Account Settings";

                currentPageIndex = 4;
                showJobsPage = false;
                showVolunteerPage = false;
                showNotification = false;
                showApprovePostsPage = false;
                showAboutUsPage = false;
              });
            },
          ),
          (userTier == "Admin" || userTier == "Poster")
              ? ListTile(
                  leading: const Icon(Icons.create),
                  title: const Text('Create Post'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    showCreatePostOptions(context);
                    setState(() {
                      showJobsPage = false;
                      showVolunteerPage = false;
                      showNotification = false;
                      showApprovePostsPage = false;
                      showAboutUsPage = false;
                    });
                  },
                )
              : ListTile(
                  leading: const Icon(Icons.create),
                  title: const Text('Post for Admin Review'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SpecificFillableFormPage()),
                    );
                  },
                ),
          if (userTier == "Admin")
            ListTile(
              leading: const Icon(Icons.add_moderator),
              title: const Text('Approve Posts'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  title = "Approve Posts";
                  prevTitle = "Approve Posts";
                  showApprovePostsPage = !showApprovePostsPage;
                  showVolunteerPage = false;
                  showNotification = false;
                  showJobsPage = false;
                });
              },
            ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('About Us'),
            onTap: () {
              // Navigate to Volunteer page
              Navigator.pop(context);
              setState(() {
                title = "About Us";
                prevTitle = "About Us";
                showAboutUsPage = !showAboutUsPage;
                showJobsPage = false;
                showNotification = false;
                showVolunteerPage = false;
                showApprovePostsPage = false;
              });
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
        title: title,
        preferredHeight: 70.0,
        onNotificationsPressed: () {
          setState(() => showNotification = !showNotification);
          setState(() {
            if (showNotification == false) {
              title = prevTitle;
            } else {
              title = "Notifications";
            }

            showJobsPage = false;
            showVolunteerPage = false;
          });
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

          if (showNotification) const NotificationsWindow(),
          if (showJobsPage) const JobsPage(),
          if (showVolunteerPage) const VolunteerPage(),
          if (showApprovePostsPage) const AdminReviewPage(),
          if (showAboutUsPage) const AboutUsPage()
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            title = setTitle(index);
            prevTitle = setTitle(index);
          });

          setState(() {
            showJobsPage = false;
            showVolunteerPage = false;
            showNotification = false;
            showApprovePostsPage = false;
            showAboutUsPage = false;
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
              label: "Maps", icon: Icons.map, outlinedIcon: Icons.map_outlined),
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

  String setTitle(int index) {
    switch (index) {
      case 0:
        return "Alerts";
      case 1:
        return "Maps";
      case 2:
        return "Welcome to Cheney";
      case 3:
        return "Calendar";
      case 4:
        return "Account Settings";
      case 5:
        return "Approve Posts";
      case 6:
        return "About us";
      default:
        return "Welcome to Cheney";
    }
  }

  Widget getPageContent(int index) {
    switch (index) {
      case 0:
        return const AlertsPage();
      case 1:
        return const MapPage();
      case 2:
        return const HomePage();
      case 3:
        return const CalendarPage();
      case 4:
        return const AccountPage();

      default:
        return Container(); // Default empty container
    }
  }
}

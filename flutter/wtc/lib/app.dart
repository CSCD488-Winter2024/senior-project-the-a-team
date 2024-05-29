import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wtc/pages/saved_posts_page.dart';
import 'package:wtc/pages/search_user.dart';
import 'package:wtc/pages/account_review.dart';
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
import 'pages/create_post_alert.dart';
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
  bool showSearchUsers = false;
  bool showAccountUpgradePage = false;
  bool showSavedPosts = false;
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
                child: const Text("Alert Post"),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreatePostAlertPage()),
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
                showSearchUsers = false;
                showAccountUpgradePage = false;
                showSavedPosts = false;
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
                showSearchUsers = false;
                showAccountUpgradePage = false;
                showSavedPosts = false;
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
                showJobsPage = true;
                showVolunteerPage = false;
                showNotification = false;
                showApprovePostsPage = false;
                showAboutUsPage = false;
                showSearchUsers = false;
                showAccountUpgradePage = false;
                showSavedPosts = false;
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
                showVolunteerPage = true;
                showApprovePostsPage = false;
                showAboutUsPage = false;
                showSearchUsers = false;
                showAccountUpgradePage = false;
                showSavedPosts = false;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Account'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              setState(() {
                title = "Account";
                prevTitle = "Account";

                currentPageIndex = 4;
                showJobsPage = false;
                showVolunteerPage = false;
                showNotification = false;
                showApprovePostsPage = false;
                showAboutUsPage = false;
                showSearchUsers = false;
                showAccountUpgradePage = false;
                showSavedPosts = false;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Saved Posts'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              setState(() {
                title = "Saved Posts";
                prevTitle = "Saved Posts";

                showSavedPosts = true;
                showJobsPage = false;
                showVolunteerPage = false;
                showNotification = false;
                showApprovePostsPage = false;
                showAboutUsPage = false;
                showSearchUsers = false;
                showAccountUpgradePage = false;
                
              });
            }
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
                      showSearchUsers = false;
                      showAccountUpgradePage = false;
                      showSavedPosts = false;
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
                  showApprovePostsPage = true;
                  showVolunteerPage = false;
                  showNotification = false;
                  showJobsPage = false;
                  showAboutUsPage = false;
                  showSearchUsers = false;
                  showAccountUpgradePage = false;
                  showSavedPosts = false;
                });
              },
            ),
          if (userTier == "Admin")
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Users'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  title = "Search Users";
                  prevTitle = "Search Users";
                  showApprovePostsPage = false;
                  showVolunteerPage = false;
                  showNotification = false;
                  showJobsPage = false;
                  showAboutUsPage = false;
                  showSearchUsers = true;
                  showAccountUpgradePage = false;
                  showSavedPosts = false;
                });
              },
            ),
          if (userTier == "Admin")
            ListTile(
              leading: const Icon(Icons.people_sharp),
              title: const Text('Upgrade Accounts'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  title = "Upgrade Accounts";
                  prevTitle = "Upgrade Accounts";
                  showAccountUpgradePage = true;
                  showApprovePostsPage = false;
                  showVolunteerPage = false;
                  showNotification = false;
                  showJobsPage = false;
                  showAboutUsPage = false;
                  showSavedPosts = false;
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
                showAboutUsPage = true;
                showJobsPage = false;
                showNotification = false;
                showVolunteerPage = false;
                showApprovePostsPage = false;
                showSearchUsers = false;
                showAccountUpgradePage = false;
                showSavedPosts = false;
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
          if (showNotification || showJobsPage 
          || showVolunteerPage || showApprovePostsPage 
          || showAboutUsPage || showSearchUsers 
          || showAccountUpgradePage || showSavedPosts)
            const Opacity(
                opacity: 1, child: ModalBarrier(color: Colors.white)),

          if (showNotification) const NotificationsWindow(),
          if (showJobsPage) const JobsPage(),
          if (showVolunteerPage) const VolunteerPage(),
          if (showApprovePostsPage) const AdminReviewPage(),
          if (showAboutUsPage) const AboutUsPage(),
          if (showSearchUsers) const SearchUserPage(),
          if (showAccountUpgradePage) const AccountReviewPage(),
          if (showSavedPosts) const SavedPosts()
        ],
      ),
      bottomNavigationBar: GNav(
        onTabChange: (int index) {
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
            showSearchUsers = false;
            showAccountUpgradePage = false;
            showSavedPosts = false;
          });
        },
        activeColor: Colors.white,
        color: Colors.black,
        backgroundColor: const Color(0xFF469AB8),
        selectedIndex: currentPageIndex,
        tabs: const[
          GButton(
              icon: Icons.crisis_alert,
          ),
          GButton(
              icon: Icons.map),
          GButton(
              icon: Icons.home,),
          GButton(
              icon: Icons.calendar_month,),
          GButton(
              icon: Icons.manage_accounts,)
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
        return "Account";
      case 5:
        return "Approve Posts";
      case 6:
        return "Search Users";
      case 7:
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

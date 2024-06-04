import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wtc/pages/my_posts.dart';
import 'package:wtc/pages/saved_posts_page.dart';
import 'package:wtc/pages/search_user.dart';
import 'package:wtc/pages/account_review.dart';
import 'package:wtc/widgets/navbutton.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey key1 = GlobalKey();
  final GlobalKey key2 = GlobalKey();
  final GlobalKey key3 = GlobalKey();
  final GlobalKey key4 = GlobalKey();
  final GlobalKey key5 = GlobalKey();
  final GlobalKey key6 = GlobalKey();
  final GlobalKey key7 = GlobalKey();
  final GlobalKey key8 = GlobalKey();
  final GlobalKey key9 = GlobalKey();
  final GlobalKey key10 = GlobalKey();
  final GlobalKey key11 = GlobalKey();
  final GlobalKey key12 = GlobalKey();
  
  int currentPageIndex = 2;
  bool showNotification = false;
  bool showJobsPage = false;
  bool showVolunteerPage = false;
  bool showApprovePostsPage = false;
  bool showAboutUsPage = false;
  bool showSearchUsers = false;
  bool showAccountUpgradePage = false;
  bool showSavedPosts = false;
  bool showMyPosts = false;
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
      userTier = tier;
      WidgetsBinding.instance.addPostFrameCallback((_) => ShowCaseWidget.of(context).startShowCase([key1,key2,key3,key4,key5,key6,key7,key8,key9,key10,key11,key12])); // Assign the result within setState to trigger a rebuild
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
           DrawerHeader(
            decoration:  const BoxDecoration(
              color: Color(0xFF469AB8),
              image: DecorationImage(
                  image: AssetImage('images/WTC_BLANK.png'), fit: BoxFit.cover),
            ),
            child: Showcase(
              key: key5, 
              description: 'press the button in the upperleft corner to view the hamburger menu',  
              onBarrierClick: () {
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
                  showMyPosts = false;
                });
              },
              child: const Text('', style: TextStyle(color: Colors.white)),
              
              ),
          ),
          ListTile(
            leading: Showcase(key: key6, description: "Are you in need of a job? You can check out job postings by Cheney organizations here in the Jobs page.",child: const Icon(Icons.work)),
            title: const Text('Jobs'),
            onTap: () {
              Navigator.pop(context);
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
                showMyPosts = false;
              });
            },
          ),
          ListTile(
            leading: Showcase(
            key: key7, description: 'Interested in volunteering?\nVolunteer postings can be seen in the volunteer page.', 
            child: const Icon(Icons.volunteer_activism),
            onBarrierClick: () {
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
                showMyPosts = false;
              });
            },
            ) ,
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
                showMyPosts = false;
              });
            },
          ),
          ListTile(
            leading: Showcase(key: key8, description: "Any posts created by you can be displayed here under the 'My Posts' page. If you are a poster, you can edit or delete posts; however, regular viewers can only delete posts as posts by a viewer need approval by an admin first.", child: const Icon(Icons.comment), 
            onBarrierClick: () {
              setState(() {
                title = "My Posts";
                prevTitle = "My Posts";
                showJobsPage = false;
                showNotification = false;
                showVolunteerPage = false;
                showApprovePostsPage = false;
                showAboutUsPage = false;
                showSearchUsers = false;
                showAccountUpgradePage = false;
                showSavedPosts = false;
                showMyPosts = true;
              });
            },
            
            ) ,
            title: const Text('My Posts'),
            onTap: () {
              // Navigate to Volunteer page
              Navigator.pop(context);
              setState(() {
                title = "My Posts";
                prevTitle = "My Posts";
                showJobsPage = false;
                showNotification = false;
                showVolunteerPage = false;
                showApprovePostsPage = false;
                showAboutUsPage = false;
                showSearchUsers = false;
                showAccountUpgradePage = false;
                showSavedPosts = false;
                showMyPosts = true;
              });
            },
          ),
          ListTile(
              leading: Showcase(key: key9, description: "You can save any post on the app by pressing the 'Save' button located on a post. The post then can be viewed here. To remove a post, you can tap the 'save' button again.", child: const Icon(Icons.bookmark),
              onBarrierClick: () {
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
                  showMyPosts = false;
              },
              
              ) ,
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
                  showMyPosts = false;
                });
              }),
          (userTier == "Admin" || userTier == "Poster")
              ? ListTile(
                  leading: const Icon(Icons.create),
                  title: const Text('Create Post'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    showCreatePostOptions(context);
                  },
                )
              : ListTile(
                  leading: Showcase(key: key10, description: "Have some information to dispell to the public? Fill out the form under 'Post for Admin Review'. As it reads, if approved by an admin, your form will be posted to the application.", child:  const Icon(Icons.create), 
                  onBarrierClick: () {
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
                      showMyPosts = false;
                    });
                  },
                  ),
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
                  showMyPosts = false;
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
                  showMyPosts = false;
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
                  showMyPosts = false;
                });
              },
            ),
          ListTile(
            leading: Showcase(key: key11, description: "You can see a little bit about the founders and creator of the app, here in the About Us page.",
            child: const Icon(Icons.person),
            onBarrierClick: () {
                setState(() {
                showAboutUsPage = false;
                showJobsPage = false;
                showNotification = false;
                showVolunteerPage = false;
                showApprovePostsPage = false;
                showSearchUsers = false;
                showAccountUpgradePage = false;
                showSavedPosts = false;
                showMyPosts = false;
                scaffoldKey.currentState?.closeDrawer();
                currentPageIndex = 4;
                });

            },
            
            ) ,
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
                showMyPosts = false;
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
      key: scaffoldKey,
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
      drawer: getDrawer(context) ,
      body: Stack(
        children: [
          // Main content of your app
          getPageContent(currentPageIndex),
          // Notification window (conditional rendering)
          if (showNotification ||
              showJobsPage ||
              showVolunteerPage ||
              showApprovePostsPage ||
              showAboutUsPage ||
              showSearchUsers ||
              showAccountUpgradePage ||
              showSavedPosts ||
              showMyPosts)
            const Opacity(opacity: 1, child: ModalBarrier(color: Colors.white)),

          if (showNotification) const NotificationsWindow(),
          if (showJobsPage) const JobsPage(),
          if (showVolunteerPage) const VolunteerPage(),
          if (showApprovePostsPage) const AdminReviewPage(),
          if (showAboutUsPage) const AboutUsPage(),
          if (showSearchUsers) const SearchUserPage(),
          if (showAccountUpgradePage) const AccountReviewPage(),
          if (showSavedPosts) const SavedPosts(),
          if (showMyPosts) const MyPostsPage()
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
            showSearchUsers = false;
            showAccountUpgradePage = false;
            showMyPosts = false;
            showSavedPosts = false;
          });
        },
        indicatorColor: Colors.white,
        backgroundColor: const Color(0xFF469AB8),
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
           NavigationDestination(
              label: "Alerts",
              selectedIcon:  Showcase(
              key: key4, 
              description: 'View all alert posts in the alert page.', 
              child: const Icon(Icons.crisis_alert), 
              onBarrierClick: () {
                scaffoldKey.currentState?.openDrawer();
              }),
              icon: const Icon(Icons.crisis_alert_outlined),
              ),
            
          NavigationDestination(
              label: "Maps", selectedIcon: Showcase(
              key: key2, 
              description: "Do you want to know about the businesses in Cheney?\n\nWithin the map page, you can browse all of the app registered organizations. You can see where they're located and what they're all about!", 
              targetShapeBorder: const CircleBorder(), 
              child: const Icon(Icons.map),
              onBarrierClick: () {
                setState(() {
                  currentPageIndex = 3;
                },);
              },), 
              icon: const Icon(Icons.map_outlined)  ),
          NavigationDestination(
              label: "Home", icon:  const Icon(Icons.home_outlined), 
              selectedIcon: Showcase(
                key: key1, 
                targetShapeBorder: const CircleBorder(), 
                description: 'Hello there!\n\nPlease tap on the screen to learn about using the Welcome to Cheney notification app. We will start at the home page as this will be center of the app!\n\nThis is the homepage, here you can find all posts relevant to your selected tags. ', 
                child: const Icon(Icons.home_outlined), onBarrierClick: () {
                setState(() {
                  currentPageIndex = 1;
                });
              },)),
          NavigationDestination(
              label: "Calendar",
              icon: const Icon(Icons.calendar_month_outlined),
              selectedIcon:  Showcase(
                key: key3, description: "Welcome to Cheney is about keeping you up to date on what's happening in the city. You can view events relevant to your selected tags in the Calendar page.", 
                child: const Icon(Icons.calendar_month),
                onBarrierClick: () {
                  setState(() {
                    currentPageIndex = 0;
                  });
                },
          )),
          NavigationDestination(
              label: "Account",
              selectedIcon: Showcase(key: key12, description: "Last but not least, we have the account page!\n\nHere, you can view and edit all of your account information. In the setting button, you can edit your profile, edit your personal tags, link outside accounts to your WTC account, apply to be a poster, or delete your account. To log out, press the logout button.\n\n That's about it, we hope you find our app useful!", child: const Icon(Icons.manage_accounts),
              onBarrierClick: () {
                setState(() {
                  currentPageIndex = 2;
                });
              },
              ) ,
              icon: const Icon(Icons.manage_accounts_outlined))
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

import 'package:flutter/material.dart';
// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:nex_planner/pages/HomePage/gradient_container.dart';

import 'category_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _bottomNavController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _bottomNavController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bottomNavController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu, size: 35),
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: const CircleAvatar(
                  backgroundImage: AssetImage(
                      'lib/assets/image1.png'), // Replace with your profile image asset
                ),
                onPressed: () {
                  // Implement profile action here
                },
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF6431F4),
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Hello Anwar',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'how is your study',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.search, size: 35),
                  onPressed: () {
                    // Implement search action here
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const GradientContainer(),
            const SizedBox(height: 20),
            const Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Academics'),
                Tab(text: 'Services'),
                Tab(text: 'Tools'),
                Tab(text: 'Campus Life'),
              ],
              controller: _tabController,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  CategoryTab(
                    items: [
                      CategoryItem(
                        icon: Icons.school,
                        title: 'About JIT',
                        description:
                            'Brief description about Jimma Institute of Technology University.',
                      ),
                      CategoryItem(
                        icon: Icons.calendar_month,
                        title: 'Academic Calendar',
                        description:
                            'Academic calendar of five consecutive years.',
                      ),
                      CategoryItem(
                        icon: Icons.home,
                        title: 'Departments',
                        description:
                            'Departments currently available in the university.',
                      ),
                    ],
                  ),
                  CategoryTab(
                    items: [
                      CategoryItem(
                        icon: Icons.menu_book,
                        title: 'Cafe Menu',
                        description: 'Read menu for students cafe.',
                      ),
                    ],
                  ),
                  CategoryTab(
                    items: [
                      CategoryItem(
                        icon: Icons.calculate,
                        title: 'Grade Calculator',
                        description: 'Academic year result grade calculator.',
                      ),
                      CategoryItem(
                        icon: Icons.calendar_month,
                        title: 'Class Schedule',
                        description: 'Academic year result grade calculator.',
                      ),
                      CategoryItem(
                        icon: Icons.lock_clock,
                        title: 'Daily Reminder',
                        description: 'Academic year result grade calculator.',
                      ),
                      CategoryItem(
                        icon: Icons.note_add,
                        title: 'Note Saver',
                        description: 'Academic year result grade calculator.',
                      ),
                    ],
                  ),
                  CategoryTab(
                    items: [
                      CategoryItem(
                        icon: Icons.browse_gallery,
                        title: 'Gallery',
                        description: 'University gallery.',
                      ),
                      CategoryItem(
                        icon: Icons.heat_pump_sharp,
                        title: 'Religious',
                        description: 'Religious clubs in the campus',
                      ),
                      CategoryItem(
                        icon: Icons.grading_rounded,
                        title: 'My Grade',
                        description:
                            'See your grade from the official website of the university',
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      // bottomNavigationBar: ConvexAppBar(
      //   backgroundColor: const Color(0xFF6431F4),
      //   items: const [
      //     TabItem(icon: Icons.home, title: 'Home'),
      //     TabItem(icon: Icons.settings, title: 'settings'),
      //     TabItem(icon: Icons.school, title: 'academics'),
      //     TabItem(icon: Icons.person, title: 'Profile'),
      //   ],
      //   controller: _bottomNavController,
      //   onTap: (int index) {
      //     _bottomNavController.animateTo(index);
      //   },
      // ),
    );
  }
}

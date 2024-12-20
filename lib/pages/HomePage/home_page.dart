import 'package:flutter/material.dart';
// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:nex_planner/pages/HomePage/gradient_container.dart';

import '../Category/category_detail.dart';
import 'category_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _bottomNavController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<CategoryItem> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _bottomNavController = TabController(length: 4, vsync: this);
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _searchResults.clear();
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    final allItems = [
      ..._getCategoryItems(0),
      ..._getCategoryItems(1),
      ..._getCategoryItems(2),
      ..._getCategoryItems(3),
    ];

    setState(() {
      _searchResults = allItems
          .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  List<CategoryItem> _getCategoryItems(int index) {
    switch (index) {
      case 0:
        return [
          CategoryItem(
            icon: Icons.school,
            title: 'About JIT',
            description: 'Brief description about Jimma Institute of Technology University.',
          ),
          CategoryItem(
            icon: Icons.calendar_month,
            title: 'Academic Calendar',
            description: 'Academic calendar of five consecutive years.',
          ),
          CategoryItem(
            icon: Icons.home,
            title: 'Departments',
            description: 'Departments currently available in the university.',
          ),
        ];
      case 1:
        return [
          CategoryItem(
            icon: Icons.menu_book,
            title: 'Cafe Menu',
            description: 'Read menu for students cafe.',
          ),
        ];
      case 2:
        return [
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
        ];
      case 3:
        return [
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
            description: 'See your grade from the official website of the university',
          ),
        ];
      default:
        return [];
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bottomNavController.dispose();
    _searchController.dispose();
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
            title: _isSearching
                ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
              onChanged: _performSearch,
            )
                : const Text(''),
            actions: <Widget>[
              IconButton(
                icon: _isSearching ? const Icon(Icons.close) : const Icon(Icons.search, size: 35),
                onPressed: _isSearching ? _stopSearch : _startSearch,
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
      body: _isSearching
          ? _buildSearchResults()
          : Padding(
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
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'how is your study',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                IconButton(
                  icon: const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('lib/assets/image1.png'),
                  ),
                  onPressed: () {
                    // Implement profile action here
                  },
                ),
                // IconButton(
                //   icon: const Icon(Icons.search, size: 35),
                //   onPressed: _startSearch,
                // ),
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
                    items: _getCategoryItems(0),
                  ),
                  CategoryTab(
                    items: _getCategoryItems(1),
                  ),
                  CategoryTab(
                    items: _getCategoryItems(2),
                  ),
                  CategoryTab(
                    items: _getCategoryItems(3),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return ListTile(
          title: Text(item.title),
          subtitle: Text(item.description),
          leading: Icon(item.icon),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryDetailScreen(categoryName: item.title),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:jobbiteproject/views/customappbar.dart';
import 'package:jobbiteproject/views/student/jobspage.dart';
import 'package:jobbiteproject/views/student/studentapplicationspage.dart';
import 'package:jobbiteproject/views/student/studentprofilepage.dart';

class StudentMainPage extends StatefulWidget {
  const StudentMainPage({super.key, this.pagenumber = 0});
  final int pagenumber;
  @override
  State<StudentMainPage> createState() => _StudentMainPageState();
}

class _StudentMainPageState extends State<StudentMainPage> {
  int _selectedIndex = 0;

  late PageController pageController;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pagenumber;
    pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  final List<Widget> _widgetOptions = <Widget>[
    JobsPage(),
    StudentApplicationsPage(),
    StudentProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return /* MaterialApp(
        home: Scaffold(
      appBar: CustomAppBar(
        backButton: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'İşler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Bildirimler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: _onItemTapped,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
    ));*/
        MaterialApp(
            home: Scaffold(
                appBar: CustomAppBar(backButton: false),
                body: SizedBox.expand(
                  child: PageView(
                      controller: pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      children: _widgetOptions),
                ),
                bottomNavigationBar: BottomNavyBar(
                  selectedIndex: _selectedIndex,
                  items: [
                    BottomNavyBarItem(icon: const Icon(Icons.business), title: const Text('İşler')),
                    BottomNavyBarItem(icon: const Icon(Icons.settings_applications), title: const Text('Başvurularım')),
                    BottomNavyBarItem(icon: const Icon(Icons.account_circle), title: const Text('Profil')),
                  ],
                  onItemSelected: (index) {
                    setState(() {
                      pageController.jumpToPage(index);
                    });
                  },
                )));
  }
}

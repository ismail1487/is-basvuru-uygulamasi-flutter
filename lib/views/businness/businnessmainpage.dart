import 'package:flutter/material.dart';
import 'package:jobbiteproject/views/businness/jobspage.dart';
import 'package:jobbiteproject/views/businness/workplacespage.dart';
import 'package:jobbiteproject/views/businness/businessprofilepage.dart';
import 'package:jobbiteproject/views/customappbar.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class BusinnessMainPage extends StatefulWidget {
  const BusinnessMainPage({super.key, this.pagenumber = 0});
  final int pagenumber;
  @override
  State<BusinnessMainPage> createState() => _BusinnessMainPageState(pagenumber);
}

class _BusinnessMainPageState extends State<BusinnessMainPage> {
  int _selectedIndex;
  late PageController pageController;
  _BusinnessMainPageState(this._selectedIndex);
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  final List<Widget> _widgetOptions = <Widget>[WorkplacesPage(), JobsPage(), BusinessProfilePage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                BottomNavyBarItem(icon: const Icon(Icons.add_business), title: const Text('İşyeri Ekle')),
                BottomNavyBarItem(icon: const Icon(Icons.add_box), title: const Text('İlan Ekle')),
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

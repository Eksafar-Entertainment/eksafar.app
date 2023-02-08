import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/redux/actions.dart';
import 'package:eksafar/screens/guest_screen.dart';
import 'package:eksafar/screens/home_screen.dart';
import 'package:eksafar/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController page = PageController(initialPage: 0);
  int pageIndex = 0;
  void _onItemTapped(int index) {
    page.jumpToPage(index);
    setState(() {
      pageIndex = index;
    });
  }

  checkCredentials() async{
    final prefs = await SharedPreferences.getInstance();
    Store<AppState> store = StoreProvider.of(context);
    store.dispatch(SaveTokenAction(prefs.getString("access_token")!));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCredentials();
  }


  @override
  Widget build(BuildContext _context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
            body: PageView(
              controller: page,
              scrollDirection: Axis.horizontal,
              pageSnapping: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                HomeScreen(),
                HomeScreen(),
                state.accessToken!=null? ProfileScreen(): GuestScreen(),
                state.accessToken!=null? ProfileScreen(): GuestScreen(),
              ],
          ),
            bottomNavigationBar: NavigationBar(
              destinations: const <Widget>[
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite),
                  label: 'Favorite',
                ),
                NavigationDestination(
                  icon: Icon(Icons.discount),
                  label: 'Tickets',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_circle),
                  label: 'Profile',
                ),
              ],
              selectedIndex: pageIndex,
              onDestinationSelected: _onItemTapped,
            ),
          );
        }
    );
  }
}